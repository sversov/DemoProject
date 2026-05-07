import FoundationModels

@Generable
struct SuggestedCut: Sendable {
    let category: Category
    @Guide(description: "Approximate current monthly spend in this category")
    let currentAmount: Double
    @Guide(description: "Proposed reduced monthly spend")
    let suggestedAmount: Double
    @Guide(description: "One concrete actionable tip")
    let tip: String
}

@Generable
struct PlanMonth: Sendable {
    @Guide(description: "Short month label like 'Jun 2026'")
    let label: String
    @Guide(description: "Amount to save this month in dollars")
    let saveAmount: Double
    @Guide(description: "0 to 4 suggested cuts that contribute to this month's savings", .count(0...4))
    let cuts: [SuggestedCut]
}

@Generable
struct SavingsPlan: Sendable {
    @Guide(description: "Short name for the goal, e.g. 'Tokyo trip'")
    let goal: String
    @Guide(description: "Total target amount in dollars")
    let targetAmount: Double
    @Guide(description: "Month-by-month breakdown, 1 to 12 months", .count(1...12))
    let months: [PlanMonth]
    @Guide(description: "One- or two-sentence summary of the plan")
    let summary: String
}

@Generable
struct DisputeForm: Sendable {
    let title: String
    @Guide(description: "Merchant on the disputed charge if known, otherwise empty")
    let merchant: String
    @Guide(description: "Disputed amount in dollars if known, otherwise 0")
    let amount: Double
    @Guide(description: "Suggested reason categories the user can pick from", .count(2...5))
    let reasonOptions: [String]
    @Guide(description: "Pre-filled draft of the dispute description in the user's voice")
    let draftDescription: String
}

@Generable
struct BudgetEntry: Sendable {
    let category: Category
    @Guide(description: "Approximate current monthly spend")
    let currentSpend: Double
    @Guide(description: "Suggested monthly limit")
    let suggestedLimit: Double
    @Guide(description: "One short rationale sentence")
    let rationale: String
}

@Generable
struct BudgetEditor: Sendable {
    let title: String
    @Guide(description: "Friendly summary explaining the proposed budget")
    let summary: String
    @Guide(description: "One entry per relevant category, 2 to 8 entries", .count(2...8))
    let entries: [BudgetEntry]
}

@Generable
struct ScenarioCompare: Sendable {
    let title: String
    @Guide(description: "Label for the current/baseline column, e.g. 'Today'")
    let baselineLabel: String
    @Guide(description: "Headline value for the baseline, e.g. '$640/mo'")
    let baselineValue: String
    let baselineNote: String
    @Guide(description: "Label for the alternative scenario column, e.g. 'After cut'")
    let alternativeLabel: String
    let alternativeValue: String
    let alternativeNote: String
    @Guide(description: "One sentence describing the net effect")
    let deltaSummary: String
}

@Generable
enum PlanResponse: Sendable {
    case savingsPlan(SavingsPlan)
    case disputeForm(DisputeForm)
    case budgetEditor(BudgetEditor)
    case scenarioCompare(ScenarioCompare)
}
