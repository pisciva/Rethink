import Combine
import Foundation

struct DiagnosisResultPresentation {
    let title: String
    let explanation: String
    let nextStep: String?
}

enum LearningSessionError: LocalizedError {
    case unsupportedTopic
    case invalidPhase
    case contentVersionChanged

    var errorDescription: String? {
        switch self {
        case .unsupportedTopic: "Topik ini belum memiliki pemeriksaan konsep."
        case .invalidPhase: "Langkah ini tidak sesuai dengan sesi saat ini."
        case .contentVersionChanged: "Konten sesi ini sudah berubah. Mulai pemeriksaan baru."
        }
    }
}

@MainActor
final class DiagnosisViewModel: ObservableObject {
    @Published private(set) var session: LearningSession?
    @Published private(set) var errorMessage: String?
    @Published private(set) var feedbackMessage: String?

    let content: DiagnosticContentPack
    let intervention: InterventionPackage
    private let repository: LearningSessionRepository
    private let validator: MathAnswerValidating
    private let learningValidator: LearningAnswerValidating
    private let policy: DiagnosisPolicy
    private let validationPolicy: LearningValidationPolicy

    init(
        content: DiagnosticContentPack? = nil,
        intervention: InterventionPackage? = nil,
        repository: LearningSessionRepository? = nil,
        validator: MathAnswerValidating? = nil,
        learningValidator: LearningAnswerValidating? = nil,
        policy: DiagnosisPolicy? = nil,
        validationPolicy: LearningValidationPolicy? = nil
    ) {
        self.content = content ?? DiagnosticContent.draftSPL
        self.intervention = intervention ?? InterventionContent.draftDistributive
        self.repository = repository ?? FileLearningSessionRepository()
        self.validator = validator ?? CuratedChoiceValidator()
        self.learningValidator = learningValidator ?? LocalLearningValidator()
        self.policy = policy ?? DiagnosisPolicy()
        self.validationPolicy = validationPolicy ?? LearningValidationPolicy()
    }

    func restore() {
        do {
            session = try repository.load()
            errorMessage = nil
        } catch {
            errorMessage = "Sesi tersimpan belum bisa dibaca. Kamu dapat memulai pemeriksaan baru."
        }
    }

    func start(topicID: String) {
        do {
            guard topicID == content.topicID else { throw LearningSessionError.unsupportedTopic }
            try commit(LearningSession(topicID: topicID, content: content))
        } catch {
            show(error)
        }
    }

    func submitPreTest(optionID: String, reasoning: String? = nil) {
        do {
            guard var next = session, next.currentPhase == .preTest else { throw LearningSessionError.invalidPhase }
            guard next.contentVersion == content.version else { throw LearningSessionError.contentVersionChanged }
            let evaluation = try validator.evaluate(optionID: optionID, for: content.preTest)
            let attempt = makeAttempt(content.preTest, optionID: optionID, evaluation: evaluation, phase: .preTest, reasoning: reasoning)
            next.questionAttempts.append(attempt)
            next.diagnosticEvidence.preTestAttemptID = attempt.id
            next.diagnosticEvidence.observedErrorPatternID = evaluation.matchedErrorPatternID

            switch policy.afterPreTest(evaluation, content: content) {
            case .final(let status, let ruleID):
                next.diagnosticStatus = status
                next.diagnosticEvidence.decisionRuleID = ruleID
                next.currentPhase = .diagnosisResult
            case .requiresProbe(let blockerID, let ruleID):
                next.diagnosticEvidence.suspectedBlockerID = blockerID
                next.diagnosticEvidence.decisionRuleID = ruleID
                next.currentPhase = .diagnosticProbe
            }
            try commit(next)
        } catch {
            show(error)
        }
    }

