import SwiftUI

struct TransferProblemView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel
    @State private var response = ""

    var body: some View {
        LearningCard {
            LearningStepHeader(stage: "Uji pemahaman", progress: "Bagian 2 dari 2", title: "Gunakan konsep dalam situasi baru")
            Text(viewModel.intervention.transferQuestion.prompt)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(HomeStyle.ink)
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 20))
            TextField("Contoh format: 3x+12", text: $response)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(16)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 18))
                .accessibilityLabel("Ekspresi jumlah pensil")
            Text("Format yang didukung: jumlah suku x dan bilangan bulat, tanpa tanda kurung. Bentuk setara seperti 12+3x diterima.")
                .font(.system(size: 13))
                .foregroundStyle(HomeStyle.body)
            LearningPrimaryButton(title: "Kirim jawaban transfer") {
                viewModel.submitTransfer(response)
            }
        }
    }
}
