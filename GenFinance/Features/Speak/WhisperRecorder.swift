import Foundation
import AVFoundation
#if canImport(WhisperKit)
import WhisperKit
#endif

@MainActor
final class WhisperRecorder {
    private var recorder: AVAudioRecorder?
    private var fileURL: URL?

    #if canImport(WhisperKit)
    private var pipe: WhisperKit?
    #endif

    func prepare() async throws {
        #if canImport(WhisperKit)
        if pipe == nil {
            pipe = try await WhisperKit(model: "openai_whisper-base.en")
        }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
        try session.setActive(true)
        #else
        throw RecorderError.whisperKitMissing
        #endif
    }

    func start() throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("speak-\(Int(Date().timeIntervalSince1970)).wav")
        fileURL = url
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 16_000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false,
        ]
        let r = try AVAudioRecorder(url: url, settings: settings)
        r.record()
        recorder = r
    }

    func stop() async throws -> String {
        guard let recorder, let fileURL else { return "" }
        recorder.stop()
        self.recorder = nil
        try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)

        #if canImport(WhisperKit)
        guard let pipe else { return "" }
        let results = try await pipe.transcribe(audioPath: fileURL.path)
        try? FileManager.default.removeItem(at: fileURL)
        self.fileURL = nil
        return results.map(\.text).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        #else
        try? FileManager.default.removeItem(at: fileURL)
        self.fileURL = nil
        throw RecorderError.whisperKitMissing
        #endif
    }

    func cancel() {
        recorder?.stop()
        recorder = nil
        if let url = fileURL { try? FileManager.default.removeItem(at: url) }
        fileURL = nil
    }

    enum RecorderError: LocalizedError {
        case whisperKitMissing
        var errorDescription: String? {
            switch self {
            case .whisperKitMissing:
                return "Add the WhisperKit Swift package (File ▸ Add Package Dependencies… ▸ https://github.com/argmaxinc/WhisperKit) to enable the Speak tab."
            }
        }
    }
}
