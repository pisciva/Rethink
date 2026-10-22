import Combine
import Foundation

@MainActor
final class JourneyStore: ObservableObject {
    @Published private(set) var journey: RemoteJourney?
    @Published private(set) var revision = 0
    @Published private(set) var resetRequired = false
    @Published private(set) var isLoading = false
    @Published private(set) var isWorking = false
    @Published private(set) var feedback: String?
    @Published var errorMessage: String?

    private let client: APIClient

    init(client: APIClient? = nil) {
        self.client = client ?? APIClient()
    }

    func load(auth: AuthStore) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let envelope = try await authorizedRequest(auth: auth) { token in
                try await client.journey(token: token)
            }
            apply(envelope)
        } catch {
            handle(error, auth: auth)
        }
    }

    func selectTopic(_ topicId: String, auth: AuthStore) async {
        guard !isWorking else { return }
        isWorking = true
        errorMessage = nil
        feedback = nil
        defer { isWorking = false }
        do {
            let envelope = try await authorizedRequest(auth: auth) { token in
                try await client.submit(
                    action: .selectTopic,
                    expectedRevision: revision,
                    token: token,
                    topicId: topicId
                )
            }
            apply(envelope)
        } catch {
            handle(error, auth: auth)
        }
    }

    func submit(questionId: String, answer: String, auth: AuthStore) async {
        guard !isWorking else { return }
        isWorking = true
        errorMessage = nil
        feedback = nil
        defer { isWorking = false }
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
            apply(envelope)
        } catch {
            handle(error, auth: auth)
        }
    }

    func perform(_ action: RemoteAction, auth: AuthStore) async {
        guard !isWorking else { return }
        isWorking = true
        errorMessage = nil
        feedback = nil
        defer { isWorking = false }
        do {
            let envelope = try await authorizedRequest(auth: auth) { token in
                try await client.submit(
                    action: action,
                    expectedRevision: revision,
                    token: token
                )
            }
            apply(envelope)
        } catch {
            handle(error, auth: auth)
        }
    }

    func reset(auth: AuthStore) async {
        await perform(.reset, auth: auth)
    }

    func clear() {
        journey = nil
        revision = 0
        resetRequired = false
        feedback = nil
        errorMessage = nil
    }

    private func authorizedRequest<T>(
        auth: AuthStore,
        _ operation: (String) async throws -> T
    ) async throws -> T {
        do {
            return try await operation(try await auth.accessToken())
        } catch APIClientError.unauthorized {
            return try await operation(try await auth.accessToken(forceRefresh: true))
        }
    }

    private func apply(_ envelope: RemoteJourneyEnvelope) {
        revision = envelope.revision
        resetRequired = envelope.resetRequired ?? false
        journey = envelope.journey
        feedback = envelope.feedback
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
                errorMessage = "Kemajuan berubah di perangkat lain. Muat ulang sebelum melanjutkan."
            } else if code == "expanded_form_required" {
                errorMessage = message ?? "Tuliskan bentuk tanpa tanda kurung, lalu kirim lagi."
            } else {
                errorMessage = message ?? "Permintaan belajar gagal."
            }
        default:
            errorMessage = apiError.localizedDescription
        }
    }
}
