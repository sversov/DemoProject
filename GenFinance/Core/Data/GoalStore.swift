import Foundation
import Observation

@MainActor
@Observable
final class GoalStore {
    private(set) var goals: [Goal]

    private let persistenceURL: URL?

    init(seed: [Goal] = [], persistenceURL: URL? = GoalStore.defaultPersistenceURL) {
        self.persistenceURL = persistenceURL
        if let url = persistenceURL,
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder.iso.decode([Goal].self, from: data) {
            self.goals = decoded
        } else {
            self.goals = seed
        }
    }

    func add(_ goal: Goal) {
        goals.append(goal)
        persist()
    }

    func remove(id: String) {
        goals.removeAll { $0.id == id }
        persist()
    }

    private func persist() {
        guard let persistenceURL else { return }
        if let data = try? JSONEncoder.iso.encode(goals) {
            try? data.write(to: persistenceURL, options: .atomic)
        }
    }

    static var defaultPersistenceURL: URL? {
        let fm = FileManager.default
        guard let dir = try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        return dir.appendingPathComponent("goals.json")
    }
}
