import Foundation

enum DiagnosticContent {
    /// Prototype fixture. Wording and rubric require review by the mathematics team.
    static let draftSPL = DiagnosticContentPack(
        version: "draft-spl-v0.1",
        reviewStatus: .draft,
        topicID: "linear-systems",
        blockerID: "distributive-property",
        blockerTitle: "Sifat Distributif",
        knownErrorPatternID: "partial_distribution",
        preTest: DiagnosticQuestion(
            id: "spl-pretest-1",
            prompt: "Perhatikan sistem persamaan berikut. Jika persamaan pertama disederhanakan, bentuk mana yang setara?",
            context: "3(x + 2) + y = 15\nx + y = 5",
            instruction: "Pilih satu bentuk untuk persamaan pertama.",
            options: [
                DiagnosticOption(id: "a", text: "3x + 6 + y = 15", isCorrect: true, errorPatternID: nil, probeSignal: nil),
                DiagnosticOption(id: "b", text: "3x + 2 + y = 15", isCorrect: false, errorPatternID: "partial_distribution", probeSignal: nil),
                DiagnosticOption(id: "c", text: "3x + 5 + y = 15", isCorrect: false, errorPatternID: nil, probeSignal: nil)
            ]
        ),
        conceptualProbe: DiagnosticQuestion(
            id: "distributive-probe-1",
            prompt: "Apa makna 3(x + 2)?",
            context: nil,
            instruction: "Pilih pernyataan yang paling sesuai dengan pemahamanmu.",
            options: [
                DiagnosticOption(id: "a", text: "Tiga kelompok, masing-masing berisi x dan 2.", isCorrect: true, errorPatternID: nil, probeSignal: .contradictsBlocker),
                DiagnosticOption(id: "b", text: "Tiga x, lalu ditambah satu kelompok 2.", isCorrect: false, errorPatternID: "partial_distribution", probeSignal: .supportsBlocker),
                DiagnosticOption(id: "c", text: "Aku belum yakin.", isCorrect: false, errorPatternID: nil, probeSignal: .ambiguous)
            ]
        )
    )
}
