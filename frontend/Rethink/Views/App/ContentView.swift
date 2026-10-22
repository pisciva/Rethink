import SwiftUI

struct ContentView: View {
    // Product-owner development preference: open Home, even before onboarding completion.
    @State private var isShowingOnboarding = AppConfig.replaysOnboardingForTesting || AppConfig.onboardingPreviewPage != nil
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
                    .background(HomeStyle.sky.ignoresSafeArea())
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
            if userId == nil {
                journey.clear()
            } else {
                Task { await journey.load(auth: auth) }
            }
        }
    }

    private var tabs: some View {
        TabView(selection: $navigation.selectedTab) {
            NavigationStack {
                HomeView(
                    viewModel: homeViewModel,
                    openExplore: { navigation.selectedTab = .explore },
                    openMap: { navigation.selectedTab = .map },
                    openProfile: { navigation.selectedTab = .profile }
                )
            }
            .tabItem {
                Label("Beranda", systemImage: navigation.selectedTab == .home ? "house.fill" : "house")
                    .environment(\.symbolVariants, .none)
            }
            .tag(AppTab.home)

            NavigationStack {
                MathematicsCatalogView(
                    subjects: catalog.subjects,
                    isLoading: catalog.isLoading,
                    errorMessage: catalog.errorMessage,
                    onRetry: { Task { await catalog.load() } }
                )
            }
            .tabItem {
                Label("Jelajahi", systemImage: navigation.selectedTab == .explore ? "square.grid.2x2.fill" : "square.grid.2x2")
                    .environment(\.symbolVariants, .none)
            }
            .tag(AppTab.explore)

            NavigationStack {
                LearningMapView()
            }
            .tabItem {
                Label("Peta", systemImage: navigation.selectedTab == .map ? "map.fill" : "map")
                    .environment(\.symbolVariants, .none)
            }
            .tag(AppTab.map)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profil", systemImage: navigation.selectedTab == .profile ? "person.crop.circle.fill" : "person.crop.circle")
                    .environment(\.symbolVariants, .none)
            }
            .tag(AppTab.profile)
        }
        .tint(HomeStyle.ink)
    }
}

#Preview {
    ContentView()
}
