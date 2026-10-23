import Foundation

struct ChatMessage: Identifiable, Codable {
    var id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatThread: Identifiable, Codable {
    var id: UUID
    var messages: [ChatMessage]
    var updatedAt: Date

    var title: String { messages.first(where: { $0.isUser })?.text ?? "Percakapan baru" }
}
