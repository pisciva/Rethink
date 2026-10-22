import Foundation

/// Configure these values before running the app.
///
/// - `backendBaseURL` points at the deployed Rethink Recovery API. Override it with
///   `RETHINK_API_BASE_URL` (for example `http://localhost:3001`) when testing
///   the backend locally.
/// - `supabaseURL` and `supabasePublishableKey` must match the same Supabase
///   project used by the backend. Only the publishable key belongs in the app;
///   never put the secret/service-role key here.
/// - Enable Anonymous Sign-Ins in Supabase Dashboard. The app creates a guest
///   session automatically and never asks for email/password.
///
/// For local HTTP development on a device, add an ATS exception in Xcode.
enum AppConfig {
    // Onboarding development is paused; opt in explicitly when testing it again.
    static let replaysOnboardingForTesting = ProcessInfo.processInfo.environment["RETHINK_REPLAY_ONBOARDING"] == "1"
    static var opensHomeForDevelopment: Bool {
        #if DEBUG
        // Preserve the existing development preference, without bypassing
        // first-launch onboarding in distributed Release builds.
        return ProcessInfo.processInfo.environment["RETHINK_SKIP_ONBOARDING"] != "0"
        #else
        return false
        #endif
    }
    static var onboardingPreviewPage: Int? {
        #if DEBUG
        return ProcessInfo.processInfo.environment["RETHINK_ONBOARDING_PAGE"].flatMap(Int.init)
        #else
        return nil
        #endif
    }

    static let backendBaseURL = URL(
        string: ProcessInfo.processInfo.environment["RETHINK_API_BASE_URL"] ?? "https://rethink-recovery-api.vercel.app"
    )!
    static let supabaseURL = URL(
        string: ProcessInfo.processInfo.environment["RETHINK_SUPABASE_URL"] ?? "https://hhovzaaeolcfynyetabf.supabase.co"
    )!
    // Publishable key for the Supabase project above. Only this key belongs in
    // the app; the secret/service-role key stays in the backend.
    static let supabasePublishableKey = ProcessInfo.processInfo.environment["RETHINK_SUPABASE_PUBLISHABLE_KEY"]
        ?? "sb_publishable_O7ZOqYhBXVncRjekR9Q2bw_KdKWS4Fr"

    static var isConfigured: Bool {
        !supabasePublishableKey.contains("YOUR_")
            && !supabaseURL.absoluteString.contains("YOUR_PROJECT")
    }

    static func endpoint(_ path: String) -> URL {
        backendBaseURL.appendingPathComponent(path)
    }
}
