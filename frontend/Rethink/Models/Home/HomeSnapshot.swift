import Foundation

struct LearningActivitySummary {
    let conceptTitle: String
    let statusTitle: String
    let explanation: String
}

struct HomeSnapshot {
    let displayName: String?
    let subjects: [SubjectSummary]
    let featuredTopic: TopicSummary?
    let recentActivity: LearningActivitySummary?
}
