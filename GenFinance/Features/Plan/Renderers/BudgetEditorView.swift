import SwiftUI

struct BudgetEditorView: View {
    let partial: BudgetEditor.PartiallyGenerated
    @Environment(\.adjustBudget) private var adjustBudget
    @State private var localLimits: [Category: Double] = [:]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GenerativeCard {
                VStack(alignment: .leading, spacing: 6) {
                    if let title = partial.title {
                        Text(title).font(.title3.weight(.semibold))
                    } else {
                        SkeletonText(text: nil, width: 200, height: 22)
                    }
                    if let summary = partial.summary {
                        Text(summary)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } else {
                        SkeletonText(text: nil, width: 280)
                    }
                }
            }

            ForEach(Array((partial.entries ?? []).enumerated()), id: \.offset) { _, entry in
                BudgetEntryRow(partial: entry, localLimits: $localLimits)
            }

            if !(partial.entries ?? []).isEmpty {
                Button {
                    for (cat, limit) in localLimits {
                        adjustBudget.adjust(category: cat, newLimit: limit)
                    }
                } label: {
                    Text("Apply budget")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct BudgetEntryRow: View {
    let partial: BudgetEntry.PartiallyGenerated
    @Binding var localLimits: [Category: Double]

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let cat = partial.category {
                        Image(systemName: cat.systemImage).foregroundStyle(.tint)
                        Text(cat.displayName).font(.headline)
                    } else {
                        SkeletonText(text: nil, width: 100, height: 18)
                    }
                    Spacer()
                    if let suggested = partial.suggestedLimit {
                        Text(currentValue(suggested: suggested).asCurrency)
                            .font(.title3.weight(.semibold).monospacedDigit())
                    } else {
                        SkeletonText(text: nil, width: 70, height: 22)
                    }
                }
                if let current = partial.currentSpend, let suggested = partial.suggestedLimit, let cat = partial.category {
                    Slider(
                        value: Binding(
                            get: { localLimits[cat] ?? suggested },
                            set: { localLimits[cat] = $0 }
                        ),
                        in: max(50, min(current, suggested) * 0.5)...max(current, suggested) * 1.5
                    )
                    HStack {
                        Text("Currently spending: \(current.asCurrency)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                if let rationale = partial.rationale {
                    Text(rationale).font(.caption).foregroundStyle(.secondary)
                } else {
                    SkeletonText(text: nil, width: 240)
                }
            }
        }
    }

    private func currentValue(suggested: Double) -> Double {
        guard let cat = partial.category else { return suggested }
        return localLimits[cat] ?? suggested
    }
}
