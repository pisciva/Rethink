import Foundation

struct SupabaseUser: Decodable {
    let id: String
    let email: String?
    let isAnonymous: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case isAnonymous = "is_anonymous"
    }
}

struct SupabaseAuthResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    let user: SupabaseUser?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case user
    }
}

enum AuthServiceError: Error, LocalizedError {
    case notConfigured
    case emailConfirmationRequired
    case missingSession
    case service(String)
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Konfigurasi backend belum diisi di AppConfig.swift."
        case .emailConfirmationRequired:
            return "Akun dibuat. Cek email untuk konfirmasi, lalu masuk kembali."
        case .missingSession:
            return "Sesi tamu tidak dapat dibuat. Coba lagi."
        case .service(let message):
            return message
        case .invalidResponse:
            return "Layanan akun tidak dapat dihubungi."
        }
    }
}

private struct SupabaseCredentials: Encodable {
    let email: String
    let password: String
}

private struct SupabaseRefresh: Encodable {
    let refresh_token: String
}

private struct SupabaseErrorBody: Decodable {
    let error_description: String?
    let msg: String?
    let message: String?
    let error: String?
}

struct SupabaseAuthClient {
    let baseURL: URL
    let publishableKey: String
    private let session: URLSession

    init(
        baseURL: URL = AppConfig.supabaseURL,
        publishableKey: String = AppConfig.supabasePublishableKey,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.publishableKey = publishableKey
        self.session = session
    }

    func signInAnonymously() async throws -> SupabaseAuthResponse {
        try await request(
            path: "auth/v1/signup",
            query: [],
            body: Data("{}".utf8)
        )
    }

    func signIn(email: String, password: String) async throws -> SupabaseAuthResponse {
        try await request(
            path: "auth/v1/token",
            query: [URLQueryItem(name: "grant_type", value: "password")],
            body: try JSONEncoder().encode(SupabaseCredentials(email: email, password: password))
        )
    }

    func signUp(email: String, password: String) async throws -> SupabaseAuthResponse {
        try await request(
            path: "auth/v1/signup",
            query: [],
            body: try JSONEncoder().encode(SupabaseCredentials(email: email, password: password))
        )
    }

    func refresh(refreshToken: String) async throws -> SupabaseAuthResponse {
        try await request(
            path: "auth/v1/token",
            query: [URLQueryItem(name: "grant_type", value: "refresh_token")],
            body: try JSONEncoder().encode(SupabaseRefresh(refresh_token: refreshToken))
        )
    }

    private func request(path: String, query: [URLQueryItem], body: Data) async throws -> SupabaseAuthResponse {
        guard AppConfig.isConfigured else { throw AuthServiceError.notConfigured }
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            throw AuthServiceError.invalidResponse
        }
        components.queryItems = query.isEmpty ? nil : query
        guard let url = components.url else { throw AuthServiceError.invalidResponse }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(publishableKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(publishableKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = body

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw AuthServiceError.invalidResponse
        }

        guard let http = response as? HTTPURLResponse else {
            throw AuthServiceError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            let errorBody = try? JSONDecoder().decode(SupabaseErrorBody.self, from: data)
            let message = errorBody?.error_description
                ?? errorBody?.msg
                ?? errorBody?.message
                ?? errorBody?.error
                ?? "Autentikasi gagal."
            throw AuthServiceError.service(message)
        }

        do {
            return try JSONDecoder().decode(SupabaseAuthResponse.self, from: data)
        } catch {
            throw AuthServiceError.invalidResponse
        }
    }
}
