import SwiftUI
import Charts

struct CategoryDonutCardView: View {
    let donut: CategoryDonut

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(donut.title)
                    .font(.headline)
                if donut.slices.isEmpty {
                    Text("No data").foregroundStyle(.secondary)
                } else {
                    Chart(donut.slices, id: \.category) { slice in
                        SectorMark(
                            angle: .value("Amount", slice.amount),
                            innerRadius: .ratio(0.55),
                            angularInset: 2
                        )
                        .cornerRadius(4)
                        .foregroundStyle(by: .value("Category", slice.category.displayName))
                    }
                    .frame(height: 180)

                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(donut.slices, id: \.category) { slice in
                            HStack(spacing: 8) {
                                Circle().frame(width: 8, height: 8)
                                Text(slice.category.displayName)
                                    .font(.subheadline)
                                Spacer()
                                Text(slice.amount.asCurrency)
                                    .font(.subheadline.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryDonutCardView(donut: .init(title: "Where it went", slices: [
        .init(category: .housing, amount: 2200),
        .init(category: .groceries, amount: 540),
        .init(category: .dining, amount: 380),
        .init(category: .transport, amount: 215),
    ]))
    .padding()
    .background(Color.pageBackground)
}