    func submitProbe(optionID: String, reasoning: String? = nil) {
        do {
            guard var next = session, next.currentPhase == .diagnosticProbe,
                  next.diagnosticEvidence.probeAttemptID == nil else { throw LearningSessionError.invalidPhase }
            guard next.contentVersion == content.version else { throw LearningSessionError.contentVersionChanged }
            let evaluation = try validator.evaluate(optionID: optionID, for: content.conceptualProbe)
            let attempt = makeAttempt(content.conceptualProbe, optionID: optionID, evaluation: evaluation, phase: .diagnosticProbe, reasoning: reasoning)
            next.questionAttempts.append(attempt)
            next.diagnosticEvidence.probeAttemptID = attempt.id
            let result = policy.afterProbe(evaluation)
            next.diagnosticStatus = result.status
            next.diagnosticEvidence.decisionRuleID = result.ruleID
            next.currentPhase = .diagnosisResult
            try commit(next)
        } catch {
            show(error)
        }
    }

    func clearError() { errorMessage = nil }

    var currentPracticeStep: GuidedPracticeStep? {
        guard let session, session.practiceStepIndex < intervention.practiceSteps.count else { return nil }
        return intervention.practiceSteps[session.practiceStepIndex]
    }

    var currentRetryQuestion: NumericValidationQuestion {
        let index = min(session?.retryQuestionIndex ?? 0, intervention.retryQuestions.count - 1)
        return intervention.retryQuestions[index]
    }

    func startLearning(mode: LearningMode) {
        do {
            guard var next = session, next.currentPhase == .diagnosisResult else { throw LearningSessionError.invalidPhase }
            if mode == .targetedRecovery {
                guard next.diagnosticStatus == .confirmed else { throw LearningSessionError.invalidPhase }
            } else {
                guard next.diagnosticStatus != .confirmed else { throw LearningSessionError.invalidPhase }
            }
            guard intervention.conceptID == content.blockerID else { throw LearningSessionError.unsupportedTopic }
            next.learningMode = mode
            next.interventionPackageID = intervention.id
            next.learningContentVersion = intervention.version
            next.currentPhase = .visualExplanation
            next.visualRevealed = false
            next.workedStepCount = 0
            next.practiceStepIndex = 0
            try commit(next)
        } catch { show(error) }
    }

    func revealVisual() {
        do {
            guard var next = session, next.currentPhase == .visualExplanation else { throw LearningSessionError.invalidPhase }
            next.visualRevealed = true
            try commit(next)
        } catch { show(error) }
    }

    func advanceFromVisual() {
        do {
            guard var next = session, next.currentPhase == .visualExplanation, next.visualRevealed else { throw LearningSessionError.invalidPhase }
            markCompleted("visual", in: &next)
            next.currentPhase = .workedExample
            try commit(next)
        } catch { show(error) }
    }

    func revealWorkedStep() {
        do {
            guard var next = session, next.currentPhase == .workedExample,
                  next.workedStepCount < intervention.workedSteps.count else { throw LearningSessionError.invalidPhase }
            next.workedStepCount += 1
            try commit(next)
        } catch { show(error) }
    }

    func advanceFromWorkedExample() {
        do {
            guard var next = session, next.currentPhase == .workedExample,
                  next.workedStepCount == intervention.workedSteps.count else { throw LearningSessionError.invalidPhase }
            markCompleted("worked", in: &next)
            next.currentPhase = .guidedPractice
            try commit(next)
        } catch { show(error) }
    }

    func previousLearningStep() {
        do {
            guard var next = session else { throw LearningSessionError.invalidPhase }
            switch next.currentPhase {
            case .workedExample: next.currentPhase = .visualExplanation
            case .guidedPractice: next.currentPhase = .workedExample
            default: throw LearningSessionError.invalidPhase
            }
            try commit(next)
        } catch { show(error) }
    }

