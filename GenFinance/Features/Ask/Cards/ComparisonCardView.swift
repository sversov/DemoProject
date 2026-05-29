import SwiftUI

struct ComparisonCardView: View {
    let comparison: Comparison

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    column(label: comparison.leftLabel, value: comparison.leftValue)
                    Divider().frame(height: 60)
                    column(label: comparison.rightLabel, value: comparison.rightValue)
                }
                HStack(spacing: 6) {
                    Image(systemName: comparison.deltaPct >= 0 ? "arrow.up.right" : "arrow.down.right")
                    Text(comparison.deltaPct.asSignedPercent)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(comparison.deltaPct >= 0 ? Color.red : Color.green)
            }
        }
    }

    private func column(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ComparisonCardView(comparison: .init(
        leftLabel: "June",
        leftValue: "$1,890",
        rightLabel: "July",
        rightValue: "$2,143",
        deltaPct: 0.13
    ))
    .padding()
    .background(Color.pageBackground)
}
