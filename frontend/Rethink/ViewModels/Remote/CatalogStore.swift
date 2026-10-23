import Combine
import Foundation

@MainActor
final class CatalogStore: ObservableObject {
    @Published private(set) var catalog: RemoteCatalog?
    @Published private(set) var subjects: [SubjectSummary] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let client: APIClient

    init(client: APIClient? = nil) {
        self.client = client ?? APIClient()
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let remote = try await client.catalog()
            catalog = remote
            if let mathematics = remote.disciplines?.first(where: { $0.id == "mathematics" }), !mathematics.materials.isEmpty {
                subjects = mathematics.materials.map { material in
                    let legacy = remote.subjects.first { $0.id == material.id }
                    let topics = legacy.map { mapSubject($0).topics } ?? []
                    return SubjectSummary(
                        id: material.id, title: material.title,
                        illustrationName: illustrationName(for: material.id),
                        availability: topics.contains { $0.availability == .available } ? .available : .unavailable,
                        topics: topics, subtopics: curriculum(for: material.id, nodes: material.subtopics, legacy: legacy)
                    )
                }
            } else {
                subjects = remote.subjects.map(mapSubject)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func mapSubject(_ subject: RemoteSubject) -> SubjectSummary {
        SubjectSummary(
            id: subject.id,
            title: subject.title,
            illustrationName: illustrationName(for: subject.id),
            availability: subject.topics.contains { topicAvailability($0) == .available } ? .available : .unavailable,
            topics: subject.topics.map { topic in
                TopicSummary(
                    id: topic.id,
                    title: topic.title,
                    description: description(for: topic.id),
                    illustrationName: topicIllustrationName(for: topic.id),
                    availability: topicAvailability(topic)
                )
            },
            subtopics: curriculum(for: subject.id, nodes: subject.subtopics ?? [], legacy: subject)
        )
    }

    private func curriculum(for id: String, nodes: [RemoteCurriculumNode], legacy: RemoteSubject?) -> [TopicSummary] {
        if !nodes.isEmpty { return nodes.map(mapCurriculumNode) }
        // Subject/topic APIs do not imply an additional local curriculum tree.
        // Empty subtopics intentionally use the direct topic list in the view.
        return []
    }

    private func mapCurriculumNode(_ node: RemoteCurriculumNode) -> TopicSummary {
        // Only the existing SPL entry can start a diagnostic session.
        let supportsDiagnosis = node.id == "spl" && node.availability == "active"
            && node.capabilities?.diagnosis == "active"
        let supportsReview = node.id == "distribution" && node.availability == "active-recovery"
            && node.capabilities?.guidedLearning == "active" && node.entryTopicId == "spl"
        return TopicSummary(
            id: node.id, title: node.title,
            description: supportsDiagnosis ? description(for: node.id)
                : supportsReview ? "Konsep ini dapat ditinjau melalui alur Sistem Persamaan Linear."
                : "Materi ini sudah ada di peta kurikulum, tetapi belum tersedia untuk belajar atau pemeriksaan konsep.",
            illustrationName: CatalogIllustrations.name(for: node.id),
            availability: supportsDiagnosis ? .available : supportsReview ? .preview : .unavailable,
            subtopics: (node.subtopics ?? []).map(mapCurriculumNode),
            entryTopicID: supportsDiagnosis || supportsReview ? "spl" : nil
        )
    }

    private func topicAvailability(_ topic: RemoteTopic) -> SubjectAvailability {
        guard topic.id == "spl", topic.availability == "active", topic.capabilities?.diagnosis == "active" else {
            return .unavailable
        }
        return .available
    }

    private func illustrationName(for subjectID: String) -> String {
        switch subjectID {
        case "algebra": return "asset 21"
        case "geometry": return "asset 20"
        case "trigonometry": return "asset 37"
        case "calculus": return "asset 15"
        default: return "asset 21"
        }
    }

    private func topicIllustrationName(for topicID: String) -> String {
        topicID == "spl" ? "asset 33" : "asset 33"
    }

    private func description(for topicID: String) -> String {
        topicID == "spl"
            ? "Kenali konsep yang mendukung penyelesaian sistem persamaan linear lewat pemeriksaan singkat."
            : "Topik ini belum memiliki paket pemeriksaan konsep yang aktif."
    }
}
