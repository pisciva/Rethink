import Foundation

enum RemotePhase: String, Decodable, Equatable {
    case entry
    case diagnosis
    case diagnosticResult = "diagnostic-result"
    case diagnosticDecisionPending = "diagnostic-decision-pending"
    case visual
    case worked
    case practice
    case reviewComplete = "review-complete"
    case retry
    case transfer
    case validationResult = "validation-result"
    case finalAssessment = "final-assessment"
    case finalResult = "final-result"
}

enum RemoteDiagnosticOutcome: String, Decodable, Equatable {
    case confirmed
    case rejected
    case uncertain
}

enum RemoteLearnerState: String, Decodable, Equatable {
    case understood
    case proceduralOnly = "procedural-only"
    case needsReinforcement = "needs-reinforcement"
}

enum RemoteOrigin: String, Decodable, Equatable {
    case confirmedRecovery = "confirmed-recovery"
    case optionalReview = "optional-review"
}

enum RemoteAction: String, Equatable {
    case submit
    case selectTopic = "select-topic"
    case advance
    case startRecovery = "start-recovery"
    case startReview = "start-review"
    case startValidation = "start-validation"
    case reinforce
    case reset
    case startLearning = "start-learning"
    case showResults = "show-results"
    case startFinalAssessment = "start-final-assessment"
    case requestHint = "request-hint"
    case restartDiagnosis = "restart-diagnosis"
}

enum RemoteQuestionFormat: String, Decodable, Equatable {
    case choice
    case expression
    case number
    case explanation
}

struct RemoteOption: Decodable, Identifiable {
    let id: String
    let text: String
}

struct RemoteQuestion: Decodable, Identifiable {
    let id: String
    let version: String?
    let role: String
    let prompt: String
    let math: String?
    let options: [RemoteOption]?
    let format: RemoteQuestionFormat
}

struct RemoteStep: Decodable, Identifiable {
    let expression: String
    let reason: String

    var id: String { expression + reason }
}

struct RemoteLearningContent: Decodable {
    let kind: String
    let title: String
    let explanation: String?
    let groups: Int?
    let termsPerGroup: [String]?
    let resultTerms: [String]?
    let problem: String?
    let steps: [RemoteStep]?
}

struct RemoteAttempt: Decodable, Identifiable {
    let questionId: String
    let role: String
    let answer: String
    let at: String

    var id: String { questionId + at }
}

struct RemoteMap: Decodable {
    let explore: String?
    let focus: String?
    let progress: RemoteLearnerState?
}

struct RemoteJourney: Decodable {
    let version: Int
    let contentVersion: String
    let concept: String
    let selectedTopic: String?
    let phase: RemotePhase
    let origin: RemoteOrigin?
    let currentQuestion: RemoteQuestion?
    let learningContent: RemoteLearningContent?
    let diagnosticOutcome: RemoteDiagnosticOutcome?
    let learningCompleted: Bool
    let learnerState: RemoteLearnerState?
    let resultExplanation: String?
    let availableActions: [String]
    let attempts: [RemoteAttempt]
    let map: RemoteMap
    let operationalStatus: String
    let presentation: RemoteJourneyPresentation?
    let diagnosticResults: [RemoteConceptEvidence]?
    let finalAssessment: RemoteFinalAssessment?
    let hints: [RemoteLearningHint]?
}

struct RemoteConceptEvidence: Decodable, Identifiable {
    let id: String
    let title: String
    let status: String
    let learningAvailable: Bool
    let priority: String
    let coverage: RemoteConceptCoverage
    let learnerState: RemoteLearnerState?
}

struct RemoteConceptCoverage: Decodable {
    let administered: Int
    let evaluable: Int
    let adequate: Bool
}

struct RemoteLearningHint: Decodable, Identifiable {
    let id: String
    let text: String
    let source: String
}

struct RemoteFinalAssessment: Decodable {
    let canStart: Bool
    let attempts: [RemoteFinalAttempt]
}

struct RemoteFinalAttempt: Decodable, Identifiable {
    let id: Int
    let startedAt: String
    let completedAt: String?
    let answered: Int
    let score: Int?
    let result: String?
}

struct RemoteJourneyPresentation: Decodable {
    let stages: [RemoteJourneyStage]
    let activity: String
    let context: RemoteOrigin?
    let validation: RemoteValidationEvidence?
    let achievement: RemoteConceptAchievement?
}

struct RemoteJourneyStage: Decodable, Identifiable {
    let id: String
    let label: String
    let state: String
}

struct RemoteValidationEvidence: Decodable {
    let retry: String
    let transfer: String
}

struct RemoteConceptAchievement: Decodable, Identifiable {
    let id: String
    let concept: String
    let earnedAt: String
}

struct RemoteJourneyEnvelope: Decodable {
    let version: Int
    let revision: Int
    let updatedAt: String?
    let resetRequired: Bool?
    let journey: RemoteJourney?
    let feedback: String?
}

struct RemoteCapabilities: Decodable {
    let diagnosis: String
    let guidedLearning: String
    let validation: String
}

struct RemoteConcept: Decodable, Identifiable {
    let id: String
    let title: String
    let availability: String
    let capabilities: RemoteCapabilities?
}

struct RemoteTopic: Decodable, Identifiable {
    let id: String
    let title: String
    let availability: String
    let capabilities: RemoteCapabilities?
    let concepts: [RemoteConcept]
}

struct RemoteCurriculumNode: Decodable, Identifiable {
    let id: String
    let title: String
    let availability: String
    let capabilities: RemoteCapabilities?
    let entryTopicId: String?
    let subtopics: [RemoteCurriculumNode]?
}

struct RemoteCurriculumMaterial: Decodable, Identifiable {
    let id: String
    let title: String
    let subtopics: [RemoteCurriculumNode]
}

struct RemoteCurriculumDiscipline: Decodable, Identifiable {
    let id: String
    let title: String
    let materials: [RemoteCurriculumMaterial]
}

struct RemoteSubject: Decodable, Identifiable {
    let id: String
    let title: String
    let topics: [RemoteTopic]
    let subtopics: [RemoteCurriculumNode]?
}

struct RemoteRelationship: Decodable {
    let from: String
    let to: String
    let kind: String
}

struct RemoteCoverage: Decodable {
    let represented: [String]
    let activelySupported: [String]
}

struct RemoteCatalog: Decodable {
    let version: Int
    let contentVersion: String
    let contentStatus: String
    let subjects: [RemoteSubject]
    let disciplines: [RemoteCurriculumDiscipline]?
    let relationships: [RemoteRelationship]
    let coverage: RemoteCoverage
}
