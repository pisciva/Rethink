import Combine
import Foundation

enum AppTab: Hashable {
    case home
    case explore
    case chat
    case map
}

@MainActor
final class AppNavigationViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published private(set) var catalogNavigationID = UUID()

    func showCatalog() {
        // Reset navigation only; the owner-scoped recovery evidence is untouched.
        catalogNavigationID = UUID()
        selectedTab = .explore
    }
}
