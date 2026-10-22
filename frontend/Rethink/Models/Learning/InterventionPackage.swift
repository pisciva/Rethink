import Foundation

struct WorkedExampleStep: Identifiable, Codable {
    let id: String
    let expression: String
    let reason: String
}

struct GuidedPracticeStep: Identifiable, Codable {
    let id: String
    let prompt: String
    let expectedValue: Int
    let hint: String
    let incorrectFeedback: String
}

struct NumericValidationQuestion: Identifiable, Codable {
    let id: String
    let prompt: String
    let expectedValue: Int
}

struct LinearExpressionQuestion: Identifiable, Codable {
    let id: String
    let prompt: String
    let expectedCoefficient: Int
    let expectedConstant: Int
}

struct InterventionPackage: Codable {
    let id: String
    let conceptID: String
    let conceptTitle: String
    let version: String
    let reviewStatus: ContentReviewStatus
    let visualExpression: String
    let visualGroups: [String]
    let visualExplanation: String
    let workedProblem: String
    let workedSteps: [WorkedExampleStep]
    let practiceProblem: String
    let practiceSteps: [GuidedPracticeStep]
    let retryQuestions: [NumericValidationQuestion]
    let transferQuestion: LinearExpressionQuestion
}
