import Foundation

protocol HomeContentSource {
    func loadHome() async throws -> HomeSnapshot
}

struct CuratedHomeContentSource: HomeContentSource {
    func loadHome() async throws -> HomeSnapshot {
        let linearSystems = TopicSummary(
            id: "spl",
            title: "Sistem Persamaan Linear",
            description: "Kenali konsep yang mendukung penyelesaian sistem persamaan linear lewat pemeriksaan singkat.",
            illustrationName: "asset 33",
            availability: .available
        )

        let name = OnboardingPreferenceStore().learnerName.trimmingCharacters(in: .whitespacesAndNewlines)

        return HomeSnapshot(
            displayName: name.isEmpty ? nil : name,
            subjects: [
                SubjectSummary(id: "algebra", title: "Aljabar", illustrationName: "asset 21",
                               availability: .available, topics: [linearSystems]),
                SubjectSummary(id: "geometry", title: "Geometri", illustrationName: "asset 20",
                               availability: .unavailable, topics: []),
                SubjectSummary(id: "trigonometry", title: "Trigonometri", illustrationName: "asset 37",
                               availability: .unavailable, topics: []),
                SubjectSummary(id: "calculus", title: "Kalkulus", illustrationName: "asset 15",
                               availability: .unavailable, topics: [])
            ],
            featuredTopic: linearSystems,
            recentActivity: nil
        )
    }
}
