import XCTest
@testable import GenFinance

@MainActor
final class SaveTransactionToolTests: XCTestCase {

    func test_saveAppendsToStore() {
        let store = TransactionStore(seed: [], persistenceURL: nil)
        let tool = LiveSaveTransactionTool(store: store)

        XCTAssertEqual(store.transactions.count, 0)
        let txn = Transaction(amount: 12.50, merchant: "Joe's Pizza", category: .dining, date: Date())
        tool.save(txn)

        XCTAssertEqual(store.transactions.count, 1)
        XCTAssertEqual(store.transactions.first?.merchant, "Joe's Pizza")
        XCTAssertEqual(store.transactions.first?.amount, 12.50)
    }

    func test_spyToolRecordsCalls() {
        let spy = SaveTransactionToolSpy()
        let txn = Transaction(amount: 7, merchant: "Starbucks", category: .dining, date: Date())

        spy.save(txn)
        spy.save(Transaction(amount: 10, merchant: "Uber", category: .transport, date: Date()))

        XCTAssertEqual(spy.calls.count, 2)
        XCTAssertEqual(spy.calls.first?.merchant, "Starbucks")
        XCTAssertEqual(spy.calls.last?.category, .transport)
    }
}

@MainActor
final class SaveTransactionToolSpy: SaveTransactionTool {
    var calls: [Transaction] = []
    func save(_ transaction: Transaction) { calls.append(transaction) }
}
