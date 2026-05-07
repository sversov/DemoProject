import SwiftUI

struct PlanView: View {
    @Environment(\.llm) private var llm
    @State private var vm: PlanViewModel?
    @FocusState private var inputFocused: Bool

    var body: some View {
        NavigationStack {
            content
                .background(Color.pageBackground)
                .navigationTitle("Plan")
        }
        .onAppear {
            if vm == nil { vm = PlanViewModel(llm: llm) }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let vm {
            VStack(spacing: 12) {
                inputSection(vm: vm)
                Divider()
                resultSection(vm: vm)
            }
        }
    }

    private func inputSection(vm: PlanViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(
                "Describe what you want to do…",
                text: Binding(get: { vm.prompt }, set: { vm.prompt = $0 }),
                axis: .vertical
            )
            .focused($inputFocused)
            .lineLimit(2...6)
            .padding(12)
            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 14))

            HStack {
                Spacer()
                Button {
                    inputFocused = false
                    vm.submit()
                } label: {
                    Label("Generate", systemImage: "wand.and.stars")
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func resultSection(vm: PlanViewModel) -> some View {
        switch vm.state {
        case .idle:
            EmptyState()
        case .waiting:
            ProgressView("Picking the right shape…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .streaming(let partial):
            ScrollView {
                PlanRendererView(partial: partial)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
            }
        case .loaded(let partial):
            ScrollView {
                VStack(spacing: 12) {
                    PlanRendererView(partial: partial)
                    Button("Regenerate", systemImage: "arrow.clockwise") { vm.regenerate() }
                        .buttonStyle(.bordered)
                        .padding(.top, 4)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        case .failed(let message):
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                Text(message).font(.callout).foregroundStyle(.secondary).multilineTextAlignment(.center)
                Button("Try again") { vm.regenerate() }.buttonStyle(.bordered)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct EmptyState: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(.tint)
            Text("Type a finance task")
                .font(.headline)
            Text("A different native screen materializes for whatever you describe.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
