import Foundation

enum LearningPhase: String, Codable {
    case diagnosticIntroduction
    case preTest
    case diagnosticProbe
    case diagnosisResult
    case visualExplanation
    case workedExample
    case guidedPractice
    case validationIntro
    case independentRetry
    case transferProblem
    case learningResult
    case completed
}

extension LearningPhase {
    var isLearningPhase: Bool {
        switch self {
        case .visualExplanation, .workedExample, .guidedPractice, .validationIntro,
             .independentRetry, .transferProblem, .learningResult: true
        default: false
        }
    }
}

enum DiagnosticStatus: String, Codable {
    case confirmed
    case rejected
    case uncertain
    case allCorrect
}

enum LearningStatus: String, Codable {
    case understood
    case proceduralOnly
    case needsReinforcement
}

enum LearningMode: String, Codable {
    case targetedRecovery
    case optionalReview
}

struct QuestionAttempt: Identifiable, Codable {
    let id: UUID
    let questionID: String
    let responseOptionID: String
    let isCorrect: Bool
    let matchedErrorPatternID: String?
    let probeSignal: ProbeSignal?
    let phase: LearningPhase
    let submittedAt: Date
    var reasoning: String? = nil
}

struct LearningAttempt: Identifiable, Codable {
    let id: UUID
    let questionID: String
    let response: String
    let isCorrect: Bool
    let phase: LearningPhase
    let hintUsed: Bool
    let submittedAt: Date
}

struct DiagnosticEvidence: Codable {
    var suspectedBlockerID: String?
    var observedErrorPatternID: String?
    var preTestAttemptID: UUID?
    var probeAttemptID: UUID?
    var decisionRuleID: String?
}

struct LearningSession: Identifiable, Codable {
    let id: UUID
    let topicID: String
    let contentVersion: String
    let contentReviewStatus: ContentReviewStatus
    var currentPhase: LearningPhase
    var diagnosticStatus: DiagnosticStatus?
    var learningMode: LearningMode?
    var learningStatus: LearningStatus?
    var questionAttempts: [QuestionAttempt]
    var diagnosticEvidence: DiagnosticEvidence
    var completedStepIDs: [String]
    var learningAttempts: [LearningAttempt]
    var interventionPackageID: String?
    var learningContentVersion: String?
    var diagnosisRuleVersion: String?
    var visualRevealed: Bool
    var workedStepCount: Int
    var practiceStepIndex: Int
    var reinforcementCount: Int
    var retryQuestionIndex: Int
    let startedAt: Date
    var updatedAt: Date

    init(topicID: String, content: DiagnosticContentPack, now: Date = Date()) {
        id = UUID()
        self.topicID = topicID
        contentVersion = content.version
        contentReviewStatus = content.reviewStatus
        currentPhase = .preTest
        diagnosticStatus = nil
        learningMode = nil
        learningStatus = nil
        questionAttempts = []
        diagnosticEvidence = DiagnosticEvidence()
        completedStepIDs = []
        learningAttempts = []
        interventionPackageID = nil
        learningContentVersion = nil
        diagnosisRuleVersion = "draft-diagnosis-rules-v0.1"
        visualRevealed = false
        workedStepCount = 0
        practiceStepIndex = 0
        reinforcementCount = 0
        retryQuestionIndex = 0
        startedAt = now
        updatedAt = now
    }

    private enum CodingKeys: String, CodingKey {
        case id, topicID, contentVersion, contentReviewStatus, currentPhase
        case diagnosticStatus, learningMode, learningStatus, questionAttempts
        case diagnosticEvidence, completedStepIDs, learningAttempts
        case interventionPackageID, learningContentVersion, diagnosisRuleVersion
        case visualRevealed, workedStepCount, practiceStepIndex, reinforcementCount
        case retryQuestionIndex, startedAt, updatedAt
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        topicID = try values.decode(String.self, forKey: .topicID)
        contentVersion = try values.decode(String.self, forKey: .contentVersion)
        contentReviewStatus = try values.decode(ContentReviewStatus.self, forKey: .contentReviewStatus)
        currentPhase = try values.decode(LearningPhase.self, forKey: .currentPhase)
        diagnosticStatus = try values.decodeIfPresent(DiagnosticStatus.self, forKey: .diagnosticStatus)
        learningMode = try values.decodeIfPresent(LearningMode.self, forKey: .learningMode)
        learningStatus = try values.decodeIfPresent(LearningStatus.self, forKey: .learningStatus)
        questionAttempts = try values.decode([QuestionAttempt].self, forKey: .questionAttempts)
        diagnosticEvidence = try values.decode(DiagnosticEvidence.self, forKey: .diagnosticEvidence)
        completedStepIDs = try values.decode([String].self, forKey: .completedStepIDs)
        learningAttempts = try values.decodeIfPresent([LearningAttempt].self, forKey: .learningAttempts) ?? []
        interventionPackageID = try values.decodeIfPresent(String.self, forKey: .interventionPackageID)
        learningContentVersion = try values.decodeIfPresent(String.self, forKey: .learningContentVersion)
        diagnosisRuleVersion = try values.decodeIfPresent(String.self, forKey: .diagnosisRuleVersion)
        visualRevealed = try values.decodeIfPresent(Bool.self, forKey: .visualRevealed) ?? false
        workedStepCount = try values.decodeIfPresent(Int.self, forKey: .workedStepCount) ?? 0
        practiceStepIndex = try values.decodeIfPresent(Int.self, forKey: .practiceStepIndex) ?? 0
        reinforcementCount = try values.decodeIfPresent(Int.self, forKey: .reinforcementCount) ?? 0
        retryQuestionIndex = try values.decodeIfPresent(Int.self, forKey: .retryQuestionIndex) ?? 0
        startedAt = try values.decode(Date.self, forKey: .startedAt)
        updatedAt = try values.decode(Date.self, forKey: .updatedAt)
    }
}
