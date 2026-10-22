import Foundation

protocol LearningSessionRepository {
    func load() throws -> LearningSession?
    func loadHistory() throws -> [LearningSession]
    func save(_ session: LearningSession) throws
}

extension LearningSessionRepository {
    func loadHistory() throws -> [LearningSession] {
        try load().map { [$0] } ?? []
    }
}

struct FileLearningSessionRepository: LearningSessionRepository {
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ReThink", isDirectory: true)
        fileURL = directory.appendingPathComponent("learning-session.json")
    }

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    func load() throws -> LearningSession? {
        try loadHistory().first
    }

    func loadHistory() throws -> [LearningSession] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        if let sessions = try? decoder.decode([LearningSession].self, from: data) {
            return sessions.sorted { $0.updatedAt > $1.updatedAt }
        }
        // Migrate the previous single-session JSON without discarding its evidence.
        return [try decoder.decode(LearningSession.self, from: data)]
    }

    func save(_ session: LearningSession) throws {
        var sessions = try loadHistory()
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(sessions)
        try data.write(to: fileURL, options: .atomic)
    }
}
