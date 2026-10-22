import SwiftUI

struct ValidationIntroView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel

    var body: some View {
        LearningCard {
            LearningStepHeader(stage: "Uji pemahaman", progress: "Siap mencoba mandiri", title: "Sekarang coba tanpa bantuan")
            Text("Kamu sudah menyelesaikan penjelasan, contoh, dan latihan. Berikutnya ada satu soal mandiri dan, jika jawabanmu tepat, satu soal cerita.")
                .font(.system(size: 16))
                .foregroundStyle(HomeStyle.body)
            Text("Jawaban pertama pada setiap soal akan dicatat. Petunjuk dan contoh tidak tersedia selama uji ini.")
                .font(.system(size: 15))
                .foregroundStyle(HomeStyle.body)
            LearningPrimaryButton(title: "Mulai uji mandiri") {
                viewModel.beginIndependentValidation()
            }
        }
    }
}
