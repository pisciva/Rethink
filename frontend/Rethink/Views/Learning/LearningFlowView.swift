import SwiftUI

struct LearningFlowView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Label("Konten draf · belum ditinjau tim matematika", systemImage: "pencil.line")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(HomeStyle.body)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(HomeStyle.lavender, in: RoundedRectangle(cornerRadius: 18))

                if let session = viewModel.session,
                   session.learningContentVersion != viewModel.intervention.version {
                    LearningCard {
                        Text("Versi materi berubah")
                            .font(.system(size: 24, weight: .medium))
                        Text("Materi yang tersimpan memakai versi lama. Mulai ulang pembelajaran dengan versi baru; hasil diagnosis dan riwayat jawaban tetap tersimpan.")
                        LearningPrimaryButton(title: "Mulai materi versi baru") {
                            viewModel.restartInterventionForUpdatedContent()
                        }
                    }
                } else if let phase = viewModel.session?.currentPhase {
                    switch phase {
                    case .visualExplanation: VisualExplanationView()
                    case .workedExample: WorkedExampleView()
                    case .guidedPractice: GuidedPracticeView()
                    case .validationIntro: ValidationIntroView()
                    case .independentRetry: IndependentRetryView()
                    case .transferProblem: TransferProblemView()
                    case .learningResult: LearningResultView()
                    default:
                        Text("Tahap belajar ini belum tersedia.")
                            .foregroundStyle(HomeStyle.body)
                    }
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
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle("Belajar Konsep")
        .navigationBarTitleDisplayMode(.inline)
    }
}
