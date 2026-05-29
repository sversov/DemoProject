import Foundation
import Observation

@MainActor
@Observable
final class TransactionStore {
    private(set) var transactions: [Transaction]

    private let persistenceURL: URL?

    init(seed: [Transaction] = SeedData.transactions(), persistenceURL: URL? = TransactionStore.defaultPersistenceURL) {
        self.persistenceURL = persistenceURL
        if let url = persistenceURL,
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder.iso.decode([Transaction].self, from: data) {
            self.transactions = decoded
        } else {
            self.transactions = seed
        }
    }

    func add(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
        persist()
    }

    func remove(id: String) {
        transactions.removeAll { $0.id == id }
        persist()
    }

    func transactions(in range: ClosedRange<Date>) -> [Transaction] {
        transactions.filter { range.contains($0.date) }
    }

    func transactions(in range: ClosedRange<Date>, category: Category) -> [Transaction] {
        transactions.filter { range.contains($0.date) && $0.category == category }
    }

    func total(in range: ClosedRange<Date>, category: Category? = nil) -> Double {
        transactions
            .filter { range.contains($0.date) && (category == nil || $0.category == category) && $0.isExpense }
            .reduce(0) { $0 + $1.amount }
    }

    func totalsByCategory(in range: ClosedRange<Date>) -> [(category: Category, amount: Double)] {
        Dictionary(grouping: transactions.filter { range.contains($0.date) && $0.isExpense }, by: \.category)
            .map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }

    func totalsByMerchant(in range: ClosedRange<Date>, limit: Int = 10) -> [(merchant: String, amount: Double, count: Int)] {
        Dictionary(grouping: transactions.filter { range.contains($0.date) && $0.isExpense }, by: \.merchant)
            .map { (merchant: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }, count: $0.value.count) }
            .sorted { $0.amount > $1.amount }
            .prefix(limit)
            .map { $0 }
    }

    private func persist() {
        guard let persistenceURL else { return }
        if let data = try? JSONEncoder.iso.encode(transactions) {
            try? data.write(to: persistenceURL, options: .atomic)
        }
    }

    static var defaultPersistenceURL: URL? {
        let fm = FileManager.default
        guard let dir = try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        return dir.appendingPathComponent("transactions.json")
    }
}

extension JSONEncoder {
    static let iso: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
}

extension JSONDecoder {
    static let iso: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
}
