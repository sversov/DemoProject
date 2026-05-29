import Foundation
import Observation

@MainActor
@Observable
final class PlanViewModel {
    enum State {
        case idle
        case waiting
        case streaming(PlanResponse.PartiallyGenerated)
        case loaded(PlanResponse.PartiallyGenerated)
        case failed(String)
    }

    private(set) var state: State = .idle
    var prompt: String = ""

    private let llm: any LLMService
    private var task: Task<Void, Never>?

    init(llm: any LLMService) {
        self.llm = llm
    }

    func submit() {
        let text = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        task?.cancel()
        state = .waiting
        task = Task { [llm] in
            do {
                var last: PlanResponse.PartiallyGenerated?
                let stream = llm.stream(prompt: text, generating: PlanResponse.self, in: .plan)
                for try await partial in stream {
                    if Task.isCancelled { return }
                    state = .streaming(partial)
                    last = partial
                }
                if let last { state = .loaded(last) }
            } catch is CancellationError {
                return
            } catch {
                if Task.isCancelled { return }
                state = .failed(error.localizedDescription)
            }
        }
    }

    func regenerate() { submit() }
}
