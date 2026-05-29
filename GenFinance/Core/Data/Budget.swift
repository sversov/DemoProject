import Foundation

struct Budget: Codable, Hashable, Sendable {
    var category: Category
    var monthlyLimit: Double
}

extension Array where Element == Budget {
    func limit(for category: Category) -> Double? {
        first(where: { $0.category == category })?.monthlyLimit
    }
}
