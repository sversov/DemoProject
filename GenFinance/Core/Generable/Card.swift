import FoundationModels

@Generable
enum Severity: String, Codable, Sendable {
    case info
    case warning
    case alert
}

@Generable
struct CategorySlice: Sendable {
    @Guide(description: "Spending category")
    let category: Category
    @Guide(description: "Total amount in dollars for this category")
    let amount: Double
}

@Generable
struct DatedAmount: Sendable {
    @Guide(description: "Short label like 'Mon', 'Apr 3', or 'Week 14'")
    let label: String
    @Guide(description: "Amount in dollars")
    let amount: Double
}

@Generable
struct MerchantSpend: Sendable {
    let merchant: String
    @Guide(description: "Total spent at this merchant in dollars")
    let amount: Double
    @Guide(description: "Number of transactions")
    let count: Int
}

@Generable
struct HeadlineStat: Sendable {
    @Guide(description: "Short title, e.g. 'Spending this month'")
    let title: String
    @Guide(description: "Formatted value, e.g. '$1,243' or '12 transactions'")
    let value: String
    @Guide(description: "Trend vs prior period as a fraction from -1 to 1; positive means up", .range(-1.0...1.0))
    let trend: Double
}

@Generable
struct CategoryDonut: Sendable {
    let title: String
    @Guide(description: "Category breakdown, 2 to 8 slices, largest first", .count(2...8))
    let slices: [CategorySlice]
}

@Generable
struct TimeSeriesChart: Sendable {
    let title: String
    @Guide(description: "Time-ordered points, oldest first", .count(3...12))
    let points: [DatedAmount]
}

@Generable
struct MerchantList: Sendable {
    let title: String
    @Guide(description: "Top merchants by spend, 3 to 8 items, largest first", .count(3...8))
    let merchants: [MerchantSpend]
}

@Generable
struct Comparison: Sendable {
    let leftLabel: String
    let leftValue: String
    let rightLabel: String
    let rightValue: String
    @Guide(description: "Percent change from left to right, e.g. 0.18 means +18%", .range(-1.0...5.0))
    let deltaPct: Double
}

@Generable
struct Advice: Sendable {
    @Guide(description: "One short, actionable sentence")
    let text: String
    let severity: Severity
}

@Generable
enum Card: Sendable {
    case headlineStat(HeadlineStat)
    case categoryDonut(CategoryDonut)
    case timeSeriesChart(TimeSeriesChart)
    case merchantList(MerchantList)
    case comparison(Comparison)
    case advice(Advice)
}

@Generable
struct CardResponse: Sendable {
    @Guide(description: "Pick the cards that best answer the user's question. Mix component types when appropriate. 2 to 6 cards.", .count(2...6))
    let cards: [Card]
}
