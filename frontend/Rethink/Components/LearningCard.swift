import SwiftUI

/// PRD v2 projections: these views display server evidence and never grade it.
struct ConceptEvidenceList: View {
    let concepts: [RemoteConceptEvidence]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(concepts) { concept in
                VStack(alignment: .leading, spacing: 8) {
                    Text(concept.title).font(.headline).foregroundStyle(HomeStyle.ink)
                    Text(statusLabel(concept.status)).font(.subheadline).foregroundStyle(HomeStyle.blue)
                    Text("Cakupan: \(concept.coverage.administered) respons diperiksa · \(concept.coverage.evaluable) dengan bukti yang dapat digunakan")
                        .font(.caption).foregroundStyle(HomeStyle.body)
                    Text(concept.learningAvailable
                         ? (concept.priority == "recommended" ? "Materi tersedia · disarankan dari bukti pemeriksaan" : "Materi tersedia · boleh kamu ulas")
                         : "Materi belajar belum tersedia")
                        .font(.caption).foregroundStyle(HomeStyle.body)
                    if let state = concept.learnerState {
                        Text("Validasi konsep terakhir: \(learnerLabel(state))").font(.subheadline).foregroundStyle(HomeStyle.ink)
                    }
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .brandSurface(HomeStyle.sky, radius: 20)
                .accessibilityElement(children: .combine)
            }
        }
    }

    private func statusLabel(_ status: String) -> String {
        switch status {
        case "supported": "Hambatan didukung bukti"
        case "not-supported": "Hambatan tidak didukung bukti"
        case "uncertain": "Bukti belum konsisten"
        default: "Bukti penilaian belum cukup"
        }
    }

    private func learnerLabel(_ state: RemoteLearnerState) -> String {
        switch state {
        case .understood: "Berhasil pada penerapan mandiri dan transfer"
        case .proceduralOnly: "Penerapan mandiri berhasil; transfer belum"
        case .needsReinforcement: "Perlu penguatan"
        }
    }
}

struct FinalAssessmentHistory: View {
    let assessment: RemoteFinalAssessment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Riwayat asesmen akhir SPL").font(.headline)
            Text("Lulus mulai 3 dari 5 soal. Hasil ini tidak mengubah status konsep prasyarat.")
                .font(.caption).foregroundStyle(HomeStyle.body)
            ForEach(assessment.attempts) { attempt in
                VStack(alignment: .leading, spacing: 5) {
                    Text("Percobaan \(attempt.id)").font(.subheadline.weight(.medium))
                    if let score = attempt.score, let result = attempt.result {
                        Text("\(score)/5 · \(result == "passed" ? "Lulus" : "Belum lulus")")
                    } else {
                        Text("\(attempt.answered)/5 jawaban tersimpan · Belum selesai")
                    }
                }
                .font(.subheadline)
                .accessibilityElement(children: .combine)
            }
        }
        .foregroundStyle(HomeStyle.ink)
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .brandSurface(HomeStyle.powder, radius: 20)
    }
}

struct SocraticHelpView: View {
    let journey: RemoteJourney
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var journeyStore: JourneyStore
    @State private var question = ""

    var body: some View {
        if [RemotePhase.visual, .worked, .practice].contains(journey.phase) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Bantu aku berpikir").font(.headline)
                ForEach(journey.hints ?? []) { hint in
                    Text(hint.text).font(.subheadline).accessibilityLabel(hint.text)
                }
                if journey.availableActions.contains(RemoteAction.requestHint.rawValue) {
                    TextField("Apa yang ingin kamu tanyakan? (opsional)", text: $question, axis: .vertical)
                        .font(.subheadline)
                        .accessibilityLabel("Pertanyaan tentang tahap belajar ini")
                    Button("Buka petunjuk berikutnya") {
                        let message = question.trimmingCharacters(in: .whitespacesAndNewlines)
                        Task {
                            await journeyStore.perform(.requestHint, auth: auth, message: message.isEmpty ? nil : message)
                        }
                    }
                    .buttonStyle(DarkCapsuleStyle())
                    .disabled(!journeyStore.canMutate || question.count > 500)
                    if question.count > 500 {
                        Text("Ringkas pertanyaanmu sampai 500 karakter.").font(.caption)
                    }
                } else {
                    Text("Coba gunakan petunjuk ini untuk melanjutkan langkahmu sendiri.").font(.caption)
                }
            }
            .foregroundStyle(HomeStyle.ink)
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .brandSurface(HomeStyle.sky, radius: 20)
        }
    }
}

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
