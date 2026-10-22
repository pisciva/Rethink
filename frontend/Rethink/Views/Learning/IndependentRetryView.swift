import SwiftUI

struct IndependentRetryView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel
    @State private var response = ""

    var body: some View {
        LearningCard {
            LearningStepHeader(stage: "Uji pemahaman", progress: "Bagian 1 dari 2", title: "Coba secara mandiri")
            Text("Kerjakan tanpa petunjuk. Jawaban pertama disimpan sebelum hasil ditampilkan.")
                .font(.system(size: 15))
                .foregroundStyle(HomeStyle.body)
            Text(viewModel.currentRetryQuestion.prompt)
                .font(.system(size: 21, weight: .medium, design: .rounded))
                .foregroundStyle(HomeStyle.ink)
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 20))
            TextField("Nilai x", text: $response)
                .keyboardType(.numbersAndPunctuation)
                .padding(16)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 18))
                .accessibilityLabel("Nilai x")
            Text("Masukkan satu bilangan bulat. Tidak ada petunjuk selama uji mandiri.")
                .font(.system(size: 13))
                .foregroundStyle(HomeStyle.body)
            LearningPrimaryButton(title: "Kirim jawaban mandiri") {
                viewModel.submitIndependentRetry(response)
            }
        }
    }
}
