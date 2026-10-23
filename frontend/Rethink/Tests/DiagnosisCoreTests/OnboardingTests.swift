import XCTest
@testable import DiagnosisCore

@MainActor
final class OnboardingTests: XCTestCase {
    private func preferences() -> OnboardingPreferenceStore {
        let defaults = UserDefaults(suiteName: "OnboardingTests.\(UUID().uuidString)")!
        return OnboardingPreferenceStore(defaults: defaults)
    }

    private func completeOnboarding(_ model: OnboardingViewModel) {
        model.learnerName = "Akbar"
        model.next()

        model.visitConceptStep(0)
        model.visitConceptStep(1)
        model.visitConceptStep(2)
        model.next()

        for index in OnboardingQuickCheckItem.examples.indices {
            model.recordFamiliarity(.unsure)
            model.advanceQuickCheck(from: index)
        }
        model.confirmFamiliarity()
        model.next()

        model.useChatbot()
        model.next()
    }

    func testFreshFlowHasFiveActivityGatedScreensAndAudioOn() {
        let store = preferences()
        let model = OnboardingViewModel(preferences: store, audio: AudioSpy())
        XCTAssertEqual(model.pages.count, 5)
        XCTAssertEqual(model.selectedPage, 0)
        XCTAssertTrue(model.audioEnabled)
        XCTAssertFalse(store.hasFinished)
        XCTAssertFalse(model.canAdvance)
    }

    func testNameIsRequiredBeforeLeavingWelcome() {
        let model = OnboardingViewModel(preferences: preferences(), audio: AudioSpy())
        model.learnerName = "A"
        XCTAssertFalse(model.canAdvance)
        model.next()
        XCTAssertEqual(model.selectedPage, 0)

        model.learnerName = "Akbar"
        XCTAssertTrue(model.canAdvance)
        model.next()
        XCTAssertEqual(model.selectedPage, 1)
    }

    func testRevisedConceptSlideIsInformationalWithoutATokenGate() {
        let model = OnboardingViewModel(preferences: preferences(), audio: AudioSpy())
        model.learnerName = "Akbar"
        model.next()

        XCTAssertTrue(model.canAdvance)
        model.next()
        XCTAssertEqual(model.currentPage, .quickCheck)
    }

    func testQuickCheckAndChatbotGates() {
        let model = OnboardingViewModel(preferences: preferences(), audio: AudioSpy())
        model.learnerName = "Akbar"
        model.next()
        model.visitConceptStep(0)
        model.visitConceptStep(1)
        model.visitConceptStep(2)
        model.next()

        XCTAssertFalse(model.canAdvance)
        model.chooseMath("3x + 6")
        XCTAssertFalse(model.canAdvance, "legacy MCQ must not bypass the revised five-example gate")
        for index in OnboardingQuickCheckItem.examples.indices {
            model.recordFamiliarity(.unsure)
            model.advanceQuickCheck(from: index)
        }
        XCTAssertFalse(model.canAdvance, "all five responses still require explicit confirmation")
        model.confirmFamiliarity()
        XCTAssertTrue(model.canAdvance)
        model.next()

        XCTAssertFalse(model.canAdvance)
        model.useChatbot()
        XCTAssertTrue(model.canAdvance)
        model.next()
        XCTAssertTrue(model.isLastPage)
        XCTAssertEqual(model.selectedPage, 4)
    }

    func testMuteStopsImmediatelyAndUnmutePlaysCurrentScreen() {
        let audio = AudioSpy()
        let model = OnboardingViewModel(preferences: preferences(), audio: audio)
        model.begin()
        XCTAssertEqual(audio.plays, 1)

        model.setAudioEnabled(false)
        XCTAssertFalse(audio.isPlaying)
        XCTAssertEqual(audio.plays, 1)

        model.setAudioEnabled(true)
        XCTAssertTrue(audio.isPlaying)
        XCTAssertEqual(audio.plays, 2)
    }

