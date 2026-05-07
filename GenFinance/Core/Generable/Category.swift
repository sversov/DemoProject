import FoundationModels

@Generable
enum Category: String, CaseIterable, Codable, Hashable, Sendable {
    case groceries
    case dining
    case transport
    case utilities
    case entertainment
    case shopping
    case housing
    case healthcare
    case subscriptions
    case income
    case other
}

extension Category {
    var displayName: String {
        switch self {
        case .groceries: "Groceries"
        case .dining: "Dining"
        case .transport: "Transport"
        case .utilities: "Utilities"
        case .entertainment: "Entertainment"
        case .shopping: "Shopping"
        case .housing: "Housing"
        case .healthcare: "Healthcare"
        case .subscriptions: "Subscriptions"
        case .income: "Income"
        case .other: "Other"
        }
    }

    var systemImage: String {
        switch self {
        case .groceries: "cart"
        case .dining: "fork.knife"
        case .transport: "car"
        case .utilities: "bolt"
        case .entertainment: "ticket"
        case .shopping: "bag"
        case .housing: "house"
        case .healthcare: "cross.case"
        case .subscriptions: "rectangle.stack"
        case .income: "arrow.down.circle"
        case .other: "circle.dotted"
        }
    }
}
