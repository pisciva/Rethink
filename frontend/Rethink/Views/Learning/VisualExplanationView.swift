import SwiftUI

struct VisualExplanationView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel

    var body: some View {
        LearningCard {
            LearningStepHeader(stage: "Belajar konsep", progress: "Tahap 1 dari 3", title: "Pahami makna di balik rumus")

            Text(viewModel.intervention.visualExpression)
                .font(.system(size: 25, weight: .medium, design: .rounded))
                .foregroundStyle(HomeStyle.ink)

            if viewModel.session?.visualRevealed == true {
                HStack(spacing: 8) {
                    ForEach(Array(viewModel.intervention.visualGroups.enumerated()), id: \.offset) { _, group in
                        Text(group)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(HomeStyle.ink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(HomeStyle.powder, in: RoundedRectangle(cornerRadius: 18))
                    }
                }
                Text(viewModel.intervention.visualExplanation)
                    .font(.system(size: 16))
                    .foregroundStyle(HomeStyle.body)
                LearningPrimaryButton(title: "Lanjutkan ke contoh") { viewModel.advanceFromVisual() }
            } else {
                Text("Buka gambaran tiga kelompok untuk melihat bagaimana setiap suku dikalikan.")
                    .font(.system(size: 16))
                    .foregroundStyle(HomeStyle.body)
                LearningPrimaryButton(title: "Tampilkan tiga kelompok") { viewModel.revealVisual() }
            }
        }
    }
}
