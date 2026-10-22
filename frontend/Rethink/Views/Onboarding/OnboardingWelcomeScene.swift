import SwiftUI

/// The welcome conversation owns presentation only; name and navigation remain in the view model.
struct OnboardingWelcomeScene: View {
    @ObservedObject var viewModel: OnboardingViewModel
    var onNameFocusChanged: (Bool) -> Void = { _ in }
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize
    @FocusState private var nameFocused: Bool
    @State private var stage: Stage = .typing
    @State private var showQuestion = false
    @State private var questionTask: Task<Void, Never>?
    @State private var arrived = false
    @State private var wave = false

    private enum Stage { case typing, question, form }

    var body: some View {
        GeometryReader { geometry in
            let heroHeight: CGFloat = min(
                typeSize.isAccessibilitySize ? 180 : 240,
                max(0, geometry.size.height - (nameFocused ? 150 : 260))
            )
            VStack(spacing: nameFocused ? 8 : 18) {
                    TypingText(
                        text: OnboardingPage.welcome.title,
                        characterDelay: 38_000_000,
                        font: .system(.title2, design: .default, weight: .medium),
                        tracking: -0.7,
                        color: HomeStyle.ink,
                        alignment: .center
                    ) { beginQuestionSequence() }
                    .frame(maxWidth: 350)
                    .accessibilityAddTraits(.isHeader)
                    .frame(height: nameFocused ? 0 : nil)
                    .opacity(nameFocused ? 0 : 1)
                    .clipped()
                    .accessibilityHidden(nameFocused)

                    mascotStage
                        .frame(height: heroHeight)
                        .opacity(arrived ? 1 : 0)
                        .scaleEffect(arrived ? 1 : 0.88)
                        .offset(y: arrived ? 0 : 20)

                    conversation
                        .frame(maxWidth: 390)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(1)
            }
            .padding(.vertical, nameFocused ? 4 : 16)
            .frame(maxWidth: .infinity)
            .frame(height: geometry.size.height, alignment: nameFocused ? .bottom : .center)
            // Suppress inherited layout animations on both focus and keyboard resize.
            .animation(nil, value: nameFocused)
            .animation(nil, value: geometry.size.height)
        }
        .task {
            // Follow actual playback, rather than guessing the recorded intro's length.
            try? await Task.sleep(nanoseconds: 100_000_000)
            if viewModel.audioEnabled, viewModel.audio.isPlaying, viewModel.audio.duration > 0 {
                while viewModel.audioEnabled && viewModel.audio.isPlaying
                    && viewModel.audio.currentTime < viewModel.audio.duration * 0.5 {
                    do { try await Task.sleep(nanoseconds: 50_000_000) }
                    catch { return }
                }
            } else {
                do { try await Task.sleep(nanoseconds: 900_000_000) }
                catch { return }
            }
            guard !Task.isCancelled else { return }
            withAnimation(reduceMotion ? nil : .spring(response: 0.9, dampingFraction: 0.78)) {
                arrived = true
            }
        }
        .onChange(of: viewModel.audioEnabled) { _, enabled in
            // Unmute replays the intro; schedule its question cue again as well.
            if enabled { beginQuestionSequence() }
        }
        .onChange(of: nameFocused) { _, focused in onNameFocusChanged(focused) }
        .onDisappear {
            questionTask?.cancel()
            onNameFocusChanged(false)
        }
    }

    private var conversation: some View {
        VStack(spacing: 18) {
            Group {
                if showQuestion {
                    TypingText(
                        text: OnboardingPage.welcome.message,
                        characterDelay: 40_000_000,
                        font: .system(.title, design: .default, weight: .medium),
                        tracking: -1.05,
                        color: HomeStyle.ink,
                        alignment: .center
                    ) {
                        withAnimation(reduceMotion ? nil : .spring(response: 0.75, dampingFraction: 0.84)) {
                            stage = .form
                        }
                    }
                } else {
                    Text(OnboardingPage.welcome.message)
                        .font(.title)
                        .hidden()
                        .accessibilityHidden(true)
                }
            }

            HStack(spacing: 12) {
                TextField("Nama kamu", text: $viewModel.learnerName)
                    .textContentType(.givenName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .font(.title3.weight(.medium))
                    .focused($nameFocused)
                    .submitLabel(.done)
                    .onSubmit { nameFocused = false }
                    .accessibilityLabel("Nama kamu")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 19)
            .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(nameFocused ? HomeStyle.blue : HomeStyle.line, lineWidth: nameFocused ? 1.5 : 1)
            }
            .shadow(color: HomeStyle.blue.opacity(nameFocused ? 0.09 : 0.025), radius: 18, y: 8)
            .opacity(stage == .form ? 1 : 0)
            .offset(y: stage == .form || reduceMotion ? 0 : 12)
            .allowsHitTesting(stage == .form)
            .accessibilityHidden(stage != .form)
        }
    }

