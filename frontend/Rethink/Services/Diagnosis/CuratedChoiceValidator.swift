import Foundation

enum AnswerValidationError: Error {
    case unknownOption
}

protocol MathAnswerValidating {
    func evaluate(optionID: String, for question: DiagnosticQuestion) throws -> AnswerEvaluation
}

/// MVP checker for curated choices only. It does not claim general algebra equivalence.
struct CuratedChoiceValidator: MathAnswerValidating {
    func evaluate(optionID: String, for question: DiagnosticQuestion) throws -> AnswerEvaluation {
        guard let option = question.options.first(where: { $0.id == optionID }) else {
            throw AnswerValidationError.unknownOption
        }
        return AnswerEvaluation(
            isCorrect: option.isCorrect,
            matchedErrorPatternID: option.errorPatternID,
            probeSignal: option.probeSignal
        )
    }
}

