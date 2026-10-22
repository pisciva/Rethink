import SwiftUI

struct LearningStepHeader: View {
    let stage: String
    let progress: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                BrandTag(text: stage, symbol: "sparkle", fill: HomeStyle.sky)
                Spacer()
                Text(progress)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(HomeStyle.body)
            }
            Text(title)
                .brandHeading(28)
                .accessibilityAddTraits(.isHeader)
        }
    }
}

struct LearningPrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(DarkCapsuleStyle())
    }
}

/// GAM-PROG: a server-owned activity projection, never a mastery percentage.
struct JourneyProgressView: View {
    let presentation: RemoteJourneyPresentation

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(presentation.stages) { stage in
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Image(systemName: symbol(stage.state))
                        .foregroundStyle(stage.state == "current" ? HomeStyle.blue : HomeStyle.body)
                        .accessibilityHidden(true)
                    Text(stage.label)
                        .font(.subheadline.weight(stage.state == "current" ? .semibold : .medium))
                    Spacer(minLength: 8)
                    Text(stateLabel(stage.state))
                        .font(.caption)
                        .foregroundStyle(HomeStyle.body)
                        .multilineTextAlignment(.trailing)
                }
                .accessibilityElement(children: .combine)
            }
            Divider()
            Text(presentation.activity)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(HomeStyle.blue)
                .accessibilityLabel("Aktivitas saat ini: \(presentation.activity)")
            if let context = presentation.context {
                Text(context == .optionalReview ? "Ulasan opsional · bukan pemulihan hambatan terkonfirmasi" : "Pemulihan hambatan terkonfirmasi")
                    .font(.caption)
                    .foregroundStyle(HomeStyle.body)
            }
        }
        .foregroundStyle(HomeStyle.ink)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .brandSurface()
        .accessibilityElement(children: .contain)
    }

    private func stateLabel(_ state: String) -> String {
        switch state {
        case "current": "Sedang dikerjakan"
        case "complete": "Selesai"
        case "optional": "Opsional"
        case "not-applicable": "Tidak berlaku"
        case "needs-action": "Perlu penguatan"
        default: "Belum dimulai"
        }
    }

    private func symbol(_ state: String) -> String {
        switch state {
        case "current": "circle.inset.filled"
        case "complete": "checkmark.circle"
        case "optional": "arrow.triangle.branch"
        case "not-applicable": "minus.circle"
        case "needs-action": "arrow.counterclockwise.circle"
        default: "circle"
        }
    }
}

struct ValidationEvidenceView: View {
    let evidence: RemoteValidationEvidence

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bukti pada tugas yang diuji").font(.headline.weight(.medium))
            row("Independent Retry", result: evidence.retry)
            row("Transfer Problem", result: evidence.transfer)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .brandSurface(HomeStyle.powder.opacity(0.55), radius: 22)
    }

    private func row(_ title: String, result: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
            Spacer(minLength: 8)
            Text(result == "passed" ? "Berhasil" : result == "not-administered" ? "Tidak diberikan" : "Belum berhasil")
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
        .foregroundStyle(HomeStyle.body)
        .accessibilityElement(children: .combine)
    }
}

/// GAM-ACH: historical rendering of this persisted result, without issuance,
/// notification, animation callbacks or client-created learner judgments.
struct ConceptAchievementView: View {
    let journey: RemoteJourney

    var body: some View {
        if journey.phase == .validationResult, journey.origin == .confirmedRecovery,
           journey.diagnosticOutcome == .confirmed, journey.learningCompleted,
           journey.learnerState == .understood,
           journey.presentation?.validation?.retry == "passed",
           journey.presentation?.validation?.transfer == "passed",
           let achievement = journey.presentation?.achievement, achievement.concept == "distribution" {
            VStack(alignment: .leading, spacing: 12) {
                Label("Konsep berhasil diterapkan", systemImage: "checkmark.seal")
                    .font(.headline.weight(.medium))
                Text("Sifat Distributif").brandHeading(23)
                Text("Kamu berhasil di soal mandiri dan soal bentuk berbeda yang diuji.")
                    .font(.subheadline)
                Text("Pencapaian ini tidak menilai seluruh topik SPL.")
                    .font(.caption)
            }
            .foregroundStyle(HomeStyle.ink)
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .brandSurface(HomeStyle.mint, radius: 24)
            .accessibilityElement(children: .combine)
        }
    }
}

struct LearningCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) { content }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .brandSurface()
    }
}
