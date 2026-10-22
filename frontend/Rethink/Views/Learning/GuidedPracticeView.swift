import SwiftUI

struct GuidedPracticeView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel

    var body: some View {
        if let step = viewModel.currentPracticeStep {
            GuidedPracticeStepView(step: step, index: viewModel.session?.practiceStepIndex ?? 0)
                .id(step.id)
        }
    }
}

private struct GuidedPracticeStepView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel
    let step: GuidedPracticeStep
    let index: Int
    @State private var response = ""
    @State private var hintShown = false

    var body: some View {
        LearningCard {
            LearningStepHeader(stage: "Belajar konsep", progress: "Tahap 3 dari 3", title: "Sekarang giliranmu")
            Text(viewModel.intervention.practiceProblem)
                .font(.system(size: 23, weight: .medium, design: .rounded))
                .foregroundStyle(HomeStyle.ink)
            Text("Langkah \(index + 1) dari \(viewModel.intervention.practiceSteps.count)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(HomeStyle.blue)
            Text(step.prompt)
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundStyle(HomeStyle.ink)

            TextField("Isi angka pada kotak", text: $response)
                .keyboardType(.numbersAndPunctuation)
                .textInputAutocapitalization(.never)
                .padding(16)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 18))
                .accessibilityLabel("Jawaban langkah \(index + 1)")

            if hintShown {
                Text(step.hint)
                    .font(.system(size: 14))
                    .foregroundStyle(HomeStyle.body)
            }
            if let feedback = viewModel.feedbackMessage {
                Text(feedback)
                    .font(.system(size: 14))
                    .foregroundStyle(HomeStyle.blue)
            }
            Button("Lihat petunjuk") { hintShown = true }
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
            LearningPrimaryButton(title: "Periksa langkah") {
                viewModel.submitGuidedPractice(response, hintUsed: hintShown)
            }
            Button("Sebelumnya") { viewModel.previousLearningStep() }
                .foregroundStyle(HomeStyle.blue)
        }
    }
}
