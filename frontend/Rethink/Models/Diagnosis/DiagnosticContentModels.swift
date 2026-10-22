import Foundation

enum ContentReviewStatus: String, Codable {
    case draft
    case reviewed
    case approved
}

enum ProbeSignal: String, Codable {
    case supportsBlocker
    case contradictsBlocker
    case ambiguous
}

struct DiagnosticOption: Identifiable, Codable {
    let id: String
    let text: String
    let isCorrect: Bool
    let errorPatternID: String?
    let probeSignal: ProbeSignal?
}

struct DiagnosticQuestion: Identifiable, Codable {
    let id: String
    let prompt: String
    let context: String?
    let instruction: String
    let options: [DiagnosticOption]
}

struct DiagnosticContentPack: Codable {
    let version: String
    let reviewStatus: ContentReviewStatus
    let topicID: String
    let blockerID: String
    let blockerTitle: String
    let knownErrorPatternID: String
    let preTest: DiagnosticQuestion
    let conceptualProbe: DiagnosticQuestion
}

struct AnswerEvaluation {
    let isCorrect: Bool
    let matchedErrorPatternID: String?
    let probeSignal: ProbeSignal?
}
