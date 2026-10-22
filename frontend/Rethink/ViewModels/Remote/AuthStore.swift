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
    private let tokenStore: any SessionTokenStore
    private var refreshTask: Task<Void, Error>?
    private var sessionGeneration = 0

    init(client: SupabaseAuthClient? = nil, tokenStore: (any SessionTokenStore)? = nil) {
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
                // refresh() clears only explicitly revoked/expired credentials.
                // Preserve saved identity during temporary service failures.
                errorMessage = error.localizedDescription
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
        let generation = sessionGeneration
        errorMessage = nil
        defer { isWorking = false }
        do {
            let response = try await client.signInAnonymously()
            guard generation == sessionGeneration else { return }
            guard response.accessToken != nil else {
                throw AuthServiceError.missingSession
            }
            try apply(response)
        } catch let authError as AuthServiceError {
            guard generation == sessionGeneration else { return }
            if case .service(let message) = authError,
               message.lowercased().contains("anonymous") {
                errorMessage = "Layanan sesi tamu belum tersedia. Coba lagi nanti."
            } else {
                errorMessage = authError.localizedDescription
            }
        } catch {
            guard generation == sessionGeneration else { return }
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        sessionGeneration += 1
        refreshTask?.cancel()
        refreshTask = nil
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
        if let refreshTask {
            try await refreshTask.value
            return
        }
        guard let refreshToken = session?.refreshToken else {
            throw AuthServiceError.missingSession
        }
        let generation = sessionGeneration
        let task = Task { @MainActor in
            do {
                let response = try await self.client.refresh(refreshToken: refreshToken)
                guard generation == self.sessionGeneration else { throw CancellationError() }
                try self.apply(response)
                self.errorMessage = nil
            } catch {
                if generation == self.sessionGeneration,
                   let authError = error as? AuthServiceError, case .invalidSession = authError {
                    self.signOut()
                }
                throw error
            }
        }
        refreshTask = task
        defer { if generation == sessionGeneration { refreshTask = nil } }
        try await task.value
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
