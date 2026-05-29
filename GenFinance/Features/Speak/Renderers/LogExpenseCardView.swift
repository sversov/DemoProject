import SwiftUI

struct LogExpenseCardView: View {
    let extracted: ExtractedTransaction
    let onDismiss: () -> Void

    @Environment(\.saveTransaction) private var saveTransaction
    @State private var amount: Double
    @State private var merchant: String
    @State private var category: Category
    @State private var note: String

    init(extracted: ExtractedTransaction, onDismiss: @escaping () -> Void) {
        self.extracted = extracted
        self.onDismiss = onDismiss
        _amount = State(initialValue: extracted.amount)
        _merchant = State(initialValue: extracted.merchant)
        _category = State(initialValue: extracted.category)
        _note = State(initialValue: extracted.note ?? "")
    }

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Log expense", systemImage: "plus.circle.fill")
                    .font(.headline)
                row("Amount") {
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                }
                row("Merchant") {
                    TextField("Merchant", text: $merchant)
                }
                row("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases.filter { $0 != .income }, id: \.self) { cat in
                            Label(cat.displayName, systemImage: cat.systemImage).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                row("Note") {
                    TextField("Note (optional)", text: $note)
                }
                HStack {
                    Button("Cancel", role: .cancel, action: onDismiss)
                        .buttonStyle(.bordered)
                    Spacer()
                    Button {
                        let date = ISO8601DateFormatter().date(from: extracted.dateISO + "T12:00:00Z") ?? Date()
                        let txn = Transaction(
                            amount: amount,
                            merchant: merchant,
                            category: category,
                            date: date,
                            note: note.isEmpty ? nil : note
                        )
                        saveTransaction.save(txn)
                        onDismiss()
                    } label: {
                        Label("Save", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    @ViewBuilder
    private func row<Content: View>(_ label: String, @ViewBuilder _ content: () -> Content) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).font(.caption).foregroundStyle(.secondary).frame(width: 80, alignment: .leading)
            content()
            Spacer()
        }
    }
}
