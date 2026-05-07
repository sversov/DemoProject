import Foundation
import Observation
import AVFoundation

@MainActor
@Observable
final class SpeakViewModel {
    enum State {
        case idle
        case recording
        case transcribing
        case extracting(transcript: String)
        case ready(transcript: String, action: VoiceAction)
        case failed(String)
    }

    private(set) var state: State = .idle
    private let llm: any LLMService
    private let recorder = WhisperRecorder()
    private var task: Task<Void, Never>?

    init(llm: any LLMService) {
        self.llm = llm
    }

    func micTapped() {
        switch state {
        case .recording:
            stopAndProcess()
        case .idle, .ready, .failed:
            startRecording()
        case .transcribing, .extracting:
            break
        }
    }

    var isRecording: Bool {
        if case .recording = state { return true }
        return false
    }

    func reset() {
        task?.cancel()
        recorder.cancel()
        state = .idle
    }

    private func startRecording() {
        task?.cancel()
        Task {
            do {
                try await ensurePermission()
                try await recorder.prepare()
                try recorder.start()
                state = .recording
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }

    private func stopAndProcess() {
        state = .transcribing
        task = Task { [llm, recorder] in
            do {
                let transcript = try await recorder.stop()
                if Task.isCancelled { return }
                guard !transcript.isEmpty else {
                    state = .failed("Didn't catch that — try again.")
                    return
                }
                state = .extracting(transcript: transcript)
                let action = try await llm.respond(prompt: transcript, generating: VoiceAction.self, in: .speak)
                if Task.isCancelled { return }
                state = .ready(transcript: transcript, action: action)
            } catch {
                if Task.isCancelled { return }
                state = .failed(error.localizedDescription)
            }
        }
    }

    private func ensurePermission() async throws {
        if AVAudioApplication.shared.recordPermission == .granted { return }
        let granted = await AVAudioApplication.requestRecordPermission()
        if !granted { throw NSError(domain: "Speak", code: 1, userInfo: [NSLocalizedDescriptionKey: "Microphone permission denied."]) }
    }
}
