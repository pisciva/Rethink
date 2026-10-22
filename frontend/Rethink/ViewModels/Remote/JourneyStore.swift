import Combine
import Foundation

@MainActor
final class JourneyStore: ObservableObject {
    @Published private(set) var journey: RemoteJourney?
    @Published private(set) var revision = 0
    @Published private(set) var resetRequired = false
    @Published private(set) var isLoading = false
    @Published private(set) var isWorking = false
    @Published private(set) var requiresReload = false
    @Published private(set) var feedback: String?
    @Published var errorMessage: String?

    private let client: APIClient
    private var contextGeneration = 0

    var canMutate: Bool { !isLoading && !isWorking && !requiresReload }

    init(client: APIClient? = nil) {
        self.client = client ?? APIClient()
    }

    func load(auth: AuthStore) async {
        guard !isLoading && !isWorking else { return }
        let generation = contextGeneration
        let owner = auth.session?.userId
        isLoading = true
        errorMessage = nil
        defer { if generation == contextGeneration { isLoading = false } }
        do {
            let envelope = try await authorizedRequest(auth: auth) { token in
                try await client.journey(token: token)
            }
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            apply(envelope)
        } catch {
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            handle(error, auth: auth)
        }
    }

    func selectTopic(_ topicId: String, auth: AuthStore) async {
        guard canMutate else { return }
        let generation = contextGeneration
        let owner = auth.session?.userId
        isWorking = true
        errorMessage = nil
        feedback = nil
        defer { if generation == contextGeneration { isWorking = false } }
        do {
            let envelope = try await authorizedRequest(auth: auth) { token in
                try await client.submit(
                    action: .selectTopic,
                    expectedRevision: revision,
                    token: token,
                    topicId: topicId
                )
            }
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            apply(envelope)
        } catch {
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            handle(error, auth: auth)
        }
    }

    func submit(questionId: String, answer: String, auth: AuthStore) async {
        guard canMutate else { return }
        let generation = contextGeneration
        let owner = auth.session?.userId
        isWorking = true
        errorMessage = nil
        feedback = nil
        defer { if generation == contextGeneration { isWorking = false } }
        do {
            let envelope = try await authorizedRequest(auth: auth) { token in
                try await client.submit(
                    action: .submit,
                    expectedRevision: revision,
                    token: token,
                    questionId: questionId,
                    answer: answer
                )
            }
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            apply(envelope)
        } catch {
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            handle(error, auth: auth)
        }
    }

    func perform(_ action: RemoteAction, auth: AuthStore) async {
        guard canMutate else { return }
        let generation = contextGeneration
        let owner = auth.session?.userId
        isWorking = true
        errorMessage = nil
        feedback = nil
        defer { if generation == contextGeneration { isWorking = false } }
        do {
            let envelope = try await authorizedRequest(auth: auth) { token in
                try await client.submit(
                    action: action,
                    expectedRevision: revision,
                    token: token
                )
            }
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            apply(envelope)
        } catch {
            guard generation == contextGeneration && auth.session?.userId == owner else { return }
            handle(error, auth: auth)
        }
    }

    func reset(auth: AuthStore) async {
        await perform(.reset, auth: auth)
    }

    func clear() {
        contextGeneration += 1
        journey = nil
        revision = 0
        resetRequired = false
        feedback = nil
        errorMessage = nil
        isLoading = false
        isWorking = false
        requiresReload = false
    }

    private func authorizedRequest<T>(
        auth: AuthStore,
        _ operation: (String) async throws -> T
    ) async throws -> T {
        let owner = auth.session?.userId
        do {
            let token = try await auth.accessToken()
            guard auth.session?.userId == owner else { throw CancellationError() }
            return try await operation(token)
        } catch APIClientError.unauthorized {
            guard auth.session?.userId == owner else { throw CancellationError() }
            let token = try await auth.accessToken(forceRefresh: true)
            guard auth.session?.userId == owner else { throw CancellationError() }
            return try await operation(token)
        }
    }

    private func apply(_ envelope: RemoteJourneyEnvelope) {
        revision = envelope.revision
        resetRequired = envelope.resetRequired ?? false
        journey = envelope.journey
        feedback = envelope.feedback
        requiresReload = false
        if resetRequired {
            errorMessage = "Sesi lama perlu dimulai ulang sebelum melanjutkan."
        } else {
            errorMessage = nil
        }
    }

    private func handle(_ error: Error, auth: AuthStore) {
        guard let apiError = error as? APIClientError else {
            errorMessage = error.localizedDescription
            return
        }
        switch apiError {
        case .unauthorized:
            auth.signOut()
            errorMessage = "Sesi berakhir. Silakan masuk lagi."
        case .http(_, let code, let message, let revision):
            if code == "reset_required" {
                resetRequired = true
                if let revision { self.revision = revision }
                errorMessage = message ?? "Sesi lama perlu dimulai ulang."
            } else if code == "revision_conflict" {
                requiresReload = true
                errorMessage = "Kemajuan berubah di perangkat lain. Muat ulang sebelum melanjutkan."
            } else if code == "expanded_form_required" {
                errorMessage = message ?? "Tuliskan bentuk tanpa tanda kurung, lalu kirim lagi."
            } else {
                errorMessage = message ?? "Permintaan belajar gagal."
                if case .http(let status, _, _, _) = apiError, status >= 500 {
                    requiresReload = true
                }
            }
        case .network, .invalidResponse, .decoding:
            requiresReload = true
            errorMessage = "Belum bisa memastikan jawaban tersimpan. Periksa status jawaban dulu sebelum mengirim ulang."
        }
    }
}
