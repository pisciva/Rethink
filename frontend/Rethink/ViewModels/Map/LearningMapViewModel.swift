import Combine
import Foundation

@MainActor
final class LearningMapViewModel: ObservableObject {
    @Published private(set) var nodes: [ConceptMapNode] = []
    @Published private(set) var latestDiagnosticStatus: DiagnosticStatus?
    @Published private(set) var errorMessage: String?

    private let repository: LearningSessionRepository

    init(repository: LearningSessionRepository? = nil) {
        self.repository = repository ?? FileLearningSessionRepository()
    }

    func reload() {
        do {
            let sessions = try repository.loadHistory().sorted { $0.updatedAt > $1.updatedAt }
            latestDiagnosticStatus = sessions.first(where: { $0.diagnosticStatus != nil })?.diagnosticStatus
            let assessed = sessions.first(where: hasValidationEvidence)
            nodes = CuratedConceptMap.concepts.map { concept in
                ConceptMapNode(
                    id: concept.id,
                    title: concept.title,
                    prerequisiteIDs: concept.prerequisiteIDs,
                    learnerStatus: concept.id == "distributive-property" ? assessed?.learningStatus : nil
                )
            }
            errorMessage = nil
        } catch {
            errorMessage = "Peta belajar belum dapat memuat sesi tersimpan."
        }
    }

    private func hasValidationEvidence(_ session: LearningSession) -> Bool {
        guard session.interventionPackageID == InterventionContent.draftDistributive.id,
              let status = session.learningStatus,
              let final = session.learningAttempts.last(where: {
                  $0.phase == .independentRetry || $0.phase == .transferProblem
              }) else { return false }

        switch status {
        case .needsReinforcement:
            return final.phase == .independentRetry && !final.isCorrect && !final.hintUsed
        case .understood, .proceduralOnly:
            guard final.phase == .transferProblem, !final.hintUsed,
                  final.isCorrect == (status == .understood),
                  let transferIndex = session.learningAttempts.lastIndex(where: { $0.id == final.id }) else { return false }
            return session.learningAttempts[..<transferIndex].last(where: { $0.phase == .independentRetry })?.isCorrect == true
        }
    }
}
