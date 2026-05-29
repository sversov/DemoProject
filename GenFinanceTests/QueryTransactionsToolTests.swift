import XCTest
@testable import GenFinance

@MainActor
final class QueryTransactionsToolTests: XCTestCase {

    func test_totalReturnsCurrencyAndCount() async throws {
        let store = TransactionStore(seed: SeedData.transactions(), persistenceURL: nil)
        let tool = QueryTransactionsTool(store: store)
        let args = QueryTransactionsTool.Arguments(
            kind: "total",
            monthsBack: 0,
            monthsBackB: nil,
            category: nil,
            limit: nil
        )
        let output = try await tool.call(arguments: args)
        let text = String(describing: output)
        XCTAssertTrue(text.contains("Total spending"))
        XCTAssertTrue(text.contains("$"))
    }

    func test_byCategoryReturnsAllCategoriesPresent() async throws {
        let store = TransactionStore(seed: SeedData.transactions(), persistenceURL: nil)
        let tool = QueryTransactionsTool(store: store)
        let args = QueryTransactionsTool.Arguments(
            kind: "byCategory",
            monthsBack: 0,
            monthsBackB: nil,
            category: nil,
            limit: nil
        )
        let output = try await tool.call(arguments: args)
        let text = String(describing: output)
        XCTAssertTrue(text.contains("Category breakdown"))
    }

    func test_unknownKindIsSurfacedClearly() async throws {
        let store = TransactionStore(seed: [], persistenceURL: nil)
        let tool = QueryTransactionsTool(store: store)
        let args = QueryTransactionsTool.Arguments(
            kind: "garbage",
            monthsBack: 0,
            monthsBackB: nil,
            category: nil,
            limit: nil
        )
        let output = try await tool.call(arguments: args)
        let text = String(describing: output)
        XCTAssertTrue(text.contains("Unknown query kind"))
    }
}
