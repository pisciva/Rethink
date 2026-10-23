import Foundation
import XCTest
@testable import DiagnosisCore

private final class CatalogURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func stopLoading() {}

    override func startLoading() {
        let json = """
        {
          "version": 2, "contentVersion": "test", "contentStatus": "draft-ops-04",
          "subjects": [{"id":"algebra","title":"Algebra","topics":[{
            "id":"spl","title":"Sistem Persamaan Linear","availability":"active",
            "capabilities":{"diagnosis":"unavailable","guidedLearning":"active","validation":"unavailable"},
            "concepts":[]
          }]}],
          "relationships":[], "coverage":{"represented":["algebra","spl"],"activelySupported":[]}
        }
        """
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(json.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }
}

final class CatalogSupportTests: XCTestCase {
    @MainActor
    func testTopicWithoutActiveDiagnosisCannotBeOpenedFromCatalog() async {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [CatalogURLProtocol.self]
        let client = APIClient(baseURL: URL(string: "https://backend.test")!,
                               session: URLSession(configuration: configuration))
        let store = CatalogStore(client: client)

        await store.load()

        XCTAssertNil(store.errorMessage)
        XCTAssertEqual(store.subjects.first?.availability, .unavailable)
        XCTAssertEqual(store.subjects.first?.topics.first?.availability, .unavailable)
        XCTAssertTrue(store.subjects.first?.subtopics.isEmpty == true,
                      "subject/topic API must not grow a fabricated local curriculum")
    }
}
