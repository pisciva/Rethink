import Combine
import Foundation

struct AuthSession: Codable, Equatable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
    let userId: String
    let email: String?
    let isAnonymous: Bool?
}

@MainActor
final class AuthStore: ObservableObject {
    @Published private(set) var session: AuthSession?
    @Published private(set) var isRestoring = true
    @Published private(set) var isWorking = false
    @Published var errorMessage: String?

    private let client: SupabaseAuthClient
    private let tokenStore: KeychainTokenStore

    init(client: SupabaseAuthClient? = nil, tokenStore: KeychainTokenStore? = nil) {
        self.client = client ?? SupabaseAuthClient()
        self.tokenStore = tokenStore ?? KeychainTokenStore()
    }

    var isAuthenticated: Bool { session != nil }
    var isAnonymous: Bool { session?.isAnonymous == true }
    var email: String? { session?.email }

    func restore() async {
        defer { isRestoring = false }
        guard let data = tokenStore.load(),
              let saved = try? JSONDecoder().decode(AuthSession.self, from: data) else {
            return
        }
        session = saved
        if saved.expiresAt <= Date().addingTimeInterval(60) {
            do {
                try await refresh()
            } catch {
                signOut()
            }
        }
    }

    /// Creates a guest identity automatically when no valid session exists.
    func ensureSession() async {
        guard session == nil else { return }
        await signInAnonymously()
    }

    func signInAnonymously() async {
        guard !isWorking else { return }
        isWorking = true
        errorMessage = nil
        defer { isWorking = false }
        do {
            let response = try await client.signInAnonymously()
            guard response.accessToken != nil else {
                throw AuthServiceError.missingSession
            }
            try apply(response)
        } catch let authError as AuthServiceError {
            if case .service(let message) = authError,
               message.lowercased().contains("anonymous") {
                errorMessage = "Anonymous Sign-Ins belum diaktifkan di Supabase. Aktifkan fitur tersebut di Authentication → Providers, lalu coba lagi."
            } else {
                errorMessage = authError.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        session = nil
        errorMessage = nil
        tokenStore.clear()
    }

    func accessToken(forceRefresh: Bool = false) async throws -> String {
        if !forceRefresh,
           let session,
           session.expiresAt > Date().addingTimeInterval(60) {
            return session.accessToken
        }
        try await refresh()
        guard let session else {
            throw AuthServiceError.missingSession
        }
        return session.accessToken
    }

    private func refresh() async throws {
        guard let refreshToken = session?.refreshToken else {
            throw AuthServiceError.missingSession
        }
        do {
            let response = try await client.refresh(refreshToken: refreshToken)
            try apply(response)
        } catch {
            signOut()
            throw error
        }
    }

    private func apply(_ response: SupabaseAuthResponse) throws {
        guard let accessToken = response.accessToken,
              let refreshToken = response.refreshToken,
              let user = response.user else {
            throw AuthServiceError.missingSession
        }
        let session = AuthSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: Date().addingTimeInterval(TimeInterval(response.expiresIn ?? 3600)),
            userId: user.id,
            email: user.email,
            isAnonymous: user.isAnonymous ?? false
        )
        self.session = session
        if let data = try? JSONEncoder().encode(session) {
            tokenStore.save(data)
        }
    }
}
