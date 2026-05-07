import FoundationModels

@Generable
struct ExtractedTransaction: Sendable {
    @Guide(description: "Amount in dollars; positive for an expense the user is logging")
    let amount: Double
    let merchant: String
    let category: Category
    @Guide(description: "ISO date (YYYY-MM-DD). If the user says 'yesterday' or 'today', resolve it. If unspecified, use today.")
    let dateISO: String
    let note: String?
}

@Generable
struct SavingsGoalSpec: Sendable {
    let name: String
    @Guide(description: "Target total amount in dollars, if mentioned. 0 if unspecified.")
    let targetAmount: Double
    @Guide(description: "Recurring monthly contribution in dollars if the user said something like 'save $200 a month'. 0 if unspecified.")
    let monthlyContribution: Double
    @Guide(description: "ISO target date if mentioned, otherwise empty string")
    let targetDateISO: String
}

@Generable
struct BudgetAdjustment: Sendable {
    let category: Category
    @Guide(description: "New monthly limit in dollars")
    let newLimit: Double
}

@Generable
enum VoiceAction: Sendable {
    case logExpense(ExtractedTransaction)
    case quickInsight(Card)
    case setGoal(SavingsGoalSpec)
    case adjustBudget(BudgetAdjustment)
}
