import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var draft = ""
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var isResponding = false
    @Published private(set) var history: [ChatThread] = []
    private var threadID = UUID()
    private let historyKey = "rethink.chat.demoHistory"
    private var responseTask: Task<Void, Never>?

    init() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let saved = try? JSONDecoder().decode([ChatThread].self, from: data) {
            history = saved
        }
        // Stable IDs keep preview examples from duplicating across launches.
        let examples: [(String, String, String)] = [
            ("00000000-0000-0000-0000-000000000101", "Memahami Sifat Distributif", "Pada 3(x + 2), pengali 3 berlaku untuk setiap suku: 3 × x + 3 × 2 = 3x + 6."),
            ("00000000-0000-0000-0000-000000000102", "Cara menyelesaikan SPLDV", "Kita bisa mulai dari x + y = 7 dan x − y = 1. Jumlahkan keduanya: 2x = 8, sehingga x = 4. Substitusikan kembali untuk mendapatkan y = 3."),
            ("00000000-0000-0000-0000-000000000103", "Perbedaan eliminasi dan substitusi", "Eliminasi menghilangkan satu variabel dengan menggabungkan persamaan. Substitusi mengganti variabel dengan ekspresi yang setara dari persamaan lain.")
        ]
        for (index, example) in examples.enumerated() {
            guard let id = UUID(uuidString: example.0), !history.contains(where: { $0.id == id }) else { continue }
            history.append(ChatThread(id: id, messages: [
                ChatMessage(text: example.1, isUser: true),
                ChatMessage(text: example.2, isUser: false)
            ], updatedAt: Date().addingTimeInterval(-Double(index + 1) * 86400)))
        }
    }

    private func saveThread() {
        guard !messages.isEmpty else { return }
        history.removeAll { $0.id == threadID }
        history.insert(ChatThread(id: threadID, messages: messages, updatedAt: Date()), at: 0)
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    func open(_ thread: ChatThread) {
        stop()
        threadID = thread.id
        messages = thread.messages
        draft = ""
    }

    var canSend: Bool { !isResponding && !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    func send() {
        guard canSend else { return }
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        messages.append(ChatMessage(text: text, isUser: true))
        draft = ""
        saveThread()
        isResponding = true
        // Cancellable UI simulation only; no AI or learning-state mutation.
        responseTask = Task { [weak self] in
            do { try await Task.sleep(for: .seconds(2)) } catch { return }
            guard !Task.isCancelled, let self else { return }
            self.messages.append(ChatMessage(text: "Ini contoh balasan Jimmy untuk preview tampilan. Chat belum terhubung ke AI. Nantinya kita bisa membahas langkah yang membuatmu bingung bersama-sama.", isUser: false))
            self.saveThread()
            self.isResponding = false
            self.responseTask = nil
        }
    }

    func stop() {
        responseTask?.cancel()
        responseTask = nil
        isResponding = false
    }

    func reset() {
        stop()
        threadID = UUID()
        messages = []
        draft = ""
    }
}
