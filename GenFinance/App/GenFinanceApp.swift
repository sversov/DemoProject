import SwiftUI

@main
struct GenFinanceApp: App {
    @State private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            AvailabilityGate {
                RootTabView()
                    .environment(environment.transactions)
                    .environment(environment.budgets)
                    .environment(environment.goals)
                    .environment(\.llm, environment.llm)
                    .environment(\.saveTransaction, environment.saveTransaction)
                    .environment(\.setGoal, environment.setGoal)
                    .environment(\.adjustBudget, environment.adjustBudget)
            }
        }
    }
}

@MainActor
@Observable
final class AppEnvironment {
    let transactions: TransactionStore
    let budgets: BudgetStore
    let goals: GoalStore
    let factory: SessionFactory
    let llm: any LLMService
    let saveTransaction: any SaveTransactionTool
    let setGoal: any SetGoalTool
    let adjustBudget: any AdjustBudgetTool

    init() {
        let transactions = TransactionStore()
        let budgets = BudgetStore()
        let goals = GoalStore()
        let factory = SessionFactory(transactions: transactions, budgets: budgets, goals: goals)
        self.transactions = transactions
        self.budgets = budgets
        self.goals = goals
        self.factory = factory
        self.llm = LiveLLMService(factory: factory)
        self.saveTransaction = LiveSaveTransactionTool(store: transactions)
        self.setGoal = LiveSetGoalTool(store: goals)
        self.adjustBudget = LiveAdjustBudgetTool(store: budgets)
    }
}

private struct LLMServiceKey: EnvironmentKey {
    static let defaultValue: any LLMService = StubLLMService()
}

private struct SaveTransactionToolKey: EnvironmentKey {
    @MainActor static let defaultValue: any SaveTransactionTool = LiveSaveTransactionTool(store: TransactionStore(seed: [], persistenceURL: nil))
}

private struct SetGoalToolKey: EnvironmentKey {
    @MainActor static let defaultValue: any SetGoalTool = LiveSetGoalTool(store: GoalStore(persistenceURL: nil))
}

private struct AdjustBudgetToolKey: EnvironmentKey {
    @MainActor static let defaultValue: any AdjustBudgetTool = LiveAdjustBudgetTool(store: BudgetStore(seed: [], persistenceURL: nil))
}

extension EnvironmentValues {
    var llm: any LLMService {
        get { self[LLMServiceKey.self] }
        set { self[LLMServiceKey.self] = newValue }
    }
    var saveTransaction: any SaveTransactionTool {
        get { self[SaveTransactionToolKey.self] }
        set { self[SaveTransactionToolKey.self] = newValue }
    }
    var setGoal: any SetGoalTool {
        get { self[SetGoalToolKey.self] }
        set { self[SetGoalToolKey.self] = newValue }
    }
    var adjustBudget: any AdjustBudgetTool {
        get { self[AdjustBudgetToolKey.self] }
        set { self[AdjustBudgetToolKey.self] = newValue }
    }
}

struct RootTabView: View {
    var body: some View {
        TabView {
            AskView()
                .tabItem { Label("Ask", systemImage: "sparkles") }
            PlanView()
                .tabItem { Label("Plan", systemImage: "list.bullet.rectangle") }
            SpeakView()
                .tabItem { Label("Speak", systemImage: "mic") }
        }
    }
}
