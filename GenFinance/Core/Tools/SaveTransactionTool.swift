import Foundation

@MainActor
protocol SaveTransactionTool: AnyObject {
    func save(_ transaction: Transaction)
}

@MainActor
final class LiveSaveTransactionTool: SaveTransactionTool {
    private let store: TransactionStore
    init(store: TransactionStore) { self.store = store }
    func save(_ transaction: Transaction) {
        store.add(transaction)
    }
}
