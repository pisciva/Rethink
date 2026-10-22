import Foundation

/// Draft onboarding examples: self-reported familiarity, never diagnostic evidence.
struct OnboardingQuickCheckItem: Identifiable {
    let id: Int
    let prompt: String
    let expression: String
    let latex: String

    // Progression: expand → combine terms → both sides → fractions → a two-variable system.
    static let examples: [Self] = [
        .init(id: 0, prompt: "Bisa mengalikan bentuk ini?", expression: "2(x + 4)", latex: "2(x+4)"),
        .init(id: 1, prompt: "Bisa menyederhanakan bentuk ini?", expression: "3(x + 2) − 2x", latex: "3(x+2)-2x"),
        .init(id: 2, prompt: "Bisa mencari nilai x?", expression: "2(x + 3) = 3x − 1", latex: "2(x+3)=3x-1"),
        .init(id: 3, prompt: "Bisa mencari nilai x?", expression: "3(x − 2)/4 − (x + 1)/2 = 2", latex: "\\frac{3(x-2)}{4}-\\frac{x+1}{2}=2"),
        .init(id: 4, prompt: "Bisa mencari nilai x dan y?", expression: "3(x − 2)/4 − (y + 1)/2 = 2\n2x + 3y = 28", latex: "\\frac{3(x-2)}{4}-\\frac{y+1}{2}=2\n2x+3y=28"),
    ]
}

enum OnboardingFamiliarity: String, CaseIterable, Identifiable {
    case notYet, unsure, familiar
    var id: String { rawValue }
    var title: String {
        switch self {
        case .notYet: "Belum"
        case .unsure: "Ragu"
        case .familiar: "Bisa"
        }
    }
    var symbol: String {
        switch self {
        case .notYet: "xmark"
        case .unsure: "minus"
        case .familiar: "checkmark"
        }
    }
}