    func submitGuidedPractice(_ response: String, hintUsed: Bool) {
        do {
            guard var next = session, next.currentPhase == .guidedPractice,
                  next.practiceStepIndex < intervention.practiceSteps.count else { throw LearningSessionError.invalidPhase }
            let step = intervention.practiceSteps[next.practiceStepIndex]
            let correct = try learningValidator.checkNumber(response, expected: step.expectedValue)
            next.learningAttempts.append(makeLearningAttempt(step.id, response: response, correct: correct, phase: .guidedPractice, hintUsed: hintUsed))
            if correct {
                next.practiceStepIndex += 1
                feedbackMessage = nil
                if next.practiceStepIndex == intervention.practiceSteps.count {
                    markCompleted("practice", in: &next)
                    next.currentPhase = .validationIntro
                    feedbackMessage = nil
                }
            } else {
                feedbackMessage = step.incorrectFeedback
            }
            try commit(next)
        } catch { showLearningError(error) }
    }

    func beginIndependentValidation() {
        do {
            guard var next = session, next.currentPhase == .validationIntro else { throw LearningSessionError.invalidPhase }
            next.currentPhase = .independentRetry
            try commit(next)
        } catch { show(error) }
    }

    func submitIndependentRetry(_ response: String) {
        do {
            guard var next = session, next.currentPhase == .independentRetry else { throw LearningSessionError.invalidPhase }
            let question = currentRetryQuestion
            let correct = try learningValidator.checkNumber(response, expected: question.expectedValue)
            next.learningAttempts.append(makeLearningAttempt(question.id, response: response, correct: correct, phase: .independentRetry, hintUsed: false))
            if let status = validationPolicy.afterIndependentRetry(isCorrect: correct) {
                next.learningStatus = status
                next.currentPhase = .learningResult
            } else {
                next.learningStatus = nil
                next.currentPhase = .transferProblem
            }
            try commit(next)
        } catch { showLearningError(error) }
    }

    func submitTransfer(_ response: String) {
        do {
            guard var next = session, next.currentPhase == .transferProblem else { throw LearningSessionError.invalidPhase }
            let question = intervention.transferQuestion
            let correct = try learningValidator.checkLinearExpression(
                response, coefficient: question.expectedCoefficient, constant: question.expectedConstant
            )
            next.learningAttempts.append(makeLearningAttempt(question.id, response: response, correct: correct, phase: .transferProblem, hintUsed: false))
            next.learningStatus = validationPolicy.afterTransfer(isCorrect: correct)
            next.currentPhase = .learningResult
            try commit(next)
        } catch { showLearningError(error) }
    }

    func repeatLearning() {
        do {
            guard var next = session, next.currentPhase == .learningResult,
                  next.learningStatus == .needsReinforcement,
                  next.reinforcementCount < 1 else { throw LearningSessionError.invalidPhase }
            next.reinforcementCount += 1
            next.retryQuestionIndex = min(next.reinforcementCount, intervention.retryQuestions.count - 1)
            resetLearningProgress(&next)
            try commit(next)
        } catch { show(error) }
    }

    func reviewConcept() {
        do {
            guard var next = session, next.currentPhase == .learningResult,
                  next.learningStatus == .proceduralOnly else { throw LearningSessionError.invalidPhase }
            next.learningMode = .optionalReview
            next.retryQuestionIndex = min(1, intervention.retryQuestions.count - 1)
            resetLearningProgress(&next)
            try commit(next)
        } catch { show(error) }
    }

    func restartInterventionForUpdatedContent() {
        do {
            guard var next = session, next.currentPhase.isLearningPhase,
                  intervention.conceptID == content.blockerID else { throw LearningSessionError.invalidPhase }
            next.interventionPackageID = intervention.id
            next.learningContentVersion = intervention.version
            resetLearningProgress(&next)
            try commit(next)
        } catch { show(error) }
    }

