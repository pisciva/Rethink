import Foundation

/// Bundled navigation metadata. Backend capability flags remain authoritative.
enum CatalogCurriculum {
    static var algebraSubject: SubjectSummary {
        SubjectSummary(id: "algebra", title: "Aljabar", illustrationName: "asset 21",
                       availability: .unavailable, topics: [], subtopics: algebra)
    }

    static let algebra: [TopicSummary] = [
        branch("algebra-foundations", "Fondasi Aljabar", [
            ("variables-expressions", "Variabel & ekspresi"),
            ("inverse", "Operasi invers"),
            ("distribution", "Sifat distributif"),
            ("like-terms", "Suku sejenis"),
        ]),
        branch("linear-equations", "Persamaan Linear", [
            ("one-variable-equations", "Persamaan satu variabel"),
            ("inequalities", "Pertidaksamaan"),
            ("graphs-slopes", "Grafik & gradien"),
            ("spl", "Sistem persamaan (SPL)"),
        ]),
        branch("functions-relations", "Fungsi & Relasi", [
            ("domain-range", "Domain & range"),
            ("linear-functions", "Fungsi linear"),
            ("function-transformations", "Transformasi fungsi"),
            ("modeling", "Pemodelan"),
        ]),
        branch("polynomials-quadratics", "Polinomial & Kuadrat", [
            ("polynomial-multiplication", "Perkalian polinomial"),
            ("factorization", "Faktorisasi"),
            ("quadratics", "Persamaan kuadrat"),
            ("quadratic-functions", "Fungsi kuadrat"),
        ]),
        branch("exponents-rational", "Eksponen & Rasional", [
            ("powers-roots", "Pangkat dan akar"),
            ("rational-expressions", "Ekspresi rasional"),
            ("exponential-functions", "Fungsi eksponensial"),
            ("logarithms", "Logaritma"),
        ]),
        branch("advanced-algebra", "Aljabar Lanjutan", [
            ("complex-numbers", "Bilangan kompleks"),
            ("matrices", "Matriks"),
            ("vectors", "Vektor"),
            ("sequences-series", "Barisan & deret"),
        ]),
    ]

    private static func branch(_ id: String, _ title: String, _ leaves: [(String, String)]) -> TopicSummary {
        TopicSummary(
            id: id, title: title, description: "",
            illustrationName: CatalogIllustrations.name(for: id), availability: .unavailable,
            subtopics: leaves.map { id, title in
                TopicSummary(
                    id: id, title: title,
                    description: "Materi ini sudah ada di peta kurikulum, tetapi belum tersedia untuk belajar atau pemeriksaan konsep.",
                    illustrationName: CatalogIllustrations.name(for: id), availability: .unavailable
                )
            }
        )
    }
}
