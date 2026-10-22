import AVFoundation
import Combine
import Foundation

@MainActor
protocol OnboardingAudioPlaying: AnyObject {
    var isAvailable: Bool { get }
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    func play()
    func play(resourceName: String)
    func stop()
}

/// Default implementation is intentionally a no-op fallback for test doubles.
extension OnboardingAudioPlaying {
    var currentTime: TimeInterval { 0 }
    var duration: TimeInterval { 0 }
    func play(resourceName: String) { play() }
}

/// A single player for onboarding audio. Per-slide files are resolved by name,
/// with an optional fallback file when a slide asset is missing.
@MainActor
final class OnboardingAudioController: NSObject, ObservableObject, OnboardingAudioPlaying, AVAudioPlayerDelegate {
    @Published private(set) var isPlaying = false
    private var player: AVAudioPlayer?
    private let fallbackURL: URL?
    var isAvailable: Bool { player != nil }
    var currentTime: TimeInterval { player?.currentTime ?? 0 }
    var duration: TimeInterval { player?.duration ?? 0 }

    override convenience init() {
        let initial = Self.bundleURL("onboarding-1a")
            ?? Self.bundleURL("dummy-audio")
        let fallback = Self.bundleURL("dummy-audio")
        self.init(url: initial, fallbackURL: fallback)
    }

    convenience init(url: URL?) {
        self.init(url: url, fallbackURL: url)
    }

    init(url: URL?, fallbackURL: URL?) {
        self.fallbackURL = fallbackURL
        super.init()
        load(url: url)
    }

    func play(resourceName: String) {
        let url = Self.bundleURL(resourceName) ?? fallbackURL
        guard let url else {
            #if DEBUG
            print("[OnboardingAudio] missing resource: \(resourceName)")
            #endif
            stop()
            return
        }

        #if DEBUG
        print("[OnboardingAudio] request=\(resourceName) resolved=\(url.lastPathComponent)")
        #endif

        if player?.url != url {
            load(url: url)
        }
        play()
    }

    func play() {
        stop()
        guard let player else { return }
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { return }
        #endif
        player.currentTime = 0
        isPlaying = player.play()
        #if DEBUG
        print("[OnboardingAudio] playing=\(player.url?.lastPathComponent ?? "nil") duration=\(player.duration)")
        #endif
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.isPlaying = self.player?.isPlaying ?? false
        }
    }

    private func load(url: URL?) {
        guard let url, let newPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        player = newPlayer
        newPlayer.delegate = self
        newPlayer.volume = 0.85
        newPlayer.prepareToPlay()
    }

    private static func bundleURL(_ name: String) -> URL? {
        Bundle.main.url(forResource: name, withExtension: "mp3", subdirectory: "audio")
            ?? Bundle.main.url(forResource: name, withExtension: "mp3", subdirectory: "Resources")
            ?? Bundle.main.url(forResource: name, withExtension: "mp3")
    }
}
