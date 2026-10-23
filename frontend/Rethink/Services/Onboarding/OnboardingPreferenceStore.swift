import Foundation

final class OnboardingPreferenceStore {
    private let defaults: UserDefaults
    private let prefix = "rethink.onboarding."

    init(defaults: UserDefaults = .standard) { self.defaults = defaults }

    var hasFinished: Bool { defaults.bool(forKey: prefix + "completed") || wasSkipped }
    var wasSkipped: Bool { defaults.bool(forKey: prefix + "skipped") }

    func shouldPresent(replay: Bool = false, preview: Bool = false, developmentBypass: Bool = false) -> Bool {
        replay || preview || (!developmentBypass && !hasFinished)
    }

    var audioEnabled: Bool {
        get {
            if defaults.object(forKey: prefix + "audioEnabled") == nil { return true }
            return defaults.bool(forKey: prefix + "audioEnabled")
        }
        set { defaults.set(newValue, forKey: prefix + "audioEnabled") }
    }

    var learnerName: String {
        get { defaults.string(forKey: prefix + "learnerName") ?? "" }
        set { defaults.set(newValue, forKey: prefix + "learnerName") }
    }

    var lastScreen: Int {
        get { defaults.integer(forKey: prefix + "lastScreen") }
        set { defaults.set(newValue, forKey: prefix + "lastScreen") }
    }

    func markStarted() { defaults.set(true, forKey: prefix + "started") }

    func finish(skipped: Bool) {
        defaults.set(!skipped, forKey: prefix + "completed")
        defaults.set(skipped, forKey: prefix + "skipped")
        lastScreen = 0
    }
}
