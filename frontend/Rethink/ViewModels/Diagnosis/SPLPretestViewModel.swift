import Foundation
import Combine

@MainActor
final class SPLPretestViewModel: ObservableObject {
    let questions = SPLPretestQuestion.all
    @Published private(set) var index = 0
    @Published var answers = Array(repeating: "", count: SPLPretestQuestion.all.count)
    @Published var explanations = Array(repeating: "", count: SPLPretestQuestion.all.count)
    @Published private(set) var isComplete = false

    func select(_ answer: String) {
        if answers[index] != answer { explanations[index] = "" }
        answers[index] = answer
    }

    var question: SPLPretestQuestion { questions[index] }
    var canContinue: Bool { !answers[index].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var completedCount: Int { answers.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count }

    func next() {
        guard canContinue else { return }
        if index < questions.count - 1 { index += 1 } else { isComplete = true }
    }

    func back() {
        if index > 0 { index -= 1 }
    }

    func review() {
        isComplete = false
        index = 0
    }
}
