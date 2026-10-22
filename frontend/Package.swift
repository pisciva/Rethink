// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ReThinkDiagnosis",
    platforms: [.macOS(.v13)],
    products: [.library(name: "DiagnosisCore", targets: ["DiagnosisCore"])],
    targets: [
        .target(
            name: "DiagnosisCore",
            path: "Rethink",
            exclude: [
                "Tests", "Config",
                "App/RethinkApp.swift", "Assets.xcassets", "Components", "Views", "Reference",
                "DESIGN.md",
                "Models/Home/HomeSnapshot.swift",
                "Models/EmptyState", "Resources",
                "Services/Home/CuratedHomeContentSource.swift", "ViewModels/Home/HomeViewModel.swift",
                "ViewModels/App/AppNavigationViewModel.swift"
            ],
            sources: [
                "Models/Onboarding/OnboardingPage.swift", "Models/Onboarding/OnboardingQuickCheck.swift", "ViewModels/Onboarding/OnboardingViewModel.swift", "ViewModels/Onboarding/OnboardingChatPreviewViewModel.swift",
                "Services/Onboarding/OnboardingPreferenceStore.swift", "Services/Onboarding/OnboardingAudioController.swift",
                "App/AppConfig.swift", "Models/Catalog/CatalogModels.swift", "Models/Catalog/CatalogCurriculum.swift",
                "Models/Remote/RemoteModels.swift",
                "Models/Diagnosis/DiagnosticContentModels.swift", "Models/Learning/LearningSession.swift",
                "Models/Learning/InterventionPackage.swift",
                "Models/Map/ConceptMapModels.swift", "Models/AI/AIServiceContracts.swift",
                "Services/Remote/APIClient.swift", "Services/Remote/KeychainTokenStore.swift",
                "Services/Remote/SupabaseAuthClient.swift",
                "Services/Diagnosis/DiagnosisPolicy.swift",
                "Services/Diagnosis/DiagnosticContent.swift", "Services/Learning/SessionRepository.swift",
                "Services/Diagnosis/CuratedChoiceValidator.swift", "Services/Learning/InterventionContent.swift",
                "Services/Learning/LocalLearningValidator.swift", "Services/Learning/LearningValidationPolicy.swift",
                "Services/Map/CuratedConceptMap.swift", "Services/AI/AIServiceInterfaces.swift",
                "ViewModels/Remote/AuthStore.swift", "ViewModels/Remote/CatalogStore.swift",
                "ViewModels/Remote/JourneyStore.swift",
                "ViewModels/Diagnosis/DiagnosisViewModel.swift",
                "ViewModels/Map/LearningMapViewModel.swift", "ViewModels/History/LearningHistoryViewModel.swift"
            ]
        ),
        .testTarget(name: "DiagnosisCoreTests", dependencies: ["DiagnosisCore"], path: "Rethink/Tests/DiagnosisCoreTests")
    ]
)
