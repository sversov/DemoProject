import SwiftUI

struct QuickInsightCardView: View {
    let card: Card
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardRendererView(card: card)
            HStack {
                Spacer()
                Button("Done", action: onDismiss)
                    .buttonStyle(.bordered)
            }
        }
    }
}
