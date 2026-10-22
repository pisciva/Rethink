import SwiftUI

struct WorkedExampleView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel

    var body: some View {
        LearningCard {
            LearningStepHeader(stage: "Belajar konsep", progress: "Tahap 2 dari 3", title: "Lihat cara konsep digunakan")

            Text(viewModel.intervention.workedProblem)
                .font(.system(size: 23, weight: .medium, design: .rounded))
                .foregroundStyle(HomeStyle.ink)
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 20))

            ForEach(Array(viewModel.intervention.workedSteps.prefix(viewModel.session?.workedStepCount ?? 0))) { step in
                VStack(alignment: .leading, spacing: 7) {
                    MathExpressionView(latex: step.expression, accessibilityText: step.expression, fontSize: 22, centered: false)
                    Text(step.reason)
                        .font(.system(size: 14))
                        .foregroundStyle(HomeStyle.body)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 18))
            }

            if (viewModel.session?.workedStepCount ?? 0) < viewModel.intervention.workedSteps.count {
                LearningPrimaryButton(title: "Tampilkan langkah berikutnya") { viewModel.revealWorkedStep() }
            } else {
                LearningPrimaryButton(title: "Coba sendiri dengan bimbingan") { viewModel.advanceFromWorkedExample() }
            }
            Button("Sebelumnya") { viewModel.previousLearningStep() }
                .foregroundStyle(HomeStyle.blue)
        }
    }
}
