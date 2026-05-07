import Foundation
import Observation

@MainActor
@Observable
final class AskViewModel {
    enum State {
        case idle
        case loading
        case loaded([Card])
        case failed(String)
    }

    private(set) var state: State = .idle
    var prompt: String = ""

    private let llm: any LLMService
    private var task: Task<Void, Never>?

    static let starterPrompts: [String] = [
        "How did I spend this month?",
        "What did I waste money on?",
        "Compare June vs July",
        "Am I on track with my budget?",
    ]

    init(llm: any LLMService) {
        self.llm = llm
    }

    func submit() {
        let text = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        run(text)
    }

    func regenerate() {
        let text = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        run(text)
    }

    private func run(_ text: String) {
        task?.cancel()
        state = .loading
        task = Task { [llm] in
            do {
                let response = try await llm.respond(prompt: text, generating: CardResponse.self, in: .ask)
                if Task.isCancelled { return }
                state = .loaded(response.cards)
            } catch is CancellationError {
                return
            } catch {
                if Task.isCancelled { return }
                state = .failed(error.localizedDescription)
            }
        }
    }
}
