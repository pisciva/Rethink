import SwiftUI

struct TopicOverviewView: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var journeyStore: JourneyStore
    let topic: TopicSummary
    @State private var showJourney = false
    @State private var isStarting = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                VStack(spacing: 18) {
                    HStack {
                        BrandTag(text: "Aljabar", symbol: "function")
                        Spacer()
                        BrandTag(text: "Konsep dasar", color: HomeStyle.body)
                    }
                    BrandIllustration(name: topic.illustrationName, size: 205, tilt: -5)
                        .padding(.vertical, 2)
                    Text(topic.title).brandHeading(35).multilineTextAlignment(.center)
                    Text("Pahami konsep di balik persamaannya,\nsatu langkah demi satu langkah.")
                        .font(.subheadline)
                        .lineSpacing(4)
                        .foregroundStyle(HomeStyle.body)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 6)

                if topic.availability == .available {
                    VStack(alignment: .leading, spacing: 22) {
                        BrandSectionHeading(title: "Begini cara kita belajar")
                        journeyStep(number: "01", title: "Kenali dulu", detail: "Jawab 3 pertanyaan inti. Ada 1 pertanyaan tambahan bila diperlukan.", symbol: "magnifyingglass", color: HomeStyle.powder)
                        journeyStep(number: "02", title: "Bikin lebih jelas", detail: "Pelajari konsep yang terkonfirmasi, atau pilih ulasan opsional.", symbol: "lightbulb", color: HomeStyle.butter)
                        journeyStep(number: "03", title: "Coba sendiri", detail: "Setelah pemulihan konsep, coba mandiri dan lanjutkan ke soal transfer bila berhasil.", symbol: "pencil.and.outline", color: HomeStyle.mint)
                    }
                    .padding(24)
                    .brandSurface()

                    HStack(alignment: .top, spacing: 11) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 17, weight: .light))
                        Text("Versi uji coba. Soal, materi, dan aturan penilaian masih dalam peninjauan.")
                            .font(.caption)
                            .lineSpacing(3)
                    }
                    .foregroundStyle(HomeStyle.body)
                    .padding(.horizontal, 5)

                    if let error = journeyStore.errorMessage, !journeyStore.resetRequired {
                        Text(error)
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .padding(18)
                            .brandSurface()
                    }
                } else {
                    BrandEmptyState(illustration: "asset 04", title: "Sedang disiapkan", message: "Topik ini belum tersedia untuk pemeriksaan konsep.")
                }
            }
            .padding(24)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.background.ignoresSafeArea())
        .navigationTitle("Tentang topik")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if topic.availability == .available {
                Button(action: startOrContinue) {
                    HStack(spacing: 10) {
                        if isStarting || journeyStore.isWorking { ProgressView().tint(.white) }
                        Text(buttonTitle)
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(DarkCapsuleStyle())
                .disabled(isStarting || journeyStore.isWorking)
                .padding(.horizontal, 24)
                .padding(.top, 14)
                .padding(.bottom, 12)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
                .background(HomeStyle.background)
            }
        }
        .navigationDestination(isPresented: $showJourney) { JourneyFlowView() }
    }

    private func journeyStep(number: String, title: String, detail: String, symbol: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: symbol)
                .font(.system(size: 21, weight: .light))
                .foregroundStyle(HomeStyle.ink)
                .frame(width: 46, height: 46)
                .background(color, in: RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title).font(.headline.weight(.medium)).foregroundStyle(HomeStyle.ink)
                    Spacer()
                    Text(number).font(.caption.monospacedDigit()).foregroundStyle(HomeStyle.body)
                }
                Text(detail).font(.subheadline).foregroundStyle(HomeStyle.body).lineSpacing(3)
            }
        }
    }

    private var buttonTitle: String {
        if journeyStore.resetRequired { return "Tinjau sesi belajar" }
        guard let journey = journeyStore.journey, journey.selectedTopic != nil else { return "Yuk, mulai pemeriksaan" }
        switch journey.phase {
        case .visual, .worked, .practice: return "Lanjutkan belajar"
        case .validationResult, .reviewComplete: return "Lihat hasil"
        default: return "Lanjutkan pemeriksaan"
        }
    }

    private func startOrContinue() {
        Task {
            isStarting = true
            defer { isStarting = false }
            if journeyStore.journey == nil { await journeyStore.load(auth: auth) }
            guard !journeyStore.resetRequired else {
                showJourney = true
                return
            }
            if journeyStore.journey?.selectedTopic == nil {
                await journeyStore.selectTopic(topic.id, auth: auth)
            }
            if journeyStore.errorMessage == nil || journeyStore.journey != nil { showJourney = true }
        }
    }
}
