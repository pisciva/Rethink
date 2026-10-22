import XCTest
@testable import DiagnosisCore

final class RemoteModelsTests: XCTestCase {
    func testCatalogDecodesCapabilitiesAndAvailability() throws {
        let json = """
        {
          "version": 2,
          "contentVersion": "spl-distribution-draft-3",
          "contentStatus": "draft-ops-04",
          "subjects": [{
            "id": "algebra",
            "title": "Algebra",
            "topics": [{
              "id": "spl",
              "title": "Sistem Persamaan Linear",
              "availability": "active",
              "capabilities": {"diagnosis":"active","guidedLearning":"active","validation":"confirmed-recovery-only"},
              "concepts": [{"id":"distribution","title":"Sifat Distributif","availability":"active-recovery","capabilities":{"diagnosis":"active","guidedLearning":"active","validation":"confirmed-recovery-only"}}]
            }]
          }],
          "relationships": [{"from":"distribution","to":"spl","kind":"prerequisite"}],
          "coverage": {"represented":["algebra","spl","distribution"],"activelySupported":["spl","distribution"]}
        }
        """.data(using: .utf8)!

        let catalog = try JSONDecoder().decode(RemoteCatalog.self, from: json)
        XCTAssertEqual(catalog.contentVersion, "spl-distribution-draft-3")
        XCTAssertEqual(catalog.subjects.first?.topics.first?.capabilities?.validation, "confirmed-recovery-only")
        XCTAssertEqual(catalog.relationships.first?.from, "distribution")
    }

    func testJourneyDecodesDiagnosisPendingAndResetEnvelope() throws {
        let json = """
        {
          "version": 2,
          "revision": 4,
          "updatedAt": "2026-10-18T00:00:00Z",
          "resetRequired": false,
          "journey": {
            "version": 2,
            "contentVersion": "spl-distribution-draft-3",
            "concept": "distribution",
            "selectedTopic": "spl",
            "phase": "diagnostic-decision-pending",
            "origin": null,
            "currentQuestion": null,
            "learningContent": null,
            "diagnosticOutcome": null,
            "learningCompleted": false,
            "learnerState": null,
            "resultExplanation": "Menunggu keputusan.",
            "availableActions": [],
            "attempts": [],
            "map": {"explore":"spl","focus":null,"progress":null},
            "operationalStatus": "draft-ops-01-05"
          }
        }
        """.data(using: .utf8)!

        let envelope = try JSONDecoder().decode(RemoteJourneyEnvelope.self, from: json)
        XCTAssertEqual(envelope.revision, 4)
        XCTAssertEqual(envelope.journey?.phase, .diagnosticDecisionPending)
        XCTAssertNil(envelope.journey?.diagnosticOutcome)

        let reset = try JSONDecoder().decode(
            RemoteJourneyEnvelope.self,
            from: #"{"version":2,"revision":5,"resetRequired":true,"journey":null}"#.data(using: .utf8)!
        )
        XCTAssertTrue(reset.resetRequired ?? false)
        XCTAssertNil(reset.journey)
    }
}

