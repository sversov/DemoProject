import Foundation
import FoundationModels

protocol LLMService: AnyObject, Sendable {
    func respond<T: Generable>(
        prompt: String,
        generating: T.Type,
        in feature: LLMFeature
    ) async throws -> T

    func stream<T: Generable>(
        prompt: String,
        generating: T.Type,
        in feature: LLMFeature
    ) -> AsyncThrowingStream<T.PartiallyGenerated, Error>
}

enum LLMFeature: Sendable, Hashable {
    case ask
    case plan
    case speak
}