    func actionTitle(for topicID: String) -> String {
        guard let session, session.topicID == topicID else { return "Mulai Pemeriksaan" }
        if session.currentPhase == .diagnosisResult { return "Lihat Hasil Pemeriksaan" }
        if session.currentPhase == .learningResult { return "Lihat Hasil Belajar" }
        return session.currentPhase.isLearningPhase ? "Lanjutkan Belajar" : "Lanjutkan Pemeriksaan"
    }

    func resultPresentation(for status: DiagnosticStatus?) -> DiagnosisResultPresentation {
        switch status {
        case .confirmed:
            return DiagnosisResultPresentation(
                title: "Ada konsep yang perlu diperkuat",
                explanation: "Dua responsmu konsisten dengan kesulitan pada Sifat Distributif dalam pemeriksaan draf ini.",
                nextStep: "Langkah berikutnya: pelajari Sifat Distributif melalui penjelasan visual, contoh, dan latihan terbimbing."
            )
        case .rejected:
            return DiagnosisResultPresentation(
                title: "Dugaan awal tidak terkonfirmasi",
                explanation: "Jawaban tambahan tidak mendukung dugaan awal. Ini belum berarti seluruh konsep sudah dikuasai.",
                nextStep: "Kamu dapat meninjau Sifat Distributif secara opsional."
            )
        case .uncertain:
            return DiagnosisResultPresentation(
                title: "Belum cukup bukti untuk menyimpulkan",
                explanation: "Respons yang terkumpul belum cukup untuk memastikan konsep yang menghambat.",
                nextStep: "Kamu dapat meninjau Sifat Distributif secara opsional."
            )
        case .allCorrect:
            return DiagnosisResultPresentation(
                title: "Jawabanmu tepat pada pemeriksaan ini",
                explanation: "Tidak ditemukan hambatan pada soal yang diperiksa. Kamu tidak perlu otomatis masuk ke latihan perbaikan.",
                nextStep: nil
            )
        case .none:
            return DiagnosisResultPresentation(title: "Hasil belum tersedia", explanation: "", nextStep: nil)
        }
    }

    private func makeAttempt(_ question: DiagnosticQuestion, optionID: String, evaluation: AnswerEvaluation, phase: LearningPhase, reasoning: String?) -> QuestionAttempt {
        QuestionAttempt(
            id: UUID(), questionID: question.id, responseOptionID: optionID,
            isCorrect: evaluation.isCorrect, matchedErrorPatternID: evaluation.matchedErrorPatternID,
            probeSignal: evaluation.probeSignal, phase: phase, submittedAt: Date(),
            reasoning: reasoning?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? reasoning : nil
        )
    }

    private func makeLearningAttempt(_ questionID: String, response: String, correct: Bool, phase: LearningPhase, hintUsed: Bool) -> LearningAttempt {
        LearningAttempt(id: UUID(), questionID: questionID, response: response, isCorrect: correct, phase: phase, hintUsed: hintUsed, submittedAt: Date())
    }

    private func markCompleted(_ id: String, in session: inout LearningSession) {
        if !session.completedStepIDs.contains(id) { session.completedStepIDs.append(id) }
    }

    private func resetLearningProgress(_ session: inout LearningSession) {
        session.currentPhase = .visualExplanation
        session.visualRevealed = false
        session.workedStepCount = 0
        session.practiceStepIndex = 0
        session.completedStepIDs.removeAll()
        feedbackMessage = nil
    }

    private func commit(_ next: LearningSession) throws {
        var next = next
        next.updatedAt = Date()
        try repository.save(next)
        session = next
        errorMessage = nil
    }

    private func show(_ error: Error) {
        errorMessage = (error as? LocalizedError)?.errorDescription ?? "Jawaban belum dapat disimpan. Coba lagi."
    }

    private func showLearningError(_ error: Error) {
        if error is LearningAnswerError {
            errorMessage = "Format jawaban belum sesuai. Gunakan bilangan bulat atau ekspresi seperti 3x+12 sesuai instruksi."
        } else {
            show(error)
        }
    }
}
