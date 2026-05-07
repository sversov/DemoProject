import SwiftUI

enum Theme {
    static let cardCornerRadius: CGFloat = 18
    static let cardPadding: CGFloat = 16
    static let cardSpacing: CGFloat = 12

    enum Severity {
        static func tint(_ severity: Severity) -> Color {
            switch severity {
            case .info: .blue
            case .warning: .orange
            case .alert: .red
            }
        }
    }
}

extension Color {
    static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
    static let pageBackground = Color(uiColor: .systemGroupedBackground)
}

extension Double {
    var asCurrency: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = self.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        return f.string(from: NSNumber(value: self)) ?? "$\(self)"
    }

    var asPercent: String {
        let f = NumberFormatter()
        f.numberStyle = .percent
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: self)) ?? "\(Int(self * 100))%"
    }

    var asSignedPercent: String {
        let s = self >= 0 ? "+" : ""
        return s + asPercent
    }
}
