import SwiftUI

struct DiagnosticFlowView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel
    @Environment(\.dismiss) private var dismiss
    let topicID: String
    @State private var showLearning = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                draftNotice

                if let session = viewModel.session, session.topicID == topicID,
                   session.contentVersion != viewModel.content.version {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Konten pemeriksaan telah diperbarui")
                            .font(.system(size: 24, weight: .medium))
                        Text("Sesi lama tersimpan, tetapi tidak dapat dilanjutkan dengan soal versi baru.")
                            .font(.system(size: 15))
                        Button("Mulai pemeriksaan baru") { viewModel.start(topicID: topicID) }
                            .buttonStyle(DiagnosticPrimaryButtonStyle())
                    }
                    .diagnosticCard()
                } else if let session = viewModel.session, session.topicID == topicID {
                    switch session.currentPhase {
                    case .preTest:
                        questionScreen(
                            title: "Pemeriksaan Konsep",
                            step: "SOAL 1 DARI 1",
                            question: viewModel.content.preTest,
                            action: viewModel.submitPreTest
                        )
                    case .diagnosticProbe:
                        questionScreen(
                            title: "Pertanyaan Tambahan",
                            step: "PROBE 1 DARI 1",
                            question: viewModel.content.conceptualProbe,
                            action: viewModel.submitProbe
                        )
                    case .diagnosisResult:
                        resultScreen(session)
                    default:
                        if session.currentPhase.isLearningPhase {
                            LearningCard {
                                Text("Sesi belajar tersimpan")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(HomeStyle.ink)
                                Text("Lanjutkan dari tahap terakhir yang telah disimpan.")
                                    .foregroundStyle(HomeStyle.body)
                                NavigationLink("Lanjutkan belajar") { LearningFlowView() }
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(HomeStyle.blue)
                            }
                        } else {
                            unsupportedPhase
                        }
                    }
                } else {
                    introduction
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.system(size: 14))
                        .foregroundStyle(.red)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white, in: RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding(20)
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.background.ignoresSafeArea())
        .navigationTitle("Pemeriksaan Konsep")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showLearning) { LearningFlowView() }
    }

    private var draftNotice: some View {
        Label("Konten draf · belum ditinjau tim matematika", systemImage: "pencil.line")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(HomeStyle.body)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(HomeStyle.lavender, in: RoundedRectangle(cornerRadius: 18))
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("asset 33")
                .resizable()
                .scaledToFit()
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(true)

            Text("Cari tahu bagian yang perlu diperkuat")
                .font(.system(size: 29, weight: .medium))
                .foregroundStyle(HomeStyle.ink)

            Text("Kami akan memeriksa jawabanmu untuk melihat konsep yang mungkin perlu diperkuat. Hasil ini bukan nilai sekolah.")
                .font(.system(size: 16))
                .foregroundStyle(HomeStyle.body)

            Label("Kerjakan sesuai pemahamanmu sendiri.", systemImage: "lightbulb")
            Label("Mungkin ada satu pertanyaan tambahan.", systemImage: "questionmark.circle")
            Text("Saat ini pemeriksaan hanya mencakup sebagian kecil materi Sistem Persamaan Linear.")
                .font(.system(size: 14))
                .foregroundStyle(HomeStyle.body)

            Button("Mulai Diagnosis") { viewModel.start(topicID: topicID) }
                .buttonStyle(DiagnosticPrimaryButtonStyle())
        }
        .diagnosticCard()
    }

    private func questionScreen(title: String, step: String, question: DiagnosticQuestion, action: @escaping (String, String?) -> Void) -> some View {
        DiagnosticQuestionScreen(title: title, step: step, question: question, action: action)
            .id(question.id)
    }

    private func resultScreen(_ session: LearningSession) -> some View {
        let presentation = viewModel.resultPresentation(for: session.diagnosticStatus)
        return VStack(alignment: .leading, spacing: 20) {
            Text("HASIL PEMERIKSAAN")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1.3)
                .foregroundStyle(HomeStyle.blue)

            Text(presentation.title)
                .font(.system(size: 29, weight: .medium))
                .foregroundStyle(HomeStyle.ink)

            Text(presentation.explanation)
                .font(.system(size: 16))
                .foregroundStyle(HomeStyle.body)

            if session.diagnosticStatus == .confirmed {
                Label(viewModel.content.blockerTitle, systemImage: "sparkle.magnifyingglass")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(HomeStyle.ink)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(HomeStyle.powder, in: RoundedRectangle(cornerRadius: 20))
            }

            Text("Cakupan: satu soal awal dan, bila diperlukan, satu pertanyaan konsep. Hasil ini belum menilai penguasaan seluruh topik.")
                .font(.system(size: 14))
                .foregroundStyle(HomeStyle.body)

            if let nextStep = presentation.nextStep {
                Text(nextStep)
                    .font(.system(size: 14))
                    .foregroundStyle(HomeStyle.body)
            }

            if session.diagnosticStatus == .confirmed {
                Button("Pelajari Sifat Distributif") { openLearning(mode: .targetedRecovery) }
                    .buttonStyle(DiagnosticPrimaryButtonStyle())
            } else {
                Button("Tinjau konsep secara opsional") { openLearning(mode: .optionalReview) }
                    .buttonStyle(DiagnosticPrimaryButtonStyle())
            }

            Button("Kembali ke topik") { dismiss() }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
                .frame(maxWidth: .infinity)

            Button("Mulai pemeriksaan baru") { viewModel.start(topicID: topicID) }
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
                .frame(maxWidth: .infinity)
        }
        .diagnosticCard()
    }

    private var unsupportedPhase: some View {
        Text("Sesi tersimpan berada pada tahap yang belum tersedia dalam versi ini.")
            .font(.system(size: 16))
            .foregroundStyle(HomeStyle.body)
            .diagnosticCard()
    }

    private func openLearning(mode: LearningMode) {
        viewModel.startLearning(mode: mode)
        showLearning = viewModel.session?.currentPhase == .visualExplanation
    }

}

