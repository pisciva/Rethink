import SwiftUI

struct ContentView: View {
    @State private var isShowingOnboarding = OnboardingPreferenceStore().shouldPresent(
        replay: AppConfig.replaysOnboardingForTesting,
        preview: AppConfig.onboardingPreviewPage != nil,
        developmentBypass: AppConfig.opensHomeForDevelopment
    )
    @State private var isShowingChat = false
    @State private var previousTab: AppTab = .home
    @StateObject private var auth = AuthStore()
    @StateObject private var catalog = CatalogStore()
    @StateObject private var journey = JourneyStore()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var navigation = AppNavigationViewModel()

    var body: some View {
        Group {
            if isShowingOnboarding {
                OnboardingView(initialPage: AppConfig.onboardingPreviewPage ?? (AppConfig.replaysOnboardingForTesting ? 0 : nil), onStartSession: {
                    navigation.selectedTab = .explore
                    isShowingOnboarding = false
                    Task { await homeViewModel.reload() }
                }) {
                    isShowingOnboarding = false
                    Task { await homeViewModel.reload() }
                }
            } else if auth.isRestoring {
                VStack(spacing: 20) {
                    BrandIllustration(name: "asset 13", size: 100, tilt: 8)
                    Text("Sebentar, kita siapkan\nruang berpikirmu.")
                        .brandHeading(26)
                        .multilineTextAlignment(.center)
                    ProgressView().tint(HomeStyle.blue)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(HomeStyle.background.ignoresSafeArea())
            } else if !auth.isAuthenticated {
                GuestSessionView()
            } else {
                tabs
            }
        }
        .environmentObject(auth)
        .environmentObject(catalog)
        .environmentObject(journey)
        .environmentObject(navigation)
        .preferredColorScheme(.light)
        .task {
            await auth.restore()
            if !auth.isAuthenticated {
                await auth.ensureSession()
            }
            await catalog.load()
            await homeViewModel.loadIfNeeded()
            if auth.isAuthenticated {
                await journey.load(auth: auth)
            }
        }
        .onChange(of: auth.session?.userId) { _, userId in
            // Clear on every identity change, including one non-nil user to another.
            journey.clear()
            if userId != nil {
                Task { await journey.load(auth: auth) }
            }
        }
    }

    private var chatTabRole: TabRole {
        // Use the role supported by the deployment SDK as well as newer iOS.
        // Availability checks alone cannot compile an API absent from that SDK.
        return .search
    }

    private var tabs: some View {
        TabView(selection: $navigation.selectedTab) {
            Tab(value: AppTab.home) {
                NavigationStack {
                    HomeView(
                        viewModel: homeViewModel,
                        openExplore: { navigation.selectedTab = .explore },
                        openMap: { navigation.selectedTab = .map }
                    )
                }
            } label: {
                Label("Beranda", systemImage: navigation.selectedTab == .home ? "house.fill" : "house")
                    .environment(\.symbolVariants, .none)
            }

            Tab(value: AppTab.explore) {
                NavigationStack {
                    GradeCatalogView()
                }
                .id(navigation.catalogNavigationID)
            } label: {
                Label("Jelajahi", systemImage: navigation.selectedTab == .explore ? "square.grid.2x2.fill" : "square.grid.2x2")
                    .environment(\.symbolVariants, .none)
            }

            Tab(value: AppTab.map) {
                NavigationStack { LearningMapView() }
            } label: {
                Label("Peta", systemImage: navigation.selectedTab == .map ? "map.fill" : "map")
                    .environment(\.symbolVariants, .none)
            }

            // Keep chat in the system-provided detached tab slot.
            Tab(value: AppTab.chat, role: chatTabRole) {
                Color.clear
            } label: {
                Label("Chatbot", systemImage: "bubble.left.and.bubble.right")
                    .environment(\.symbolVariants, .none)
            }
        }
        .tint(HomeStyle.ink)
        .onChange(of: navigation.selectedTab) { _, tab in
            if tab == .chat {
                navigation.selectedTab = previousTab
                isShowingChat = true
            } else {
                previousTab = tab
            }
        }
        .fullScreenCover(isPresented: $isShowingChat) {
            NavigationStack { ChatView() }
        }
    }

}

#Preview {
    ContentView()
}
