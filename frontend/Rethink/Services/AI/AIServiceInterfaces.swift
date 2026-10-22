import Foundation

protocol MathValidating {
    func validate(response: String, prompt: SupportedMathPrompt) async throws -> MathValidationResult
}

protocol ReasoningInterpreting {
    func interpret(request: ReasoningInterpretationRequest) async throws -> ReasoningInterpretation
}

protocol LearningFeedbackProviding {
    func feedback(request: LearningFeedbackRequest) async throws -> LearningFeedback
}

struct LocalMathValidationAdapter: MathValidating {
    private let validator = LocalLearningValidator()

    func validate(response: String, prompt: SupportedMathPrompt) async throws -> MathValidationResult {
        let correct: Bool
        switch prompt {
        case .integer(let expected):
            correct = try validator.checkNumber(response, expected: expected)
        case .linearExpression(let coefficient, let constant):
            correct = try validator.checkLinearExpression(response, coefficient: coefficient, constant: constant)
        }
        return MathValidationResult(isCorrect: correct)
    }
}

enum ReasoningServiceError: Error {
    case unavailable
}

/// No remote API is configured in this MVP. The deterministic learning flow does not call this adapter.
struct UnavailableReasoningInterpreter: ReasoningInterpreting {
    func interpret(request: ReasoningInterpretationRequest) async throws -> ReasoningInterpretation {
        throw ReasoningServiceError.unavailable
    }
}

struct CuratedLearningFeedbackProvider: LearningFeedbackProviding {
    func feedback(request: LearningFeedbackRequest) async throws -> LearningFeedback {
        let message: String
        switch request.learningStatus {
        case .understood: message = "Kamu berhasil menggunakan konsep ini secara mandiri dan dalam situasi berbeda."
        case .proceduralOnly: message = "Langkahnya sudah bisa, tetapi penerapannya pada konteks baru masih perlu latihan."
        case .needsReinforcement: message = "Konsep ini masih perlu diperkuat sebelum dicoba kembali tanpa bantuan."
        }
        return LearningFeedback(message: message)
    }
}
