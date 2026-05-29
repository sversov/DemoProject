import SwiftUI

struct ScenarioCompareView: View {
    let partial: ScenarioCompare.PartiallyGenerated

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GenerativeCard {
                VStack(alignment: .leading, spacing: 6) {
                    Text("What if")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    if let title = partial.title {
                        Text(title).font(.title3.weight(.semibold))
                    } else {
                        SkeletonText(text: nil, width: 240, height: 22)
                    }
                }
            }

            HStack(alignment: .top, spacing: 12) {
                ScenarioColumn(
                    label: partial.baselineLabel,
                    value: partial.baselineValue,
                    note: partial.baselineNote,
                    accent: .gray
                )
                ScenarioColumn(
                    label: partial.alternativeLabel,
                    value: partial.alternativeValue,
                    note: partial.alternativeNote,
                    accent: .blue
                )
            }

            GenerativeCard {
                if let summary = partial.deltaSummary {
                    Text(summary).font(.body)
                } else {
                    SkeletonText(text: nil, width: 280)
                }
            }
        }
    }
}

private struct ScenarioColumn: View {
    let label: String?
    let value: String?
    let note: String?
    let accent: Color

    var body: some View {
        GenerativeCard {
            VStack(alignment: .leading, spacing: 8) {
                if let label {
                    Text(label).font(.caption).foregroundStyle(.secondary)
                } else {
                    SkeletonText(text: nil, width: 70)
                }
                if let value {
                    Text(value)
                        .font(.title.weight(.semibold).monospacedDigit())
                        .foregroundStyle(accent)
                } else {
                    SkeletonText(text: nil, width: 100, height: 30)
                }
                if let note {
                    Text(note).font(.caption).foregroundStyle(.secondary)
                } else {
                    SkeletonText(text: nil, width: 140)
                }
            }
        }
    }
}
