import SwiftUI

struct LearningHistoryView: View {
    @StateObject private var viewModel = LearningHistoryViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if viewModel.sessions.isEmpty {
                    Text(viewModel.errorMessage ?? "Belum ada sesi belajar yang tersimpan.")
                        .foregroundStyle(HomeStyle.body)
                        .padding(22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white, in: RoundedRectangle(cornerRadius: 24))
                }
                ForEach(viewModel.sessions) { session in
                    NavigationLink {
                        LearningHistoryDetailView(session: session)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sistem Persamaan Linear")
                                .font(.system(size: 19, weight: .medium))
                                .foregroundStyle(HomeStyle.ink)
                            Text(session.startedAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.system(size: 13))
                                .foregroundStyle(HomeStyle.muted)
                            Text(statusLabel(session))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(HomeStyle.blue)
                            Text("\(session.questionAttempts.count + session.learningAttempts.count) respons tersimpan")
                                .font(.system(size: 12))
                                .foregroundStyle(HomeStyle.body)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white, in: RoundedRectangle(cornerRadius: 24))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle("Riwayat Belajar")
        .task { viewModel.reload() }
    }

    private func statusLabel(_ session: LearningSession) -> String {
        if let status = session.learningStatus {
            switch status {
            case .understood: return "Dipahami pada uji ini"
            case .proceduralOnly: return "Prosedur bisa, transfer belum"
            case .needsReinforcement: return "Perlu penguatan"
            }
        }
        if let status = session.diagnosticStatus {
            switch status {
            case .confirmed: return "Diagnosis: dugaan terkonfirmasi"
            case .rejected: return "Diagnosis: dugaan tidak terkonfirmasi"
            case .uncertain: return "Diagnosis: belum pasti"
            case .allCorrect: return "Pemeriksaan awal tepat"
            }
        }
        return "Sesi belum selesai"
    }
}

private struct LearningHistoryDetailView: View {
    let session: LearningSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Sesi \(session.startedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(HomeStyle.ink)
                Text("Konten \(session.contentVersion) · \(session.contentReviewStatus.rawValue)")
                    .font(.system(size: 13))
                    .foregroundStyle(HomeStyle.body)
                if let mode = session.learningMode {
                    Text(mode == .optionalReview ? "Mode: tinjauan opsional" : "Mode: pembelajaran terarah")
                        .font(.system(size: 14))
                        .foregroundStyle(HomeStyle.blue)
                }

                ForEach(session.questionAttempts) { attempt in
                    attemptCard(
                        title: attempt.phase == .preTest ? "Soal awal" : "Pertanyaan tambahan",
                        questionID: attempt.questionID,
                        response: attempt.responseOptionID.uppercased(),
                        correct: attempt.isCorrect,
                        date: attempt.submittedAt,
                        note: attempt.reasoning
                    )
                }
                ForEach(session.learningAttempts) { attempt in
                    attemptCard(
                        title: attempt.phase == .guidedPractice ? "Latihan terbimbing" :
                            (attempt.phase == .independentRetry ? "Uji mandiri" : "Soal transfer"),
                        questionID: attempt.questionID,
                        response: attempt.response,
                        correct: attempt.isCorrect,
                        date: attempt.submittedAt,
                        note: attempt.hintUsed ? "Petunjuk digunakan" : nil
                    )
                }
            }
            .padding(20)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle("Detail Sesi")
    }

    private func attemptCard(title: String, questionID: String, response: String, correct: Bool, date: Date, note: String?) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(HomeStyle.ink)
            Text("Jawaban: \(response) · \(correct ? "tepat" : "belum tepat")")
                .font(.system(size: 14))
                .foregroundStyle(HomeStyle.body)
            Text("ID soal: \(questionID)")
                .font(.system(size: 12))
                .foregroundStyle(HomeStyle.muted)
            Text(date.formatted(date: .omitted, time: .shortened))
                .font(.system(size: 12))
                .foregroundStyle(HomeStyle.muted)
            if let note, !note.isEmpty {
                Text(note)
                    .font(.system(size: 13))
                    .foregroundStyle(HomeStyle.body)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
    }
}
