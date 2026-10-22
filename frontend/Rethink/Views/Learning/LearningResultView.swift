import SwiftUI

struct LearningResultView: View {
    @EnvironmentObject private var viewModel: DiagnosisViewModel
    @EnvironmentObject private var navigation: AppNavigationViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        LearningCard {
            LearningStepHeader(stage: "Hasil belajar", progress: "Sifat Distributif", title: title)
            Text(explanation)
                .font(.system(size: 16))
                .foregroundStyle(HomeStyle.body)
            Text("Status ini berlaku untuk konsep yang diuji, bukan penguasaan seluruh Sistem Persamaan Linear.")
                .font(.system(size: 14))
                .foregroundStyle(HomeStyle.body)
            if viewModel.session?.learningMode == .optionalReview {
                Text("Pembelajaran ini dibuka sebagai tinjauan opsional. Hasil diagnosis sebelumnya tetap tersimpan.")
                    .font(.system(size: 13))
                    .foregroundStyle(HomeStyle.blue)
            }
            switch viewModel.session?.learningStatus {
            case .understood:
                LearningPrimaryButton(title: "Lihat Peta Belajar") { navigation.selectedTab = .map }
            case .proceduralOnly:
                LearningPrimaryButton(title: "Tinjau konsep") { viewModel.reviewConcept() }
            case .needsReinforcement:
                if (viewModel.session?.reinforcementCount ?? 0) < 1 {
                    LearningPrimaryButton(title: "Ulangi pembelajaran") { viewModel.repeatLearning() }
                } else {
                    LearningPrimaryButton(title: "Simpan untuk nanti") {
                        dismiss()
                        navigation.selectedTab = .home
                    }
                    Button("Mulai pemeriksaan baru") {
                        if let topicID = viewModel.session?.topicID {
                            viewModel.start(topicID: topicID)
                            dismiss()
                            navigation.selectedTab = .home
                        }
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(HomeStyle.blue)
                    .frame(maxWidth: .infinity)
                }
            case .none:
                EmptyView()
            }
            Button("Kembali ke materi") { dismiss() }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
                .frame(maxWidth: .infinity)
        }
    }

    private var title: String {
        switch viewModel.session?.learningStatus {
        case .understood: "Konsep berhasil dipahami"
        case .proceduralOnly: "Langkahnya bisa, konteks baru masih perlu latihan"
        case .needsReinforcement: "Konsep masih perlu diperkuat"
        case .none: "Hasil belum tersedia"
        }
    }

    private var explanation: String {
        switch viewModel.session?.learningStatus {
        case .understood: "Kamu berhasil menggunakan konsep secara mandiri dan dalam situasi berbeda."
        case .proceduralOnly: "Kamu bisa menjalankan prosedurnya, tetapi jawaban pada soal cerita belum tepat."
        case .needsReinforcement: "Jawaban mandiri belum tepat. Soal transfer belum dibuka; kamu dapat mengulang pembelajaran dengan soal mandiri berbeda."
        case .none: ""
        }
    }
}
