import Foundation

enum LearningAnswerError: Error, Equatable {
    case invalidFormat
}

protocol LearningAnswerValidating {
    func checkNumber(_ response: String, expected: Int) throws -> Bool
    func checkLinearExpression(_ response: String, coefficient: Int, constant: Int) throws -> Bool
}

/// Supports sums of integer constants and x terms, e.g. 3x+12, 12+3*x, or x+x+x+12.
/// Parentheses, division, powers, and arbitrary symbolic expressions are outside this MVP contract.
struct LocalLearningValidator: LearningAnswerValidating {
    func checkNumber(_ response: String, expected: Int) throws -> Bool {
        guard let number = Int(response.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            throw LearningAnswerError.invalidFormat
        }
        return number == expected
    }

    func checkLinearExpression(_ response: String, coefficient: Int, constant: Int) throws -> Bool {
        let compact = response.lowercased().filter { !$0.isWhitespace }.replacingOccurrences(of: "−", with: "-")
        guard !compact.isEmpty, compact.count <= 80,
              compact.allSatisfy({ $0.isNumber || $0 == "x" || $0 == "+" || $0 == "-" || $0 == "*" }) else {
            throw LearningAnswerError.invalidFormat
        }

        var xTotal = 0
        var numberTotal = 0
        var index = compact.startIndex
        while index < compact.endIndex {
            var sign = 1
            if compact[index] == "+" || compact[index] == "-" {
                sign = compact[index] == "-" ? -1 : 1
                index = compact.index(after: index)
            }
            let start = index
            while index < compact.endIndex, compact[index] != "+", compact[index] != "-" {
                index = compact.index(after: index)
            }
            guard start != index else { throw LearningAnswerError.invalidFormat }
            let term = String(compact[start..<index])
            if term.hasSuffix("x") {
                let prefix = String(term.dropLast())
                let raw = prefix.hasSuffix("*") ? String(prefix.dropLast()) : prefix
                guard !raw.contains("x"), !raw.contains("*"),
                      let value = raw.isEmpty && prefix.isEmpty ? 1 : Int(raw) else { throw LearningAnswerError.invalidFormat }
                let (sum, overflow) = xTotal.addingReportingOverflow(sign * value)
                guard !overflow else { throw LearningAnswerError.invalidFormat }
                xTotal = sum
            } else {
                guard !term.contains("*"), let value = Int(term) else { throw LearningAnswerError.invalidFormat }
                let (sum, overflow) = numberTotal.addingReportingOverflow(sign * value)
                guard !overflow else { throw LearningAnswerError.invalidFormat }
                numberTotal = sum
            }
        }
        return xTotal == coefficient && numberTotal == constant
    }
}
