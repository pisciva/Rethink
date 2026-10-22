import Combine
import Foundation

@MainActor
final class LearningHistoryViewModel: ObservableObject {
    @Published private(set) var sessions: [LearningSession] = []
    @Published private(set) var errorMessage: String?
    private let repository: LearningSessionRepository

    init(repository: LearningSessionRepository? = nil) {
        self.repository = repository ?? FileLearningSessionRepository()
    }

    func reload() {
        do {
            sessions = try repository.loadHistory().sorted { $0.updatedAt > $1.updatedAt }
            errorMessage = nil
        } catch {
            errorMessage = "Riwayat sesi belum dapat dibaca."
        }
    }
}
