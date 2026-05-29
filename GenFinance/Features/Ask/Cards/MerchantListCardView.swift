import SwiftUI

struct MerchantListCardView: View {
    let list: MerchantList

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(list.title)
                    .font(.headline)
                VStack(spacing: 0) {
                    ForEach(list.merchants, id: \.merchant) { row in
                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(row.merchant)
                                        .font(.subheadline.weight(.medium))
                                    Text("\(row.count) \(row.count == 1 ? "transaction" : "transactions")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(row.amount.asCurrency)
                                    .font(.subheadline.monospacedDigit())
                            }
                            .padding(.vertical, 8)
                            if row.merchant != list.merchants.last?.merchant {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MerchantListCardView(list: .init(title: "Top merchants", merchants: [
        .init(merchant: "Whole Foods", amount: 412.18, count: 6),
        .init(merchant: "Starbucks", amount: 89.50, count: 12),
        .init(merchant: "Uber", amount: 142.30, count: 8),
    ]))
    .padding()
    .background(Color.pageBackground)
}
