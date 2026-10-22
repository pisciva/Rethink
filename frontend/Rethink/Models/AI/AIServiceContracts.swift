import Foundation

enum SupportedMathPrompt {
    case integer(expected: Int)
    case linearExpression(coefficient: Int, constant: Int)
}

struct MathValidationResult {
    let isCorrect: Bool
}

struct ReasoningInterpretationRequest {
    let questionID: String
    let conceptID: String
    let response: String
    let optionalReasoning: String?
    let deterministicIsCorrect: Bool
    let contentVersion: String
}

struct ReasoningInterpretation {
    let note: String
    let isAmbiguous: Bool
}

struct LearningFeedbackRequest {
    let conceptID: String
    let learningStatus: LearningStatus
    let contentVersion: String
}

struct LearningFeedback {
    let message: String
}
