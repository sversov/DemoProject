import Foundation
import FoundationModels

@MainActor
final class LiveLLMService: LLMService {
    private let factory: SessionFactory

    init(factory: SessionFactory) {
        self.factory = factory
    }

    nonisolated func respond<T: Generable>(
        prompt: String,
        generating: T.Type,
        in feature: LLMFeature
    ) async throws -> T {
        let session = await factory.session(for: feature)
        return try await session.respond(to: prompt, generating: T.self).content
    }

    nonisolated func stream<T: Generable>(
        prompt: String,
        generating: T.Type,
        in feature: LLMFeature
    ) -> AsyncThrowingStream<T.PartiallyGenerated, Error> {
        AsyncThrowingStream { continuation in
            Task { @MainActor in
                let session = factory.session(for: feature)
                do {
                    let stream = session.streamResponse(to: prompt, generating: T.self)
                    for try await partial in stream {
                        continuation.yield(partial)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
