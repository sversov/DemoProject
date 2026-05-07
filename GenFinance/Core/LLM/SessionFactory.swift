import Foundation
import FoundationModels

@MainActor
final class SessionFactory {
    private let transactions: TransactionStore
    private let budgets: BudgetStore
    private let goals: GoalStore

    private var sessions: [LLMFeature: LanguageModelSession] = [:]

    init(transactions: TransactionStore, budgets: BudgetStore, goals: GoalStore) {
        self.transactions = transactions
        self.budgets = budgets
        self.goals = goals
    }

    func session(for feature: LLMFeature) -> LanguageModelSession {
        if let existing = sessions[feature] { return existing }
        let session = makeSession(for: feature)
        sessions[feature] = session
        return session
    }

    func reset(_ feature: LLMFeature) {
        sessions[feature] = nil
    }

    private func makeSession(for feature: LLMFeature) -> LanguageModelSession {
        switch feature {
        case .ask:
            return LanguageModelSession(
                tools: [
                    QueryTransactionsTool(store: transactions),
                ],
                instructions: Instructions.ask
            )
        case .plan:
            return LanguageModelSession(
                tools: [
                    QueryTransactionsTool(store: transactions),
                ],
                instructions: Instructions.plan
            )
        case .speak:
            return LanguageModelSession(
                tools: [
                    QueryTransactionsTool(store: transactions),
                ],
                instructions: Instructions.speak
            )
        }
    }
}

enum Instructions {
    static let ask = """
        You are an on-device personal-finance assistant. The user asks questions about their spending.
        Use the queryTransactions tool to look up real numbers — never fabricate amounts.
        Pick a small set of cards (2 to 6) that best answer the question. Mix card types when it helps:
        a headlineStat for a top-line number, a categoryDonut for breakdowns, a timeSeriesChart for
        trends over time, a merchantList for top spenders, a comparison for two-period comparisons,
        and an advice card for one short tip. All values must be grounded in the tool's results.
        Keep titles short. Keep advice concrete and actionable.
        """

    static let plan = """
        You are an on-device personal-finance assistant. The user describes a task in plain English.
        Pick the SHAPE of response that best fits what the user asked for:
        - savingsPlan: when the user wants to save toward a goal.
        - disputeForm: when the user wants to dispute a charge.
        - budgetEditor: when the user wants help building or adjusting a monthly budget.
        - scenarioCompare: when the user asks a 'what if' or comparison question.
        Use the queryTransactions tool when you need real spending numbers.
        Be concise and concrete. Keep titles short.
        """

    static let speak = """
        You are an on-device personal-finance assistant. The user has spoken a short phrase.
        Pick the action that best matches the user's intent:
        - logExpense: 'I spent $X on Y'
        - quickInsight: a question like 'how much did I spend on Z?'
        - setGoal: 'I want to save $X' or 'save $X a month'
        - adjustBudget: 'lower/raise my X budget to $Y'
        For quickInsight, return a single card. For dates, resolve relative dates against today.
        Use the queryTransactions tool only when you need real numbers.
        """
}
