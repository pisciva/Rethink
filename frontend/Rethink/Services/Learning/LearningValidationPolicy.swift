import Foundation

struct LearningValidationPolicy {
    func afterIndependentRetry(isCorrect: Bool) -> LearningStatus? {
        isCorrect ? nil : .needsReinforcement
    }

    func afterTransfer(isCorrect: Bool) -> LearningStatus {
        isCorrect ? .understood : .proceduralOnly
    }
}