private struct DiagnosticQuestionScreen: View {
    let title: String
    let step: String
    let question: DiagnosticQuestion
    let action: (String, String?) -> Void
    @State private var selectedOptionID: String?
    @State private var reasoning = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(step)
                .font(.system(size: 12, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(HomeStyle.blue)
            Text(title)
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(HomeStyle.ink)
            Text(question.prompt)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(HomeStyle.ink)

            if let context = question.context {
                Text(context)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(HomeStyle.ink)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 20))
            }

            Text(question.instruction)
                .font(.system(size: 14))
                .foregroundStyle(HomeStyle.body)

            ForEach(question.options) { option in
                Button {
                    selectedOptionID = option.id
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: selectedOptionID == option.id ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(HomeStyle.blue)
                        Text(option.text)
                            .foregroundStyle(HomeStyle.ink)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    .font(.system(size: 16))
                    .padding(16)
                    .background(selectedOptionID == option.id ? HomeStyle.powder : HomeStyle.paper,
                                in: RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }

            TextField("Bagaimana kamu mendapatkan jawaban ini? (opsional)", text: $reasoning, axis: .vertical)
                .lineLimit(2...4)
                .padding(14)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 16))
            Text("Catatan ini disimpan sebagai konteks; belum menentukan hasil diagnosis.")
                .font(.system(size: 12))
                .foregroundStyle(HomeStyle.muted)

            Button("Simpan dan lanjutkan") {
                if let selectedOptionID { action(selectedOptionID, reasoning) }
            }
            .buttonStyle(DiagnosticPrimaryButtonStyle())
            .disabled(selectedOptionID == nil)
            .opacity(selectedOptionID == nil ? 0.55 : 1)

            Text("Jawaban disimpan di perangkat ini. Hasil muncul setelah pemeriksaan selesai.")
                .font(.system(size: 12))
                .foregroundStyle(HomeStyle.muted)
        }
        .diagnosticCard()
    }
}

private struct DiagnosticPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(HomeStyle.ink, in: Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

private extension View {
    func diagnosticCard() -> some View {
        self.padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 30))
    }
}
