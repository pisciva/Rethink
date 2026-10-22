import Combine
import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    let pages = OnboardingPage.allCases
    let audio: any OnboardingAudioPlaying

    @Published private(set) var selectedPage: Int
    @Published private(set) var audioEnabled: Bool
    @Published var learnerName: String
    @Published private(set) var visitedConceptSteps: Set<Int> = []
    @Published private(set) var mathChoice: String?
    @Published private(set) var quickCheckIndex = 0
    @Published private(set) var familiarityAnswers: [Int: OnboardingFamiliarity] = [:]
    @Published private(set) var quickCheckReviewed = false
    @Published private(set) var chatbotUsed = false

    private let preferences: OnboardingPreferenceStore
    private var hasBegun = false
    private var isEditingFamiliarity = false

    init(
        initialPage: Int? = nil,
        preferences: OnboardingPreferenceStore = OnboardingPreferenceStore(),
        audio: (any OnboardingAudioPlaying)? = nil
    ) {
        self.preferences = preferences
        self.audio = audio ?? OnboardingAudioController()
        selectedPage = min(max(initialPage ?? preferences.lastScreen, 0), OnboardingPage.allCases.count - 1)
        audioEnabled = preferences.audioEnabled
        learnerName = AppConfig.replaysOnboardingForTesting ? "" : preferences.learnerName
        preferences.markStarted()
    }

    var currentPage: OnboardingPage { pages[selectedPage] }
    var isLastPage: Bool { selectedPage == pages.count - 1 }

    var canAdvance: Bool {
        switch currentPage {
        case .welcome:
            return learnerName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
        case .concept:
            return true // Informational slide; no token activity to complete.
        case .quickCheck:
            return quickCheckReviewed
        case .chatbot:
            return chatbotUsed
        case .ready:
            return true
        }
    }

    func begin() {
        guard !hasBegun else { return }
        hasBegun = true
        playAudioIfEnabled()
    }

    func select(_ index: Int) {
        guard pages.indices.contains(index), index != selectedPage else { return }
        audio.stop()
        selectedPage = index
        preferences.lastScreen = index
        playAudioIfEnabled()
    }

    func next() {
        guard canAdvance, !isLastPage else { return }
        select(selectedPage + 1)
    }

    func back() {
        select(selectedPage - 1)
    }

    func visitConceptStep(_ index: Int) {
        guard index == visitedConceptSteps.count else { return }
        visitedConceptSteps.insert(index)
    }

    func chooseMath(_ choice: String) {
        mathChoice = choice
    }

    func recordFamiliarity(_ choice: OnboardingFamiliarity) {
        guard OnboardingQuickCheckItem.examples.indices.contains(quickCheckIndex) else { return }
        familiarityAnswers[quickCheckIndex] = choice
        quickCheckReviewed = false
    }

    func advanceQuickCheck(from index: Int) {
        guard quickCheckIndex == index, familiarityAnswers[index] != nil else { return }
        let count = OnboardingQuickCheckItem.examples.count
        quickCheckIndex = isEditingFamiliarity && familiarityAnswers.count == count
            ? count
            : min(index + 1, count)
        isEditingFamiliarity = false
    }

    func editFamiliarity(at index: Int) {
        guard familiarityAnswers[index] != nil else { return }
        isEditingFamiliarity = familiarityAnswers.count == OnboardingQuickCheckItem.examples.count
        quickCheckIndex = index
        quickCheckReviewed = false
    }

    func resetFamiliarity() {
        isEditingFamiliarity = false
        familiarityAnswers = [:]
        quickCheckReviewed = false
        quickCheckIndex = 0
    }

    func confirmFamiliarity() {
        guard familiarityAnswers.count == OnboardingQuickCheckItem.examples.count else { return }
        quickCheckReviewed = true
    }

    func beginChatbotPreview() { chatbotUsed = false }

    func useChatbot() {
        chatbotUsed = true
    }

    func setAudioEnabled(_ enabled: Bool) {
        audioEnabled = enabled
        preferences.audioEnabled = enabled
        if enabled {
            playAudioIfEnabled()
        } else {
            audio.stop()
        }
    }

    func playAudio(named resourceName: String) {
        guard audioEnabled, audio.isAvailable else { return }
        audio.play(resourceName: resourceName)
    }

    func suspendAudio() { audio.stop() }

    func finish(skipped: Bool) {
        audio.stop()
        preferences.learnerName = learnerName.trimmingCharacters(in: .whitespacesAndNewlines)
        preferences.finish(skipped: skipped)
    }

    private func playAudioIfEnabled() {
        // The revised concept slide needs matching narration; do not play the old token instructions.
        guard currentPage != .concept, audioEnabled, audio.isAvailable else { return }
        audio.play(resourceName: currentPage.audioResourceName)
    }
}
