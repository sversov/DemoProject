import SwiftUI

struct PlanRendererView: View {
    let partial: PlanResponse.PartiallyGenerated

    var body: some View {
        switch partial {
        case .savingsPlan(let p):
            SavingsPlanView(partial: p)
        case .disputeForm(let p):
            DisputeFormView(partial: p)
        case .budgetEditor(let p):
            BudgetEditorView(partial: p)
        case .scenarioCompare(let p):
            ScenarioCompareView(partial: p)
        }
    }
}
