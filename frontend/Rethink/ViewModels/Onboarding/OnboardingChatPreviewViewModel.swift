import Combine
import Foundation

/// Curated, local demonstration. No AI request, assessment, or learner-state update.
@MainActor
final class OnboardingChatPreviewViewModel: ObservableObject {
    enum Prompt: String, CaseIterable, Identifiable {
        case concept, reasoning, learning
        var id: String { rawValue }
        var title: String {
            switch self {
            case .concept: "Bagaimana cara mengerjakan 2(x + 4)?"
            case .reasoning: "Kenapa 2 dikalikan ke x dan juga ke 4?"
            case .learning: "Kalau bingung di langkah seperti ini, Rethink bantu dari mana?"
            }
        }
    }

    @Published private(set) var selectedPrompt: Prompt?
    @Published private(set) var turns: [Prompt] = []
    @Published private(set) var replySteps: [Prompt: Int] = [:]
    @Published private(set) var completedTurns = 0

    var nextPrompt: Prompt? {
        guard selectedPrompt == nil || hasFinishedReply,
              completedTurns < Prompt.allCases.count else { return nil }
        return Prompt.allCases[completedTurns]
    }

    var scrollRevision: Int { turns.count + replySteps.values.reduce(0, +) }
    @Published private(set) var isThinking = false
    @Published private(set) var revealedSteps = 0
    @Published private(set) var hasFinishedReply = false
    @Published var selectedProduct = 0
    @Published private(set) var exploredProducts: Set<Int> = []
    private var replyTask: Task<Void, Never>?

    func ask(_ prompt: Prompt, onComplete: @escaping @MainActor () -> Void) {
        guard prompt == nextPrompt else { return }
        replyTask?.cancel()
        turns.append(prompt)
        selectedPrompt = prompt
        isThinking = true
        revealedSteps = 0
        hasFinishedReply = false
        selectedProduct = 0
        exploredProducts = []
        replyTask = Task { @MainActor [weak self] in
            do {
                try await Task.sleep(nanoseconds: 550_000_000)
                guard let self, !Task.isCancelled else { return }
                self.isThinking = false
                self.revealedSteps = 1
                self.replySteps[prompt] = 1
                try await Task.sleep(nanoseconds: prompt == .learning ? 550_000_000 : 300_000_000)
                self.revealedSteps = 2
                self.replySteps[prompt] = 2
                try await Task.sleep(nanoseconds: prompt == .learning ? 650_000_000 : 400_000_000)
                self.revealedSteps = 3
                self.replySteps[prompt] = 3
                self.completedTurns += 1
                self.hasFinishedReply = true
                if self.canContinue { onComplete() }
            } catch { return }
        }
    }

    var canContinue: Bool {
        hasFinishedReply && completedTurns == Prompt.allCases.count
    }

    func exploreProduct(_ index: Int) {
        selectedProduct = index
        exploredProducts.insert(index)
    }

    func cancelReply() { replyTask?.cancel() }
}
