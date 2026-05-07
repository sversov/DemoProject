import Foundation

struct Goal: Identifiable, Codable, Hashable, Sendable {
    let id: String
    var name: String
    var targetAmount: Double
    var targetDate: Date
    var monthlyContribution: Double

    init(
        id: String = UUID().uuidString,
        name: String,
        targetAmount: Double,
        targetDate: Date,
        monthlyContribution: Double
    ) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.targetDate = targetDate
        self.monthlyContribution = monthlyContribution
    }
}
