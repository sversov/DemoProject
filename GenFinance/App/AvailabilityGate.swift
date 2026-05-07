import SwiftUI
import FoundationModels
import UIKit

struct AvailabilityGate<Content: View>: View {
    @State private var availability: SystemLanguageModel.Availability = .unavailable(.modelNotReady)
    @State private var pollTask: Task<Void, Never>?
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        Group {
            switch availability {
            case .available:
                content()
            case .unavailable(.deviceNotEligible):
                GateMessage(
                    title: "Apple Intelligence not supported",
                    message: "GenFinance uses on-device generative UI that requires an Apple Silicon device with Apple Intelligence (iPhone 15 Pro or newer, M-series iPad/Mac).",
                    icon: "cpu",
                    primaryAction: nil
                )
            case .unavailable(.appleIntelligenceNotEnabled):
                GateMessage(
                    title: "Turn on Apple Intelligence",
                    message: "GenFinance needs Apple Intelligence enabled in Settings to generate UI on-device.",
                    icon: "sparkles",
                    primaryAction: ("Open Settings", openSettings)
                )
            case .unavailable(.modelNotReady):
                GateMessage(
                    title: "Model is downloading",
                    message: "Apple Intelligence is preparing the on-device model. This usually takes a few minutes.",
                    icon: "arrow.down.circle",
                    primaryAction: ("Check again", refresh)
                )
            case .unavailable:
                GateMessage(
                    title: "Generative UI unavailable",
                    message: "The on-device model isn't ready right now.",
                    icon: "exclamationmark.triangle",
                    primaryAction: ("Retry", refresh)
                )
            }
        }
        .onAppear { refresh(); startPollingIfNeeded() }
        .onDisappear { pollTask?.cancel() }
    }

    private func refresh() {
        availability = SystemLanguageModel.default.availability
    }

    private func startPollingIfNeeded() {
        pollTask?.cancel()
        pollTask = Task {
            while !Task.isCancelled {
                if case .unavailable(.modelNotReady) = availability {
                    try? await Task.sleep(nanoseconds: 20_000_000_000)
                    await MainActor.run { refresh() }
                } else {
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                }
            }
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

private struct GateMessage: View {
    let title: String
    let message: String
    let icon: String
    let primaryAction: (String, () -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.tint)
            Text(title)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            if let primaryAction {
                Button(primaryAction.0, action: primaryAction.1)
                    .buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pageBackground)
    }
}
