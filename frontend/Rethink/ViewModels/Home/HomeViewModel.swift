import Combine
import Foundation

extension SubjectAvailability {
    var label: String {
        switch self {
        case .available: "Materi tersedia"
        case .preview: "Pratinjau"
        case .unavailable: "Belum tersedia"
        }
    }
}

enum HomeViewState {
    case idle
    case loading
    case loaded(HomeSnapshot)
    case failed(String)
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var state: HomeViewState = .idle

    var snapshot: HomeSnapshot? {
        if case .loaded(let snapshot) = state { return snapshot }
        return nil
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    var errorMessage: String? {
        if case .failed(let message) = state { return message }
        return nil
    }

    private let source: HomeContentSource

    init() {
        self.source = CuratedHomeContentSource()
    }

    init(source: HomeContentSource) {
        self.source = source
    }

    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await reload()
    }

    func reload() async {
        state = .loading

        do {
            state = .loaded(try await source.loadHome())
        } catch {
            state = .failed("Konten belajar belum dapat dimuat. Coba lagi.")
        }
    }
}
