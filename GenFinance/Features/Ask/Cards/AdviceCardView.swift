import SwiftUI

struct AdviceCardView: View {
    let advice: Advice

    var body: some View {
        GenerativeCard {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Theme.Severity.tint(advice.severity))
                Text(advice.text)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var icon: String {
        switch advice.severity {
        case .info: "lightbulb"
        case .warning: "exclamationmark.bubble"
        case .alert: "exclamationmark.triangle.fill"
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        AdviceCardView(advice: .init(text: "You're on pace to spend $300 over your dining budget.", severity: .warning))
        AdviceCardView(advice: .init(text: "Income exceeds spending by $1,240 this month — nice work.", severity: .info))
        AdviceCardView(advice: .init(text: "Three subscriptions you haven't used in 30 days.", severity: .alert))
    }
    .padding()
    .background(Color.pageBackground)
}
