import XCTest
@testable import GenFinance

final class SeedDataTests: XCTestCase {

    func test_seedHasReasonableVolume() {
        let txns = SeedData.transactions()
        XCTAssertGreaterThan(txns.count, 100, "Seed should produce a meaningful sample")
    }

    func test_seedSpansSixMonths() {
        let txns = SeedData.transactions()
        let cal = Calendar(identifier: .gregorian)
        let months = Set(txns.map { cal.component(.month, from: $0.date) })
        XCTAssertGreaterThanOrEqual(months.count, 5, "Seed should span at least 5 distinct months")
    }

    func test_seedIncludesIncomeAndExpenses() {
        let txns = SeedData.transactions()
        XCTAssertTrue(txns.contains { $0.category == .income })
        XCTAssertTrue(txns.contains { $0.category == .groceries })
        XCTAssertTrue(txns.contains { $0.category == .housing })
    }

    func test_seedIsDeterministic() {
        let a = SeedData.transactions(referenceDate: Date(timeIntervalSince1970: 1_700_000_000))
        let b = SeedData.transactions(referenceDate: Date(timeIntervalSince1970: 1_700_000_000))
        XCTAssertEqual(a.count, b.count)
        XCTAssertEqual(a.first?.merchant, b.first?.merchant)
    }
}