    private var mascotStage: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            ZStack {
                Ellipse()
                    .fill(HomeStyle.blue.opacity(0.09))
                    .frame(width: size * 0.52, height: 16)
                    .blur(radius: 9)
                    .offset(y: size * 0.43)

                Image(systemName: "sparkle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(HomeStyle.blue.opacity(0.5))
                    .offset(x: -size * 0.43, y: -size * 0.19)
                Circle()
                    .fill(HomeStyle.mint)
                    .frame(width: 12, height: 12)
                    .offset(x: size * 0.43, y: size * 0.17)
                Circle()
                    .fill(HomeStyle.butter)
                    .frame(width: 8, height: 8)
                    .offset(x: size * 0.35, y: -size * 0.32)

                if reduceMotion {
                    mascot(size: size)
                } else {
                    PhaseAnimator([false, true]) { phase in
                        mascot(size: size)
                            .animation(nil, value: size)
                            .offset(y: phase ? -7 : 2)
                            .rotationEffect(.degrees(phase ? 1.5 : -1.5))
                    } animation: { _ in .easeInOut(duration: 3.6) }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .animation(nil, value: size)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Jimmy, teman belajar kamu")
    }

    private func mascot(size: CGFloat) -> some View {
        Image("JimmyMascot")
            .resizable()
            .scaledToFit()
            .frame(width: size * 0.96, height: size * 0.96)
            .rotationEffect(.degrees(reduceMotion ? 0 : (wave ? -6 : 0)), anchor: .bottom)
            .onTapGesture {
                guard !reduceMotion else { return }
                withAnimation(.spring(response: 0.35, dampingFraction: 0.35)) { wave.toggle() }
            }
    }

    private func beginQuestionSequence() {
        questionTask?.cancel()
        questionTask = Task { @MainActor in
            // Let the intro audio finish, then pause for 0.8 seconds.
            while viewModel.audio.isPlaying {
                if Task.isCancelled { return }
                try? await Task.sleep(nanoseconds: 100_000_000)
            }
            try? await Task.sleep(nanoseconds: 800_000_000)
            if Task.isCancelled { return }
            withAnimation(reduceMotion ? nil : .spring(response: 0.7, dampingFraction: 0.85)) {
                showQuestion = true
            }
            viewModel.playAudio(named: "onboarding-1b")
        }
    }
}

private struct TypingText: View {
    let text: String
    var characterDelay: UInt64 = 34_000_000
    var font: Font = .system(size: 32, weight: .medium)
    var tracking: CGFloat = -1.12
    var color: Color = HomeStyle.ink
    var alignment: TextAlignment = .center
    let onComplete: () -> Void
    @State private var visibleCount = 0

    var body: some View {
        let visible = String(text.prefix(visibleCount))
        ZStack(alignment: .top) {
            Text(text).hidden().accessibilityHidden(true)
            Text(visible + (visibleCount < text.count ? "|" : ""))
        }
            .accessibilityElement(children: .ignore)
            .font(font)
            .tracking(tracking)
            .foregroundStyle(color)
            .multilineTextAlignment(alignment)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityLabel(text)
            .task {
                for count in 0...text.count {
                    if Task.isCancelled { return }
                    await MainActor.run { visibleCount = count }
                    if count < text.count {
                        try? await Task.sleep(nanoseconds: characterDelay)
                    }
                }
                await MainActor.run { onComplete() }
            }
    }
}

