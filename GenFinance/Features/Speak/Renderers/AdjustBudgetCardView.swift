import SwiftUI

struct AdjustBudgetCardView: View {
    let adjustment: BudgetAdjustment
    let onDismiss: () -> Void

    @Environment(\.adjustBudget) private var adjustBudget
    @Environment(BudgetStore.self) private var budgets
    @State private var newLimit: Double

    init(adjustment: BudgetAdjustment, onDismiss: @escaping () -> Void) {
        self.adjustment = adjustment
        self.onDismiss = onDismiss
        _newLimit = State(initialValue: adjustment.newLimit)
    }

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Adjust budget", systemImage: "slider.horizontal.3")
                    .font(.headline)
                HStack {
                    Image(systemName: adjustment.category.systemImage).foregroundStyle(.tint)
                    Text(adjustment.category.displayName).font(.title3.weight(.semibold))
                    Spacer()
                }
                if let current = budgets.limit(for: adjustment.category) {
                    Text("Current limit: \(current.asCurrency)/mo")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("New limit").font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text(newLimit.asCurrency)
                        .font(.title3.weight(.semibold).monospacedDigit())
                }
                Slider(value: $newLimit, in: 50...max(2000, newLimit * 2), step: 10)
                HStack {
                    Button("Cancel", role: .cancel, action: onDismiss).buttonStyle(.bordered)
                    Spacer()
                    Button {
                        adjustBudget.adjust(category: adjustment.category, newLimit: newLimit)
                        onDismiss()
                    } label: {
                        Label("Apply", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
