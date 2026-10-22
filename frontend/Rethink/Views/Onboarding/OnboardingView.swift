import AVFoundation
import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @State private var nameInputFocused = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    private let onComplete: () -> Void
    private let onStartSession: (() -> Void)?

    init(initialPage: Int? = nil, onStartSession: (() -> Void)? = nil, onComplete: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(initialPage: initialPage))
        self.onStartSession = onStartSession
        self.onComplete = onComplete
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            #if DEBUG
            if viewModel.currentPage != .quickCheck && viewModel.currentPage != .chatbot {
            HStack {
                Spacer()
                Button("Skip dev →") {
                    nameInputFocused = false
                    if viewModel.isLastPage {
                        viewModel.suspendAudio()
                        (onStartSession ?? onComplete)()
                    } else {
                        navigate { viewModel.select(viewModel.selectedPage + 1) }
                    }
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(HomeStyle.blue)
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                .background(HomeStyle.powder, in: Capsule())
                .accessibilityLabel("Lewati aktivitas untuk testing")
            }
            .padding(.horizontal, 24)
            }
            #endif


            OnboardingScreen(page: viewModel.currentPage, viewModel: viewModel, onNameFocusChanged: { nameInputFocused = $0 })
                .id(viewModel.selectedPage)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.vertical, 12)

            if !nameInputFocused
                && (viewModel.currentPage != .quickCheck || viewModel.quickCheckIndex == OnboardingQuickCheckItem.examples.count)
                && (viewModel.currentPage != .chatbot || viewModel.chatbotUsed) { footer }
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .preferredColorScheme(.light)
        .onAppear { viewModel.begin() }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { viewModel.suspendAudio() }
        }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { _ in
            viewModel.suspendAudio()
        }
        .onDisappear { viewModel.suspendAudio() }
    }

    private var header: some View {
        HStack(spacing: 10) {
            Button { navigate { viewModel.back() } } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .medium))
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .disabled(viewModel.selectedPage == 0)
            .opacity(viewModel.selectedPage == 0 ? 0.25 : 1)
            .accessibilityLabel("Halaman sebelumnya")

            HStack(spacing: 4) {
                ForEach(viewModel.pages) { page in
                    Capsule()
                        .fill(page.id <= viewModel.selectedPage ? HomeStyle.blue : HomeStyle.line)
                        .frame(height: 4)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Pengenalan, halaman \(viewModel.selectedPage + 1) dari \(viewModel.pages.count)")

            Button { viewModel.setAudioEnabled(!viewModel.audioEnabled) } label: {
                Image(systemName: viewModel.audioEnabled && viewModel.audio.isAvailable
                      ? "speaker.wave.2"
                      : "speaker.slash")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(viewModel.audioEnabled ? HomeStyle.blue : HomeStyle.body)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel(viewModel.audioEnabled ? "Matikan audio" : "Nyalakan audio")
            .accessibilityValue(viewModel.audioEnabled ? "Nyala" : "Mati")
        }
        .foregroundStyle(HomeStyle.ink)
        .padding(.horizontal, 20)
        .padding(.top, 4)
    }

    private var canContinue: Bool {
        if viewModel.currentPage == .quickCheck {
            return viewModel.familiarityAnswers.count == OnboardingQuickCheckItem.examples.count
                && viewModel.quickCheckIndex == OnboardingQuickCheckItem.examples.count
        }
        return viewModel.canAdvance
    }

    private var footer: some View {
        VStack(spacing: 8) {
            Button {
                if viewModel.isLastPage {
                    viewModel.finish(skipped: false)
                    (onStartSession ?? onComplete)()
                } else {
                    if viewModel.currentPage == .quickCheck { viewModel.confirmFamiliarity() }
                    navigate { viewModel.next() }
                }
            } label: {
                HStack(spacing: 10) {
                    Text(viewModel.currentPage == .quickCheck ? "Sudah sesuai semua" : viewModel.isLastPage ? "Mulai" : "Lanjut")
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(DarkCapsuleStyle())
            .disabled(!canContinue)
            .opacity(canContinue ? 1 : 0.45)

            if !canContinue {
                Text("Selesaikan aktivitas di atas untuk lanjut.")
                    .font(.caption)
                    .foregroundStyle(HomeStyle.muted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity)
    }

    private func navigate(_ action: () -> Void) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.35), action)
    }
}

private struct OnboardingScreen: View {
    let page: OnboardingPage
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dynamicTypeSize) private var typeSize
    var onNameFocusChanged: (Bool) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 22) {
            if page != .welcome && page != .quickCheck {
                if page == .chatbot {
                    heading.onboardingEditorialReveal()
                } else {
                    heading
                }
            }

            OnboardingScene(page: page, onNameFocusChanged: onNameFocusChanged, viewModel: viewModel)
        }
        .frame(maxWidth: 540)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var heading: some View {
        Text(page.title)
            .brandHeading(typeSize.isAccessibilitySize ? 28 : 32)
            .multilineTextAlignment(.center)
            .accessibilityAddTraits(.isHeader)
            .padding(.horizontal, 24)
    }

}

#Preview("01 · Kenalan") { OnboardingView(initialPage: 0, onComplete: {}) }
#Preview("02 · Cara kerja") { OnboardingView(initialPage: 1, onComplete: {}) }
#Preview("03 · Cek singkat") { OnboardingView(initialPage: 2, onComplete: {}) }
#Preview("04 · Chatbot") { OnboardingView(initialPage: 3, onComplete: {}) }
#Preview("05 · Siap") { OnboardingView(initialPage: 4, onComplete: {}) }
