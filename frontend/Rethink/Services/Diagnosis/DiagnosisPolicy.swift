import Foundation

enum InitialDiagnosticDecision: Equatable {
    case final(DiagnosticStatus, ruleID: String)
    case requiresProbe(blockerID: String, ruleID: String)
}

struct DiagnosisPolicy {
    func afterPreTest(_ answer: AnswerEvaluation, content: DiagnosticContentPack) -> InitialDiagnosticDecision {
        if answer.isCorrect {
            return .final(.allCorrect, ruleID: "pretest_correct")
        }
        if answer.matchedErrorPatternID == content.knownErrorPatternID {
            return .requiresProbe(blockerID: content.blockerID, ruleID: "known_pattern_needs_probe")
        }
        return .final(.uncertain, ruleID: "unknown_error_pattern")
    }

    func afterProbe(_ answer: AnswerEvaluation) -> (status: DiagnosticStatus, ruleID: String) {
        switch answer.probeSignal {
        case .supportsBlocker:
            return (.confirmed, "probe_supports_blocker")
        case .contradictsBlocker:
            return (.rejected, "probe_contradicts_blocker")
        case .ambiguous, .none:
            return (.uncertain, "probe_ambiguous")
        }
    }
}
