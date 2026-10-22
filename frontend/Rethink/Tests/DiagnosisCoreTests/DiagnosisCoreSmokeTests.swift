import XCTest
@testable import DiagnosisCore

final class DiagnosisCoreSmokeTests: XCTestCase {
    func testValidationMatrixMatchesApprovedThreeStateRule() {
        let policy = LearningValidationPolicy()

        XCTAssertNil(policy.afterIndependentRetry(isCorrect: true))
        XCTAssertEqual(policy.afterIndependentRetry(isCorrect: false)?.rawValue, "needsReinforcement")
        XCTAssertEqual(policy.afterTransfer(isCorrect: true).rawValue, "understood")
        XCTAssertEqual(policy.afterTransfer(isCorrect: false).rawValue, "proceduralOnly")
    }
}
