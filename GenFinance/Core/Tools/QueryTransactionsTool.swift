import Foundation
import FoundationModels

struct QueryTransactionsTool: Tool {
    let name = "queryTransactions"
    let description = """
        Look up the user's spending. Choose one kind:
        - "total": total expenses in the period (optionally filtered by category)
        - "byCategory": breakdown by category for the period
        - "topMerchants": top merchants by spend (uses limit, default 5)
        - "timeSeries": weekly totals across the period
        - "compareMonths": compare two periods (uses monthsBackB)
        Always pass monthsBack: 0 = current month, 1 = last month, etc.
        """

    @Generable
    struct Arguments: Sendable {
        @Guide(description: "Query kind: total | byCategory | topMerchants | timeSeries | compareMonths")
        let kind: String
        @Guide(description: "Months back from today; 0 = current calendar month")
        let monthsBack: Int
        @Guide(description: "Second period for compareMonths; ignored otherwise")
        let monthsBackB: Int?
        @Guide(description: "Category filter for kind='total'; ignored otherwise")
        let category: Category?
        @Guide(description: "Result count limit for kind='topMerchants'; default 5")
        let limit: Int?
    }

    let store: TransactionStore

    @MainActor
    func call(arguments: Arguments) async throws -> ToolOutput {
        let cal = Calendar(identifier: .gregorian)
        let now = Date()

        func range(monthsBack: Int) -> ClosedRange<Date> {
            let monthStart = cal.date(byAdding: .month, value: -monthsBack, to: cal.startOfMonth(for: now)) ?? now
            let monthEnd = cal.date(byAdding: .month, value: 1, to: monthStart)?.addingTimeInterval(-1) ?? monthStart
            return monthStart...monthEnd
        }

        func label(monthsBack: Int) -> String {
            let monthStart = cal.date(byAdding: .month, value: -monthsBack, to: cal.startOfMonth(for: now)) ?? now
            let f = DateFormatter()
            f.dateFormat = "LLL yyyy"
            return f.string(from: monthStart)
        }

        switch arguments.kind {
        case "total":
            let r = range(monthsBack: arguments.monthsBack)
            let total = store.total(in: r, category: arguments.category)
            let count = store.transactions(in: r).filter { $0.isExpense && (arguments.category == nil || $0.category == arguments.category) }.count
            let scope = arguments.category.map { "in \($0.displayName)" } ?? "across all categories"
            return ToolOutput("Total spending \(scope) in \(label(monthsBack: arguments.monthsBack)): $\(format(total)) across \(count) transactions.")

        case "byCategory":
            let r = range(monthsBack: arguments.monthsBack)
            let totals = store.totalsByCategory(in: r)
            let lines = totals.map { "  - \($0.category.displayName): $\(format($0.amount))" }.joined(separator: "\n")
            return ToolOutput("Category breakdown in \(label(monthsBack: arguments.monthsBack)):\n\(lines)")

        case "topMerchants":
            let r = range(monthsBack: arguments.monthsBack)
            let limit = arguments.limit ?? 5
            let tops = store.totalsByMerchant(in: r, limit: limit)
            let lines = tops.map { "  - \($0.merchant): $\(format($0.amount)) (\($0.count) txns)" }.joined(separator: "\n")
            return ToolOutput("Top \(limit) merchants in \(label(monthsBack: arguments.monthsBack)):\n\(lines)")

        case "timeSeries":
            let r = range(monthsBack: arguments.monthsBack)
            let weeks = weeklyTotals(in: r, cal: cal)
            let lines = weeks.map { "  - \($0.label): $\(format($0.amount))" }.joined(separator: "\n")
            return ToolOutput("Weekly spending in \(label(monthsBack: arguments.monthsBack)):\n\(lines)")

        case "compareMonths":
            let a = range(monthsBack: arguments.monthsBack)
            let b = range(monthsBack: arguments.monthsBackB ?? arguments.monthsBack + 1)
            let totalA = store.total(in: a)
            let totalB = store.total(in: b)
            let delta = totalB > 0 ? (totalA - totalB) / totalB : 0
            return ToolOutput("""
                \(label(monthsBack: arguments.monthsBack)): $\(format(totalA))
                \(label(monthsBack: arguments.monthsBackB ?? arguments.monthsBack + 1)): $\(format(totalB))
                Change: \(format(delta * 100))%
                """)

        default:
            return ToolOutput("Unknown query kind '\(arguments.kind)'. Use one of: total, byCategory, topMerchants, timeSeries, compareMonths.")
        }
    }

    private func weeklyTotals(in range: ClosedRange<Date>, cal: Calendar) -> [(label: String, amount: Double)] {
        var current = range.lowerBound
        var result: [(String, Double)] = []
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        while current < range.upperBound {
            let weekEnd = min(cal.date(byAdding: .day, value: 7, to: current) ?? range.upperBound, range.upperBound)
            let weekRange = current...weekEnd
            let total = store.total(in: weekRange)
            result.append((f.string(from: current), total))
            current = weekEnd.addingTimeInterval(1)
        }
        return result
    }

    private func format(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        self.date(from: dateComponents([.year, .month], from: date)) ?? date
    }
}
