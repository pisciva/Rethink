import Combine

enum AppTab: Hashable {
    case home
    case explore
    case map
    case profile
}

@MainActor
final class AppNavigationViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
}
