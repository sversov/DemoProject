import XCTest
import SwiftUI
@testable import GenFinance

#if canImport(SnapshotTesting)
import SnapshotTesting

@MainActor
final class CardRendererSnapshotTests: XCTestCase {

    func test_headlineStat() {
        let view = HeadlineStatCardView(stat: .init(title: "Spending this month", value: "$2,143", trend: 0.18))
            .frame(width: 360)
            .padding()
            .background(Color.pageBackground)
        assertSnapshot(of: view, as: .image)
    }

    func test_advice_warning() {
        let view = AdviceCardView(advice: .init(text: "You're on pace to spend $300 over your dining budget.", severity: .warning))
            .frame(width: 360)
            .padding()
            .background(Color.pageBackground)
        assertSnapshot(of: view, as: .image)
    }

    func test_comparison() {
        let view = ComparisonCardView(comparison: .init(
            leftLabel: "June",
            leftValue: "$1,890",
            rightLabel: "July",
            rightValue: "$2,143",
            deltaPct: 0.13
        ))
        .frame(width: 360)
        .padding()
        .background(Color.pageBackground)
        assertSnapshot(of: view, as: .image)
    }
}
#else
@MainActor
final class CardRendererSnapshotTests: XCTestCase {
    func test_skip_addSnapshotTesting() {
        // Add the swift-snapshot-testing Swift package to the GenFinanceTests target
        // (https://github.com/pointfreeco/swift-snapshot-testing) to enable these tests.
    }
}
#endif
