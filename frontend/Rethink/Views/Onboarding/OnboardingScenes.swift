import SwiftUI

/// Local onboarding previews. This layer never reads or writes learner evidence.
struct OnboardingScene: View {
    let page: OnboardingPage
    var onNameFocusChanged: (Bool) -> Void = { _ in }
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        Group {
            switch page {
            case .welcome: OnboardingWelcomeScene(viewModel: viewModel, onNameFocusChanged: onNameFocusChanged)
            case .concept: ConceptScene(viewModel: viewModel)
            case .quickCheck: OnboardingQuickCheckScene(viewModel: viewModel)
            case .chatbot: OnboardingChatPreviewScene(viewModel: viewModel)
            case .ready: ReadyScene(viewModel: viewModel)
            }
        }
        .padding(.horizontal, page == .quickCheck || page == .chatbot ? 0 : 24)
        .frame(maxWidth: page == .quickCheck || page == .chatbot ? .infinity : 500)
        .frame(maxWidth: .infinity)
    }
}

/// A value explanation, not a diagnostic activity or evidence of learning.
private struct ConceptScene: View {
    @ObservedObject var viewModel: OnboardingViewModel

    // SAFE-DRAFT: ob.current.loop.step.1–3 and ob.loop.step.1–3.
    private let steps: [(title: String, detail: String, symbol: String, wash: Color)] = [
        ("Cek pemahaman", "Kumpulkan bukti dari jawabanmu.", "magnifyingglass", HomeStyle.powder),
        ("Belajar terarah", "Pahami konsep dengan panduan.", "book.closed", HomeStyle.lavender),
        ("Coba sendiri", "Terapkan sendiri tanpa bantuan.", "pencil", HomeStyle.butter),
    ]

    var body: some View {
        VStack(spacing: 20) {
            // SAFE-DRAFT: ob.welcome.body.
            Text("Kadang kita tahu rumusnya, tapi belum paham kapan dipakai.")
                .font(.body)
                .foregroundStyle(HomeStyle.body)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .center, spacing: 12) {
                Image("JimmyMascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 132)
                    .accessibilityHidden(true)

                // SAFE-DRAFT: ob.value.title / ob.value.body.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Yuk, cari bagian yang belum nyambung")
                        .font(.headline.weight(.medium))
                        .foregroundStyle(HomeStyle.ink)
                    Text("Dari jawabanmu, Rethink mencoba melihat konsep mana yang mungkin perlu diperhatikan.")
                        .font(.subheadline)
                        .foregroundStyle(HomeStyle.body)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 24))
            }

            VStack(spacing: 10) {
                ForEach(steps.indices, id: \.self) { index in
                    let step = steps[index]
                    HStack(spacing: 14) {
                        Image(systemName: step.symbol)
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(HomeStyle.ink)
                            .frame(width: 42, height: 42)
                            .background(step.wash, in: RoundedRectangle(cornerRadius: 14))
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(step.title)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(HomeStyle.ink)
                            Text(step.detail)
                                .font(.caption)
                                .foregroundStyle(HomeStyle.body)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    .padding(12)
                    .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 20))
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
}

private struct ReadyScene: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 18) {
            BrandIllustration(name: "asset 35", size: 145, tilt: -8)
                .onboardingFloat()
            Text(viewModel.learnerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                 ? "Semua siap."
                 : "Halo, \(viewModel.learnerName.trimmingCharacters(in: .whitespacesAndNewlines))!")
                .brandHeading(24)
                .foregroundStyle(HomeStyle.ink)
                .multilineTextAlignment(.center)
            Text("Tanpa akun · mode tamu")
                .font(.caption)
                .foregroundStyle(HomeStyle.muted)
        }
    }
}
