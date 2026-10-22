import Foundation

enum APIClientError: Error, LocalizedError {
    case invalidResponse
    case network(String)
    case unauthorized
    case http(status: Int, code: String?, message: String?, revision: Int?)
    case decoding

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Respons server tidak valid."
        case .network:
            return "Tidak dapat terhubung ke layanan. Periksa koneksi lalu coba lagi."
        case .unauthorized:
            return "Sesi berakhir. Silakan masuk lagi."
        case .http(_, _, let message, _):
            return message ?? "Permintaan ke server gagal."
        case .decoding:
            return "Data dari server tidak dapat dibaca."
        }
    }

    var code: String? {
        if case .http(_, let code, _, _) = self { return code }
        return nil
    }

    var revision: Int? {
        if case .http(_, _, _, let revision) = self { return revision }
        return nil
    }
}

private struct APIErrorBody: Decodable {
    let error: String?
    let message: String?
    let code: String?
    let revision: Int?
}

private struct RemoteCommand: Encodable {
    let concept = "distribution"
    let action: String
    let expectedRevision: Int
    let topicId: String?
    let questionId: String?
    let answer: String?

    enum CodingKeys: String, CodingKey {
        case concept, action, expectedRevision, topicId, questionId, answer
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(concept, forKey: .concept)
        try container.encode(action, forKey: .action)
        try container.encode(expectedRevision, forKey: .expectedRevision)
        try container.encodeIfPresent(topicId, forKey: .topicId)
        try container.encodeIfPresent(questionId, forKey: .questionId)
        try container.encodeIfPresent(answer, forKey: .answer)
    }
}

struct APIClient {
    let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = AppConfig.backendBaseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func catalog() async throws -> RemoteCatalog {
        try await request(path: "/api/v2/catalog", method: "GET", token: nil)
    }

    func journey(token: String) async throws -> RemoteJourneyEnvelope {
        try await request(path: "/api/v2/progress", method: "GET", token: token)
    }

    func submit(
        action: RemoteAction,
        expectedRevision: Int,
        token: String,
        topicId: String? = nil,
        questionId: String? = nil,
        answer: String? = nil
    ) async throws -> RemoteJourneyEnvelope {
        let command = RemoteCommand(
            action: action.rawValue,
            expectedRevision: expectedRevision,
            topicId: topicId,
            questionId: questionId,
            answer: answer
        )
        let body = try JSONEncoder().encode(command)
        return try await request(path: "/api/v2/progress", method: "POST", token: token, body: body)
    }

    private func request<T: Decodable>(
        path: String,
        method: String,
        token: String?,
        body: Data? = nil
    ) async throws -> T {
        let cleanPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        var request = URLRequest(url: baseURL.appendingPathComponent(cleanPath))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("no-store", forHTTPHeaderField: "Cache-Control")
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIClientError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            let errorBody = try? JSONDecoder().decode(APIErrorBody.self, from: data)
            if http.statusCode == 401 { throw APIClientError.unauthorized }
            throw APIClientError.http(
                status: http.statusCode,
                code: errorBody?.code,
                message: errorBody?.error ?? errorBody?.message,
                revision: errorBody?.revision
            )
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIClientError.decoding
        }
    }
}
