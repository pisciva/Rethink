import Foundation

enum SubjectAvailability: Equatable {
    case available
    case preview
    case unavailable
}

struct TopicSummary: Identifiable {
    let id: String
    let title: String
    let description: String
    let illustrationName: String
    var availability: SubjectAvailability = .available
    var subtopics: [TopicSummary] = []
    var entryTopicID: String? = nil
}

struct SubjectSummary: Identifiable {
    let id: String
    let title: String
    let illustrationName: String
    let availability: SubjectAvailability
    let topics: [TopicSummary]
    var subtopics: [TopicSummary] = []
}

/// Asset names are presentation metadata, not support or prerequisite declarations.
enum CatalogIllustrations {
    static func name(for id: String) -> String {
        switch id {
        case "algebra-foundations": "FondasiAljabar"
        case "linear-equations", "spl": "asset 33"
        case "functions-relations", "linear-functions", "function-transformations", "modeling": "asset 37"
        case "polynomials-quadratics", "quadratics", "quadratic-functions", "factorization": "asset 21"
        case "exponents-rational", "powers-roots", "exponential-functions", "logarithms": "asset 15"
        case "advanced-algebra", "matrices", "vectors", "complex-numbers": "asset 20"
        case "distribution", "variables-expressions", "like-terms", "inverse": "FondasiAljabar"
        default: "asset 21"
        }
    }
}
