import Foundation

@MainActor
protocol AdjustBudgetTool: AnyObject {
    func adjust(category: Category, newLimit: Double)
}

@MainActor
final class LiveAdjustBudgetTool: AdjustBudgetTool {
    private let store: BudgetStore
    init(store: BudgetStore) { self.store = store }
    func adjust(category: Category, newLimit: Double) {
        store.setLimit(newLimit, for: category)
    }
}
