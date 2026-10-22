import XCTest
@testable import DiagnosisCore

final class RemoteModelsTests: XCTestCase {
    func testCatalogDecodesCapabilitiesAndAvailability() throws {
        let json = """
        {
          "version": 2,
          "contentVersion": "spl-distribution-draft-2",
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
        XCTAssertEqual(catalog.contentVersion, "spl-distribution-draft-2")
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
            "contentVersion": "spl-distribution-draft-2",
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
