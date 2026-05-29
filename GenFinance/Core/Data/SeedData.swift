import Foundation

enum SeedData {

    static func budgets() -> [Budget] {
        [
            Budget(category: .groceries, monthlyLimit: 600),
            Budget(category: .dining, monthlyLimit: 400),
            Budget(category: .transport, monthlyLimit: 250),
            Budget(category: .utilities, monthlyLimit: 200),
            Budget(category: .entertainment, monthlyLimit: 150),
            Budget(category: .shopping, monthlyLimit: 300),
            Budget(category: .housing, monthlyLimit: 2200),
            Budget(category: .healthcare, monthlyLimit: 100),
            Budget(category: .subscriptions, monthlyLimit: 100),
        ]
    }

    static func transactions(referenceDate: Date = Date(), monthsBack: Int = 6) -> [Transaction] {
        var rng = SeededRNG(seed: 42)
        let cal = Calendar(identifier: .gregorian)
        var out: [Transaction] = []

        for monthOffset in 0..<monthsBack {
            guard let monthStart = cal.date(byAdding: .month, value: -monthOffset, to: cal.startOfMonth(for: referenceDate)) else { continue }

            out.append(contentsOf: recurring(monthStart: monthStart, cal: cal))
            out.append(contentsOf: groceries(monthStart: monthStart, cal: cal, rng: &rng))
            out.append(contentsOf: dining(monthStart: monthStart, cal: cal, rng: &rng))
            out.append(contentsOf: transport(monthStart: monthStart, cal: cal, rng: &rng))
            out.append(contentsOf: shopping(monthStart: monthStart, cal: cal, rng: &rng))
            out.append(contentsOf: entertainment(monthStart: monthStart, cal: cal, rng: &rng))
        }

        return out.sorted { $0.date > $1.date }
    }

    private static func recurring(monthStart: Date, cal: Calendar) -> [Transaction] {
        var items: [Transaction] = []
        items.append(.init(amount: -4500, merchant: "Acme Corp Payroll", category: .income, date: cal.date(byAdding: .day, value: 0, to: monthStart)!, note: "Paycheck"))
        items.append(.init(amount: -4500, merchant: "Acme Corp Payroll", category: .income, date: cal.date(byAdding: .day, value: 14, to: monthStart)!, note: "Paycheck"))
        items.append(.init(amount: 2200, merchant: "Sunset Apartments", category: .housing, date: cal.date(byAdding: .day, value: 0, to: monthStart)!, note: "Rent"))
        items.append(.init(amount: 118.42, merchant: "ConEd Electric", category: .utilities, date: cal.date(byAdding: .day, value: 9, to: monthStart)!))
        items.append(.init(amount: 65.00, merchant: "Verizon Fios", category: .utilities, date: cal.date(byAdding: .day, value: 12, to: monthStart)!))
        items.append(.init(amount: 15.99, merchant: "Netflix", category: .subscriptions, date: cal.date(byAdding: .day, value: 5, to: monthStart)!))
        items.append(.init(amount: 9.99, merchant: "Spotify", category: .subscriptions, date: cal.date(byAdding: .day, value: 7, to: monthStart)!))
        items.append(.init(amount: 9.99, merchant: "iCloud+", category: .subscriptions, date: cal.date(byAdding: .day, value: 17, to: monthStart)!))
        items.append(.init(amount: 50.00, merchant: "Equinox", category: .subscriptions, date: cal.date(byAdding: .day, value: 1, to: monthStart)!, note: "Gym"))
        return items
    }

    private static func groceries(monthStart: Date, cal: Calendar, rng: inout SeededRNG) -> [Transaction] {
        let merchants = ["Whole Foods", "Trader Joe's", "Safeway", "Costco"]
        let trips = rng.int(in: 4...6)
        return (0..<trips).map { _ in
            let day = rng.int(in: 0...27)
            let amount = rng.double(in: 40...160)
            return Transaction(
                amount: round(amount * 100) / 100,
                merchant: merchants.randomElement(using: &rng) ?? "Whole Foods",
                category: .groceries,
                date: cal.date(byAdding: .day, value: day, to: monthStart)!
            )
        }
    }

    private static func dining(monthStart: Date, cal: Calendar, rng: inout SeededRNG) -> [Transaction] {
        let merchants = ["Sweetgreen", "Chipotle", "Starbucks", "Blue Bottle Coffee", "Joe's Pizza", "Shake Shack", "Sushi Nakazawa", "Le Bernardin", "Dunkin'", "Pret a Manger"]
        let trips = rng.int(in: 8...16)
        return (0..<trips).map { _ in
            let day = rng.int(in: 0...27)
            let merchant = merchants.randomElement(using: &rng) ?? "Sweetgreen"
            let amount: Double
            switch merchant {
            case "Sushi Nakazawa", "Le Bernardin": amount = rng.double(in: 90...220)
            case "Starbucks", "Blue Bottle Coffee", "Dunkin'": amount = rng.double(in: 4...12)
            default: amount = rng.double(in: 12...45)
            }
            return Transaction(
                amount: round(amount * 100) / 100,
                merchant: merchant,
                category: .dining,
                date: cal.date(byAdding: .day, value: day, to: monthStart)!
            )
        }
    }

    private static func transport(monthStart: Date, cal: Calendar, rng: inout SeededRNG) -> [Transaction] {
        let merchants = ["Uber", "Lyft", "Shell", "MTA"]
        let trips = rng.int(in: 6...12)
        return (0..<trips).map { _ in
            let day = rng.int(in: 0...27)
            let merchant = merchants.randomElement(using: &rng) ?? "Uber"
            let amount: Double = merchant == "MTA" ? 2.90 : rng.double(in: 8...45)
            return Transaction(
                amount: round(amount * 100) / 100,
                merchant: merchant,
                category: .transport,
                date: cal.date(byAdding: .day, value: day, to: monthStart)!
            )
        }
    }

    private static func shopping(monthStart: Date, cal: Calendar, rng: inout SeededRNG) -> [Transaction] {
        let merchants = ["Amazon", "Target", "Apple", "Uniqlo", "Nike"]
        let trips = rng.int(in: 2...5)
        return (0..<trips).map { _ in
            let day = rng.int(in: 0...27)
            let merchant = merchants.randomElement(using: &rng) ?? "Amazon"
            let amount = rng.double(in: 18...220)
            return Transaction(
                amount: round(amount * 100) / 100,
                merchant: merchant,
                category: .shopping,
                date: cal.date(byAdding: .day, value: day, to: monthStart)!
            )
        }
    }

    private static func entertainment(monthStart: Date, cal: Calendar, rng: inout SeededRNG) -> [Transaction] {
        let merchants = ["AMC Theatres", "Brooklyn Steel", "MoMA", "Comedy Cellar"]
        let trips = rng.int(in: 1...4)
        return (0..<trips).map { _ in
            let day = rng.int(in: 0...27)
            let amount = rng.double(in: 18...95)
            return Transaction(
                amount: round(amount * 100) / 100,
                merchant: merchants.randomElement(using: &rng) ?? "AMC Theatres",
                category: .entertainment,
                date: cal.date(byAdding: .day, value: day, to: monthStart)!
            )
        }
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        self.date(from: dateComponents([.year, .month], from: date)) ?? date
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed == 0 ? 0xdeadbeef : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
    mutating func int(in range: ClosedRange<Int>) -> Int {
        Int.random(in: range, using: &self)
    }
    mutating func double(in range: ClosedRange<Double>) -> Double {
        Double.random(in: range, using: &self)
    }
}
