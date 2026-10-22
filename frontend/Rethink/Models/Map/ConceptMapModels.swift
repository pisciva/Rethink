import Foundation

struct ConceptMapNode: Identifiable {
    let id: String
    let title: String
    let prerequisiteIDs: [String]
    let learnerStatus: LearningStatus?
}

struct CuratedConcept {
    let id: String
    let title: String
    let prerequisiteIDs: [String]
}
