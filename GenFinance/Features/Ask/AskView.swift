import SwiftUI

struct AskView: View {
    @Environment(\.llm) private var llm
    @State private var vm: AskViewModel?

    var body: some View {
        NavigationStack {
            content
                .background(Color.pageBackground)
                .navigationTitle("Ask")
        }
        .onAppear {
            if vm == nil { vm = AskViewModel(llm: llm) }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let vm {
            VStack(spacing: 0) {
                PromptChipRow(prompts: AskViewModel.starterPrompts) { tapped in
                    vm.prompt = tapped
                    vm.submit()
                }
                .padding(.vertical, 8)

                AskResultsView(state: vm.state) { vm.regenerate() }

                AskInputBar(prompt: Binding(get: { vm.prompt }, set: { vm.prompt = $0 })) {
                    vm.submit()
                }
            }
        }
    }
}

private struct AskInputBar: View {
    @Binding var prompt: String
    let onSubmit: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("Ask about your finances…", text: $prompt, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(1...3)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 18))
                .submitLabel(.send)
                .onSubmit { onSubmit() }
            Button(action: onSubmit) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
            }
            .disabled(prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .padding(.top, 4)
    }
}

private struct AskResultsView: View {
    let state: AskViewModel.State
    let onRegenerate: () -> Void

    var body: some View {
        switch state {
        case .idle:
            EmptyState()
        case .loading:
            ProgressView("Thinking…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let cards):
            ScrollView {
                LazyVStack(spacing: Theme.cardSpacing) {
                    ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                        CardRendererView(card: card)
                    }
                    Button("Regenerate", systemImage: "arrow.clockwise", action: onRegenerate)
                        .buttonStyle(.bordered)
                        .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
        case .failed(let message):
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                Text(message).font(.callout).foregroundStyle(.secondary).multilineTextAlignment(.center)
                Button("Try again", action: onRegenerate).buttonStyle(.bordered)
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
            Image(systemName: "sparkles")
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(.tint)
            Text("Ask anything about your spending")
                .font(.headline)
            Text("Tap a starter prompt or type your own.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CardRendererView: View {
    let card: Card

    var body: some View {
        switch card {
        case .headlineStat(let s): HeadlineStatCardView(stat: s)
        case .categoryDonut(let d): CategoryDonutCardView(donut: d)
        case .timeSeriesChart(let c): TimeSeriesCardView(chart: c)
        case .merchantList(let l): MerchantListCardView(list: l)
        case .comparison(let c): ComparisonCardView(comparison: c)
        case .advice(let a): AdviceCardView(advice: a)
        }
    }
}