final class SupabaseAuthDecodingTests: XCTestCase {
    func testAnonymousAuthResponseDecodesSessionAndFlag() throws {
        let json = """
        {
          "access_token": "access",
          "refresh_token": "refresh",
          "expires_in": 3600,
          "user": {"id":"00000000-0000-0000-0000-000000000001","email":null,"is_anonymous":true}
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(SupabaseAuthResponse.self, from: json)
        XCTAssertEqual(response.accessToken, "access")
        XCTAssertEqual(response.user?.isAnonymous, true)
        XCTAssertNil(response.user?.email)
    }
}

private final class MemorySessionTokens: SessionTokenStore {
    var data: Data?
    func load() -> Data? { data }
    func save(_ data: Data) { self.data = data }
    func clear() { data = nil }
}

private final class RecoveryURLProtocol: URLProtocol {
    static var handler: ((URLRequest) throws -> (Int, Data))?
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}
    override func startLoading() {
        do {
            let (status, data) = try Self.handler!(request)
            let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch { client?.urlProtocol(self, didFailWithError: error) }
    }
}

final class RecoverySessionTests: XCTestCase {
    private func network() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [RecoveryURLProtocol.self]
        return URLSession(configuration: config)
    }

    @MainActor
    private func auth(expired: Bool = false) -> (AuthStore, MemorySessionTokens) {
        let tokens = MemorySessionTokens()
        tokens.data = try! JSONEncoder().encode(AuthSession(
            accessToken: "access", refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(expired ? -60 : 3600),
            userId: "guest-one", email: nil, isAnonymous: true
        ))
        let client = SupabaseAuthClient(baseURL: URL(string: "https://auth.test")!,
                                        publishableKey: "public-test", session: network())
        return (AuthStore(client: client, tokenStore: tokens), tokens)
    }

    private func envelope(revision: Int, questionID: String = "spl-q1") -> Data {
        Data("""
        {"version":2,"revision":\(revision),"resetRequired":false,"journey":{
          "version":2,"contentVersion":"spl-distribution-draft-3","concept":"distribution",
          "selectedTopic":"spl","phase":"diagnosis","origin":null,
          "currentQuestion":{"id":"\(questionID)","role":"q1-target","prompt":"Soal","format":"choice","options":[{"id":"A","text":"A"}]},
          "learningContent":null,"diagnosticOutcome":null,"learningCompleted":false,"learnerState":null,
          "resultExplanation":null,"availableActions":[],"attempts":[],
          "map":{"explore":"spl","focus":null,"progress":null},"operationalStatus":"test"
        }}
        """.utf8)
    }

    @MainActor
    func testFRX01TemporaryRefreshOutagePreservesGuestAndDurableToken() async {
        RecoveryURLProtocol.handler = { _ in (503, Data(#"{"msg":"temporary outage"}"#.utf8)) }
        defer { RecoveryURLProtocol.handler = nil }
        let (auth, tokens) = self.auth(expired: true)
        let original = tokens.data
        await auth.restore()
        XCTAssertEqual(auth.session?.userId, "guest-one")
        XCTAssertEqual(tokens.data, original)
        XCTAssertNotNil(auth.errorMessage)
        XCTAssertFalse(auth.isRestoring)
    }

    @MainActor
    func testFRX01ExplicitlyRevokedRefreshTokenEndsSession() async {
        RecoveryURLProtocol.handler = { _ in
            (400, Data(#"{"error_code":"refresh_token_not_found","msg":"revoked"}"#.utf8))
        }
        defer { RecoveryURLProtocol.handler = nil }
        let (auth, tokens) = self.auth(expired: true)
        await auth.restore()
        XCTAssertNil(auth.session)
        XCTAssertNil(tokens.data)
    }

    @MainActor
    func testFRX01ConcurrentRefreshUsesOneRequestAndRotatedCredentials() async throws {
        let lock = NSLock()
        var count = 0
        RecoveryURLProtocol.handler = { _ in
            lock.lock(); count += 1; lock.unlock()
            return (200, Data(#"{"access_token":"rotated","refresh_token":"rotated-refresh","expires_in":3600,"user":{"id":"guest-one","is_anonymous":true}}"#.utf8))
        }
        defer { RecoveryURLProtocol.handler = nil }
        let (auth, tokens) = self.auth()
        await auth.restore()
        async let first = auth.accessToken(forceRefresh: true)
        async let second = auth.accessToken(forceRefresh: true)
        let values = try await (first, second)
        XCTAssertEqual(values.0, "rotated")
        XCTAssertEqual(values.1, "rotated")
        XCTAssertEqual(count, 1)
        XCTAssertEqual(try JSONDecoder().decode(AuthSession.self, from: tokens.data!).refreshToken, "rotated-refresh")
    }

    @MainActor
    func testFRX02UnknownSaveBlocksResubmissionUntilAuthoritativeReload() async {
        let (auth, _) = self.auth()
        await auth.restore()
        let store = JourneyStore(client: APIClient(baseURL: URL(string: "https://api.test")!, session: network()))
        var posts = 0
        var revision = 1
        RecoveryURLProtocol.handler = { [self] request in
            if request.httpMethod == "POST" {
                posts += 1
                throw URLError(.timedOut)
            }
            return (200, envelope(revision: revision))
        }
        defer { RecoveryURLProtocol.handler = nil }
        await store.load(auth: auth)
        await store.submit(questionId: "spl-q1", answer: "B", auth: auth)
        XCTAssertTrue(store.requiresReload)
        XCTAssertFalse(store.canMutate)
        XCTAssertEqual(store.revision, 1)
        await store.submit(questionId: "spl-q1", answer: "B", auth: auth)
        XCTAssertEqual(posts, 1, "unknown write outcome must not trigger a duplicate submission")
        revision = 2
        await store.load(auth: auth)
        XCTAssertFalse(store.requiresReload)
        XCTAssertEqual(store.revision, 2)
        XCTAssertTrue(store.canMutate)
    }

    @MainActor
    func testFRX02RevisionConflictRequiresReloadAndNeverAssignsLocalState() async {
        let (auth, _) = self.auth()
        await auth.restore()
        let store = JourneyStore(client: APIClient(baseURL: URL(string: "https://api.test")!, session: network()))
        RecoveryURLProtocol.handler = { [self] request in
            if request.httpMethod == "POST" {
                return (409, Data(#"{"code":"revision_conflict","error":"reload"}"#.utf8))
            }
            return (200, envelope(revision: 3))
        }
        defer { RecoveryURLProtocol.handler = nil }
        await store.load(auth: auth)
        await store.submit(questionId: "spl-q1", answer: "B", auth: auth)
        XCTAssertEqual(store.revision, 3)
        XCTAssertTrue(store.requiresReload)
        XCTAssertNil(store.journey?.learnerState)
        XCTAssertNil(store.feedback)
    }

    func testGAMProjectionDecodesSavedEvidenceAndRecognitionWithoutInventingFields() throws {
        let data = Data(#"{"stages":[{"id":"diagnosis","label":"Pemeriksaan konsep","state":"complete"},{"id":"learning","label":"Belajar terarah","state":"complete"},{"id":"validation","label":"Uji pemahaman","state":"complete"}],"activity":"Hasil validasi Sifat Distributif","context":"confirmed-recovery","validation":{"retry":"passed","transfer":"passed"},"achievement":{"id":"result-one","concept":"distribution","earnedAt":"2026-10-23T04:00:00Z"}}"#.utf8)
        let projection = try JSONDecoder().decode(RemoteJourneyPresentation.self, from: data)
        XCTAssertEqual(projection.context, .confirmedRecovery)
        XCTAssertEqual(projection.validation?.transfer, "passed")
        XCTAssertEqual(projection.achievement?.concept, "distribution")
        XCTAssertEqual(projection.stages.count, 3)
    }

    @MainActor
    func testFRX01ClearingIdentityDiscardsAnOlderInFlightJourneyResponse() async {
        let (auth, _) = self.auth()
        await auth.restore()
        let store = JourneyStore(client: APIClient(baseURL: URL(string: "https://api.test")!, session: network()))
        let started = expectation(description: "old identity request started")
        let gate = DispatchSemaphore(value: 0)
        let data = envelope(revision: 9)
        RecoveryURLProtocol.handler = { _ in
            started.fulfill()
            _ = gate.wait(timeout: .now() + 3)
            return (200, data)
        }
        defer { gate.signal(); RecoveryURLProtocol.handler = nil }
        let request = Task { await store.load(auth: auth) }
        await fulfillment(of: [started], timeout: 2)
        auth.signOut()
        store.clear()
        gate.signal()
        await request.value
        XCTAssertNil(store.journey)
        XCTAssertEqual(store.revision, 0)
        XCTAssertFalse(store.isLoading)
        XCTAssertNil(store.errorMessage)
    }
}
