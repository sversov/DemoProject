import SwiftUI

struct StarterPromptChip: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.cardBackground, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct PromptChipRow: View {
    let prompts: [String]
    let onTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(prompts, id: \.self) { p in
                    StarterPromptChip(text: p) { onTap(p) }
                }
            }
            .padding(.horizontal)
        }
    }
}
