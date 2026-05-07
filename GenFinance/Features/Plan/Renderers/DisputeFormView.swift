import SwiftUI

struct DisputeFormView: View {
    let partial: DisputeForm.PartiallyGenerated
    @State private var selectedReason: String = ""
    @State private var description: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GenerativeCard {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Dispute charge")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    if let title = partial.title {
                        Text(title).font(.title3.weight(.semibold))
                    } else {
                        SkeletonText(text: nil, width: 200, height: 22)
                    }
                }
            }

            GenerativeCard {
                VStack(alignment: .leading, spacing: 12) {
                    LabeledRow(label: "Merchant") {
                        if let m = partial.merchant, !m.isEmpty {
                            Text(m).font(.body.weight(.medium))
                        } else {
                            SkeletonText(text: nil, width: 140)
                        }
                    }
                    LabeledRow(label: "Amount") {
                        if let a = partial.amount, a > 0 {
                            Text(a.asCurrency).font(.body.weight(.medium))
                        } else {
                            SkeletonText(text: nil, width: 80)
                        }
                    }
                    LabeledRow(label: "Reason") {
                        if let options = partial.reasonOptions, !options.isEmpty {
                            Picker("Reason", selection: $selectedReason) {
                                Text("Select…").tag("")
                                ForEach(options, id: \.self) { opt in
                                    Text(opt).tag(opt)
                                }
                            }
                            .pickerStyle(.menu)
                            .onAppear {
                                if selectedReason.isEmpty, let first = options.first {
                                    selectedReason = first
                                }
                            }
                        } else {
                            SkeletonText(text: nil, width: 160)
                        }
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Description")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let draft = partial.draftDescription {
                            TextEditor(text: Binding(
                                get: { description.isEmpty ? draft : description },
                                set: { description = $0 }
                            ))
                            .frame(minHeight: 90)
                            .padding(8)
                            .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
                        } else {
                            SkeletonText(text: nil, width: 280, height: 60)
                        }
                    }
                    Button {
                        // demo: no-op submit
                    } label: {
                        Text("Submit dispute")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(partial.draftDescription == nil)
                }
            }
        }
    }
}

private struct LabeledRow<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            content
            Spacer()
        }
    }
}
