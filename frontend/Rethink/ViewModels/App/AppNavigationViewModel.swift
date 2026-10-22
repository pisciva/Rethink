import Combine

enum AppTab: Hashable {
    case home
    case explore
    case chat
    case map
}

@MainActor
final class AppNavigationViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
}
