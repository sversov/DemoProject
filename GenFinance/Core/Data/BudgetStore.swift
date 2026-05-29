import Foundation
import Observation

@MainActor
@Observable
final class BudgetStore {
    private(set) var budgets: [Budget]

    private let persistenceURL: URL?

    init(seed: [Budget] = SeedData.budgets(), persistenceURL: URL? = BudgetStore.defaultPersistenceURL) {
        self.persistenceURL = persistenceURL
        if let url = persistenceURL,
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder.iso.decode([Budget].self, from: data) {
            self.budgets = decoded
        } else {
            self.budgets = seed
        }
    }

    func setLimit(_ amount: Double, for category: Category) {
        if let idx = budgets.firstIndex(where: { $0.category == category }) {
            budgets[idx].monthlyLimit = amount
        } else {
            budgets.append(Budget(category: category, monthlyLimit: amount))
        }
        persist()
    }

    func limit(for category: Category) -> Double? {
        budgets.limit(for: category)
    }

    private func persist() {
        guard let persistenceURL else { return }
        if let data = try? JSONEncoder.iso.encode(budgets) {
            try? data.write(to: persistenceURL, options: .atomic)
        }
    }

    static var defaultPersistenceURL: URL? {
        let fm = FileManager.default
        guard let dir = try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        return dir.appendingPathComponent("budgets.json")
    }
}
