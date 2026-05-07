import SwiftUI

struct SavingsPlanView: View {
    let partial: SavingsPlan.PartiallyGenerated

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GenerativeCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Savings plan")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    if let goal = partial.goal {
                        Text(goal)
                            .font(.title2.weight(.semibold))
                    } else {
                        SkeletonText(text: nil, width: 200, height: 26)
                    }
                    if let target = partial.targetAmount {
                        Text("Target: \(target.asCurrency)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        SkeletonText(text: nil, width: 120)
                    }
                    if let summary = partial.summary {
                        Text(summary)
                            .font(.body)
                            .padding(.top, 4)
                    }
                }
            }

            ForEach(Array((partial.months ?? []).enumerated()), id: \.offset) { _, month in
                MonthRowView(partial: month)
            }
        }
    }
}

private struct MonthRowView: View {
    let partial: PlanMonth.PartiallyGenerated

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let label = partial.label {
                        Text(label)
                            .font(.headline)
                    } else {
                        SkeletonText(text: nil, width: 80)
                    }
                    Spacer()
                    if let amount = partial.saveAmount {
                        Text(amount.asCurrency)
                            .font(.title3.weight(.semibold).monospacedDigit())
                    } else {
                        SkeletonText(text: nil, width: 60, height: 22)
                    }
                }
                ForEach(Array((partial.cuts ?? []).enumerated()), id: \.offset) { _, cut in
                    CutRowView(partial: cut)
                }
            }
        }
    }
}

private struct CutRowView: View {
    let partial: SuggestedCut.PartiallyGenerated

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let category = partial.category {
                Image(systemName: category.systemImage)
                    .frame(width: 22)
                    .foregroundStyle(.tint)
            } else {
                SkeletonText(text: nil, width: 22, height: 18)
            }
            VStack(alignment: .leading, spacing: 2) {
                if let category = partial.category {
                    Text(category.displayName).font(.subheadline.weight(.medium))
                }
                if let tip = partial.tip {
                    Text(tip).font(.caption).foregroundStyle(.secondary)
                } else {
                    SkeletonText(text: nil, width: 220)
                }
            }
            Spacer()
            if let current = partial.currentAmount, let suggested = partial.suggestedAmount {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(suggested.asCurrency).font(.subheadline.monospacedDigit())
                    Text("from \(current.asCurrency)").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }
}
