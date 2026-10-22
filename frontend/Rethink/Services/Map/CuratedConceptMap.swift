import Foundation

enum CuratedConceptMap {
    static let concepts: [CuratedConcept] = [
        CuratedConcept(id: "arithmetic-foundations", title: "Fondasi Aritmetika", prerequisiteIDs: []),
        CuratedConcept(id: "distributive-property", title: "Sifat Distributif", prerequisiteIDs: ["arithmetic-foundations"]),
        CuratedConcept(id: "inverse-operations", title: "Operasi Invers", prerequisiteIDs: ["arithmetic-foundations"]),
        CuratedConcept(id: "linear-systems", title: "Sistem Persamaan Linear", prerequisiteIDs: ["distributive-property", "inverse-operations"])
    ]
}
