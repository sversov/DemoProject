import SwiftUI

struct SpeakView: View {
    @Environment(\.llm) private var llm
    @State private var vm: SpeakViewModel?

    var body: some View {
        NavigationStack {
            content
                .background(Color.pageBackground)
                .navigationTitle("Speak")
        }
        .onAppear {
            if vm == nil { vm = SpeakViewModel(llm: llm) }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let vm {
            VStack(spacing: 16) {
                Spacer(minLength: 12)
                MicButton(isRecording: vm.isRecording, action: vm.micTapped)
                    .padding(.bottom, 12)
                statusOrTranscript(vm: vm)
                ScrollView {
                    resultArea(vm: vm)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                }
            }
        }
    }

    @ViewBuilder
    private func statusOrTranscript(vm: SpeakViewModel) -> some View {
        switch vm.state {
        case .idle:
            Text("Tap the mic and say anything finance-related.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        case .recording:
            Label("Listening…", systemImage: "waveform")
                .font(.subheadline)
                .foregroundStyle(.red)
        case .transcribing:
            Label("Transcribing…", systemImage: "ellipsis")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        case .extracting(let transcript):
            VStack(spacing: 6) {
                Text(transcript)
                    .font(.body.italic())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Text("Picking the right action…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        case .ready(let transcript, _):
            Text("\u{201C}\(transcript)\u{201D}")
                .font(.body.italic())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        case .failed(let message):
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    @ViewBuilder
    private func resultArea(vm: SpeakViewModel) -> some View {
        if case .ready(_, let action) = vm.state {
            VoiceActionRendererView(action: action) { vm.reset() }
        } else {
            EmptyView()
        }
    }
}

private struct MicButton: View {
    let isRecording: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isRecording ? Color.red : Color.accentColor)
                    .frame(width: 110, height: 110)
                    .shadow(color: (isRecording ? Color.red : Color.accentColor).opacity(0.4), radius: 12, y: 6)
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .scaleEffect(isRecording ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isRecording)
        }
        .buttonStyle(.plain)
    }
}

struct VoiceActionRendererView: View {
    let action: VoiceAction
    let onDismiss: () -> Void

    var body: some View {
        switch action {
        case .logExpense(let t):
            LogExpenseCardView(extracted: t, onDismiss: onDismiss)
        case .quickInsight(let card):
            QuickInsightCardView(card: card, onDismiss: onDismiss)
        case .setGoal(let g):
            SetGoalCardView(spec: g, onDismiss: onDismiss)
        case .adjustBudget(let b):
            AdjustBudgetCardView(adjustment: b, onDismiss: onDismiss)
        }
    }
}