    func testFastNavigationStopsPreviousAudioAndDoesNotDuplicateSamePage() {
        let audio = AudioSpy()
        let model = OnboardingViewModel(preferences: preferences(), audio: audio)
        model.begin()
        model.select(1)
        model.select(2)
        model.select(2)
        XCTAssertEqual(audio.plays, 2, "revised concept slide must not play obsolete token instructions")
        XCTAssertEqual(audio.overlaps, 0)
        model.suspendAudio()
        XCTAssertFalse(audio.isPlaying)
    }

    func testCompletionPersistsAndStopsAudio() {
        let store = preferences()
        let audio = AudioSpy()
        let model = OnboardingViewModel(preferences: store, audio: audio)
        completeOnboarding(model)
        model.finish(skipped: false)
        XCTAssertTrue(store.hasFinished)
        XCTAssertFalse(store.wasSkipped)
        XCTAssertEqual(store.learnerName, "Akbar")
        XCTAssertFalse(audio.isPlaying)

        let restored = OnboardingViewModel(preferences: store, audio: AudioSpy())
        XCTAssertTrue(restored.audioEnabled)
        XCTAssertEqual(restored.learnerName, "Akbar")
    }

    func testUnfinishedFlowResumesAndExplicitPreviewPageOverridesSavedPage() {
        let store = preferences()
        let model = OnboardingViewModel(preferences: store, audio: AudioSpy())
        model.select(4)
        XCTAssertEqual(OnboardingViewModel(preferences: store, audio: AudioSpy()).selectedPage, 4)
        XCTAssertEqual(OnboardingViewModel(initialPage: 0, preferences: store, audio: AudioSpy()).selectedPage, 0)
    }

    func testMissingAudioStillAllowsFlowCompletion() {
        let audio = AudioSpy(available: false)
        let model = OnboardingViewModel(preferences: preferences(), audio: audio)
        completeOnboarding(model)
        XCTAssertTrue(model.isLastPage)
        XCTAssertEqual(model.selectedPage, 4)
        XCTAssertEqual(audio.plays, 0)
    }

    func testSuppliedMP3CanBeDecodedAndMissingFileIsSafe() {
        let root = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let controller = OnboardingAudioController(url: root.appendingPathComponent("Resources/audio/onboarding-1a.mp3"))
        XCTAssertTrue(controller.isAvailable)
        XCTAssertFalse(controller.isPlaying)
        let missing = OnboardingAudioController(url: nil)
        XCTAssertFalse(missing.isAvailable)
        missing.play()
        XCTAssertFalse(missing.isPlaying)
    }

    func testBeginIsIdempotentAndDoesNotResumeAfterSuspension() {
        let audio = AudioSpy()
        let model = OnboardingViewModel(preferences: preferences(), audio: audio)
        model.begin()
        model.begin()
        XCTAssertEqual(audio.plays, 1)
        model.suspendAudio()
        model.begin()
        XCTAssertFalse(audio.isPlaying)
        XCTAssertEqual(audio.plays, 1)
    }

    func testFirstLaunchCompletionAndExplicitDevelopmentOverrides() {
        let store = preferences()
        XCTAssertTrue(store.shouldPresent())
        XCTAssertFalse(store.shouldPresent(developmentBypass: true))
        XCTAssertTrue(store.shouldPresent(replay: true, developmentBypass: true))
        store.finish(skipped: false)
        XCTAssertFalse(store.shouldPresent())
        XCTAssertTrue(store.shouldPresent(preview: true))
        XCTAssertTrue(store.shouldPresent(replay: true))
    }

    func testNameSurvivesInterruptedOnboardingBeforeCompletion() {
        let store = preferences()
        let model = OnboardingViewModel(preferences: store, audio: AudioSpy())
        model.learnerName = "  Akbar  "
        model.next()
        let restored = OnboardingViewModel(preferences: store, audio: AudioSpy())
        XCTAssertEqual(restored.learnerName, "Akbar")
        XCTAssertEqual(restored.currentPage, .concept)
        XCTAssertFalse(store.hasFinished)
    }
}

@MainActor
private final class AudioSpy: OnboardingAudioPlaying {
    let isAvailable: Bool
    var isPlaying = false
    var plays = 0
    var overlaps = 0

    init(available: Bool = true) { isAvailable = available }

    func play() {
        if isPlaying { overlaps += 1 }
        isPlaying = true
        plays += 1
    }

    func stop() { isPlaying = false }
}
