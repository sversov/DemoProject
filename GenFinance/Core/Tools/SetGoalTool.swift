import Foundation

@MainActor
protocol SetGoalTool: AnyObject {
    func set(_ goal: Goal)
}

@MainActor
final class LiveSetGoalTool: SetGoalTool {
    private let store: GoalStore
    init(store: GoalStore) { self.store = store }
    func set(_ goal: Goal) {
        store.add(goal)
    }
}
