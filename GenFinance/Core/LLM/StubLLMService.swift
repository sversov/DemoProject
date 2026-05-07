import Foundation
import FoundationModels

/// Returns hand-built responses for previews and tests. Doesn't talk to the model.
final class StubLLMService: LLMService, @unchecked Sendable {
    typealias ResponseProvider = @Sendable (String, Any.Type) async throws -> Any
    typealias StreamProvider = @Sendable (String, Any.Type) -> AsyncThrowingStream<Any, Error>

    var responder: ResponseProvider?
    var streamer: StreamProvider?

    init(responder: ResponseProvider? = nil, streamer: StreamProvider? = nil) {
        self.responder = responder
        self.streamer = streamer
    }

    func respond<T: Generable>(
        prompt: String,
        generating: T.Type,
        in feature: LLMFeature
    ) async throws -> T {
        guard let responder else { throw StubError.notConfigured }
        let any = try await responder(prompt, T.self)
        guard let typed = any as? T else { throw StubError.typeMismatch }
        return typed
    }

    func stream<T: Generable>(
        prompt: String,
        generating: T.Type,
        in feature: LLMFeature
    ) -> AsyncThrowingStream<T.PartiallyGenerated, Error> {
        AsyncThrowingStream { continuation in
            guard let streamer else {
                continuation.finish(throwing: StubError.notConfigured)
                return
            }
            Task {
                let upstream = streamer(prompt, T.self)
                do {
                    for try await any in upstream {
                        if let typed = any as? T.PartiallyGenerated {
                            continuation.yield(typed)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    enum StubError: Error { case notConfigured, typeMismatch }
}
