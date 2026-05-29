import SwiftUI
import Charts

struct TimeSeriesCardView: View {
    let chart: TimeSeriesChart

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(chart.title)
                    .font(.headline)
                Chart(chart.points, id: \.label) { point in
                    BarMark(
                        x: .value("Period", point.label),
                        y: .value("Amount", point.amount)
                    )
                    .cornerRadius(4)
                }
                .frame(height: 160)
                .chartYAxis {
                    AxisMarks(format: .currency(code: "USD").precision(.fractionLength(0)))
                }
            }
        }
    }
}

#Preview {
    TimeSeriesCardView(chart: .init(title: "Weekly spend", points: [
        .init(label: "W1", amount: 412),
        .init(label: "W2", amount: 389),
        .init(label: "W3", amount: 521),
        .init(label: "W4", amount: 460),
    ]))
    .padding()
    .background(Color.pageBackground)
}
