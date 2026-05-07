import Foundation

struct Transaction: Identifiable, Codable, Hashable, Sendable {
    let id: String
    var amount: Double
    var merchant: String
    var category: Category
    var date: Date
    var note: String?

    init(
        id: String = UUID().uuidString,
        amount: Double,
        merchant: String,
        category: Category,
        date: Date,
        note: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.merchant = merchant
        self.category = category
        self.date = date
        self.note = note
    }

    var isExpense: Bool { amount > 0 && category != .income }
}
