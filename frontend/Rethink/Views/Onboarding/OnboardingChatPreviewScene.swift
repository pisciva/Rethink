import SwiftUI

struct OnboardingChatPreviewScene: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @StateObject private var chat = OnboardingChatPreviewViewModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private var motion: Animation? { reduceMotion ? nil : .smooth(duration: 0.38) }
    private var entrance: AnyTransition {
        reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 10))
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image("JimmyMascot")
                    .resizable().scaledToFit()
                    .frame(width: 66, height: 76)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Jimmy").font(.headline.weight(.medium))
                    Text("Simulasi percakapan")
                        .font(.caption)
                        .foregroundStyle(HomeStyle.body)
                }
                Spacer(minLength: 0)
                Image(systemName: "bubble.left.and.bubble.right")
                    .foregroundStyle(HomeStyle.blue)
                    .accessibilityHidden(true)
            }
            .onboardingEditorialReveal(delay: 300_000_000)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        bubble("Apakah ada yang bisa Jimmy bantu?")
                        ForEach(chat.turns) { prompt in
                            HStack {
                                Spacer(minLength: 24)
                                Text(prompt.title)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(HomeStyle.paper)
                                    .padding(16)
                                    .background(HomeStyle.charcoal, in: RoundedRectangle(cornerRadius: 22))
                                    .onboardingCardShadow()
                            }
                            .transition(entrance)
                            if chat.isThinking && prompt == chat.selectedPrompt {
                                thinking.transition(.opacity)
                            }
                            if (chat.replySteps[prompt] ?? 0) > 0 {
                                reply(for: prompt, steps: chat.replySteps[prompt] ?? 0)
                                    .transition(entrance)
                            }
                        }
                        Color.clear.frame(height: 1).id("latest")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .animation(motion, value: chat.selectedPrompt)
                    .animation(motion, value: chat.isThinking)
                    .animation(motion, value: chat.scrollRevision)
                }
                .scrollIndicators(.hidden)
                .defaultScrollAnchor(.bottom, for: .sizeChanges)
                .task(id: chat.scrollRevision) {
                    do { try await Task.sleep(nanoseconds: 80_000_000) }
                    catch { return }
                    withAnimation(motion) { proxy.scrollTo("latest", anchor: .bottom) }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, -24)
            .onboardingEditorialReveal(delay: 450_000_000)

            VStack(spacing: 8) {
                if let prompt = chat.nextPrompt {
                    Button {
                        withAnimation(motion) {
                            viewModel.beginChatbotPreview()
                            chat.ask(prompt) { viewModel.useChatbot() }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text(prompt.title)
                                .font(.subheadline.weight(.medium))
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 0)
                            Image(systemName: chat.selectedPrompt == nil ? "hand.tap" : "arrow.up.right")
                                .foregroundStyle(HomeStyle.blue)
                                .symbolEffect(.pulse, options: .repeating, isActive: !reduceMotion && chat.selectedPrompt == nil)
                        }
                        .foregroundStyle(HomeStyle.ink)
                        .padding(15)
                        .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 18))
                        .onboardingCardShadow()
                        
                        .contentShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(GentlePressStyle())
                    .disabled(chat.selectedPrompt != nil && !chat.hasFinishedReply)
                }
            }
            .onboardingEditorialReveal(delay: 650_000_000)

        }
        .padding(.horizontal, 24)
        .sensoryFeedback(.selection, trigger: chat.selectedProduct)
        .onAppear { viewModel.beginChatbotPreview() }
        .onDisappear { chat.cancelReply() }
    }

    private var thinking: some View {
        HStack(spacing: 8) {
            if reduceMotion {
                Image(systemName: "ellipsis")
            } else {
                PhaseAnimator([0, 1, 2]) { phase in
                    HStack(spacing: 5) {
                        ForEach(0..<3) { index in
                            Circle().fill(HomeStyle.blue)
                                .frame(width: 6, height: 6)
                                .opacity(phase == index ? 1 : 0.3)
                                .offset(y: phase == index ? -2 : 0)
                        }
                    }
                } animation: { _ in .easeInOut(duration: 0.25) }
            }
            Text("Jimmy menyiapkan contoh…").font(.caption)
        }
        .foregroundStyle(HomeStyle.body)
        .padding(14)
        .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 18))
        .onboardingCardShadow()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Jimmy menyiapkan contoh")
    }

    @ViewBuilder
    private func reply(for prompt: OnboardingChatPreviewViewModel.Prompt, steps: Int) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if prompt == .concept {
                bubble("Angka 2 mengalikan setiap suku di dalam kurung: x dan 4.")
                if steps >= 2 {
                    VStack(spacing: 14) {
                        HStack(spacing: 10) {
                            productButton("2 × x", index: 0)
                            productButton("2 × 4", index: 1)
                        }
                        MathExpressionView(
                            latex: chat.selectedProduct == 0 ? "2 \\times x = 2x" : "2 \\times 4 = 8",
                            accessibilityText: chat.selectedProduct == 0 ? "2 kali x sama dengan 2x" : "2 kali 4 sama dengan 8",
                            fontSize: 25
                        )
                        .id(chat.selectedProduct)
                        .transition(.opacity)
                        Text("Ketuk tiap perkalian untuk melihat bagiannya.")
                            .font(.caption)
                            .foregroundStyle(HomeStyle.body)
                    }
                    .padding(16)
                    .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 22))
                    .onboardingCardShadow()
                    .transition(entrance)
                }
                if steps >= 3 {
                    bubble("Hasilnya digabung menjadi 2x + 8. Ini yang disebut sifat distributif.")
                        .transition(entrance)
                }
            } else if prompt == .reasoning {
                bubble("2(x + 4), artinya ada dua kelompok yang masing-masing berisi x + 4.")
                if steps >= 2 {
                    MathExpressionView(
                        latex: "(x+4)+(x+4)=2x+8",
                        accessibilityText: "x tambah 4, ditambah x tambah 4, sama dengan 2x tambah 8",
                        fontSize: 24
                    )
                    .padding(16)
                    .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 22))
                    .onboardingCardShadow()
                    .transition(entrance)
                }
                if steps >= 3 {
                    bubble("Jadi, x muncul dua kali dan 4 juga muncul dua kali. Itu sebabnya keduanya dikalikan 2.")
                        .transition(entrance)
                }
            } else {
                bubble("Rethink mulai dari jawabanmu untuk mencari konsep yang mungkin perlu diperhatikan.")
                if steps >= 2 {
                    bubble("Untuk konsep yang didukung, ada penjelasan visual, contoh, dan latihan dengan panduan.")
                        .transition(entrance)
                }
                if steps >= 3 {
                    bubble("Chat ini memperlihatkan cara membahas konsep. Hasil pemahaman tetap perlu dilihat lewat soal mandiri.")
                        .transition(entrance)
                }
            }
        }
    }

    private func productButton(_ title: String, index: Int) -> some View {
        Button {
            withAnimation(motion) {
                chat.exploreProduct(index)
                if chat.canContinue { viewModel.useChatbot() }
            }
        } label: {
            HStack(spacing: 8) {
                MathExpressionView(
                    latex: index == 0 ? "2 \\times x" : "2 \\times 4",
                    accessibilityText: title,
                    fontSize: 22
                )
                Image(systemName: chat.exploredProducts.contains(index) ? "checkmark" : "hand.tap")
                    .foregroundStyle(HomeStyle.blue)
                    .symbolEffect(.pulse, options: .repeating, isActive: !reduceMotion && !chat.exploredProducts.contains(index))
            }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(HomeStyle.ink)
                .frame(maxWidth: .infinity, minHeight: 46)
                .background(chat.selectedProduct == index ? HomeStyle.powder : HomeStyle.sky, in: RoundedRectangle(cornerRadius: 14))
                .onboardingCardShadow()
                .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(chat.selectedProduct == index ? HomeStyle.blue : HomeStyle.line, lineWidth: 1))
        }
        .buttonStyle(GentlePressStyle())
        .accessibilityAddTraits(chat.selectedProduct == index ? .isSelected : [])
    }

    private func bubble(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(HomeStyle.ink)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(HomeStyle.powder, in: RoundedRectangle(cornerRadius: 22))
            .onboardingCardShadow()
    }
}
