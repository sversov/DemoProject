import SwiftUI

struct HeadlineStatCardView: View {
    let stat: HeadlineStat

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(stat.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(stat.value)
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                TrendBadge(trend: stat.trend)
            }
        }
    }
}

private struct TrendBadge: View {
    let trend: Double

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: trend >= 0 ? "arrow.up.right" : "arrow.down.right")
            Text(trend.asSignedPercent)
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(trend >= 0 ? Color.red : Color.green)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background((trend >= 0 ? Color.red : Color.green).opacity(0.12), in: Capsule())
    }
}

#Preview {
    HeadlineStatCardView(stat: .init(title: "Spending this month", value: "$2,143", trend: 0.18))
        .padding()
        .background(Color.pageBackground)
}
