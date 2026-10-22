import SwiftUI

struct OnboardingQuickCheckScene: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var advanceTask: Task<Void, Never>?
    @State private var isTransitioning = false
    @Namespace private var cardMotion
    @State private var showEditPicker = false

    private let items = OnboardingQuickCheckItem.examples
    private var finished: Bool { viewModel.quickCheckIndex == items.count }
    private var motion: Animation? { reduceMotion ? nil : .smooth(duration: 0.52, extraBounce: 0) }

    var body: some View {
        GeometryReader { geometry in
            let historyHeight = min(170, max(120, geometry.size.height * 0.26))
            let cardHeight = max(200, min(300, geometry.size.height - historyHeight - 100))
            VStack(spacing: 14) {
                if finished {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(items) { item in summary(item) }
                            confirmation.padding(.top, 8)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 18)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, -24)
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 14) {
                                VStack(alignment: .leading, spacing: 12) {
                                    introduction
                                    ForEach(items) { item in
                                        if item.id < viewModel.quickCheckIndex {
                                            summary(item)
                                        }
                                    }
                                }
                                .frame(minHeight: historyHeight, alignment: .bottom)

                                VStack(spacing: 14) {
                                    question(items[viewModel.quickCheckIndex], height: cardHeight)
                                        .id(viewModel.quickCheckIndex)
                                        .transition(reduceMotion ? .opacity : .asymmetric(
                                            insertion: .opacity.combined(with: .offset(y: 14)),
                                            removal: .opacity
                                        ))
                                    choices
                                    Spacer(minLength: 0)
                                }
                                .frame(minHeight: max(0, geometry.size.height - historyHeight - 46), alignment: .top)
                                Color.clear.frame(height: 16).id("question-tail")
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        }
                        .scrollIndicators(.hidden)
                        .defaultScrollAnchor(.bottom, for: .sizeChanges)
                        .padding(.horizontal, -24)
                        .task(id: viewModel.quickCheckIndex) {
                            guard viewModel.quickCheckIndex > 0 else { return }
                            await Task.yield()
                            guard !Task.isCancelled else { return }
                            var transaction = Transaction(animation: nil)
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                proxy.scrollTo("question-tail", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, 24)
        .confirmationDialog("Pilih soal yang ingin diubah", isPresented: $showEditPicker, titleVisibility: .visible) {
            ForEach(items) { item in
                Button("Soal \(item.id + 1)") {
                    withAnimation(motion) { viewModel.editFamiliarity(at: item.id) }
                }
            }
            Button("Batal", role: .cancel) {}
        }
        .sensoryFeedback(.selection, trigger: viewModel.familiarityAnswers)
        .onDisappear {
            advanceTask?.cancel()
            isTransitioning = false
        }
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Aku punya 5 contoh soal. Apakah kamu bisa mengerjakannya?")
            .font(.body)
            .foregroundStyle(HomeStyle.ink)
            .fixedSize(horizontal: false, vertical: true)
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(HomeStyle.powder, in: RoundedRectangle(cornerRadius: 24))
                    .onboardingCardShadow()
    }
    }

    private func question(_ item: OnboardingQuickCheckItem, height: CGFloat) -> some View {
        VStack(spacing: 22) {
            Text(item.prompt)
                .font(.headline.weight(.medium))
                .accessibilityAddTraits(.isHeader)
            MathExpressionView(latex: item.latex, accessibilityText: item.expression, fontSize: 30)
        }
        .foregroundStyle(HomeStyle.ink)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 22)
        .padding(.vertical, 58)
        .frame(maxWidth: .infinity, minHeight: height, alignment: .center)
        .overlay(alignment: .topLeading) {
            Text("\(item.id + 1) dari \(items.count)")
                .font(.caption.weight(.medium))
                .foregroundStyle(HomeStyle.body)
                .padding(22)
        }
        .background {
            RoundedRectangle(cornerRadius: 26)
                .fill(viewModel.familiarityAnswers[item.id].map { wash($0) } ?? HomeStyle.paper)
                .onboardingCardShadow()
                .matchedGeometryEffect(id: item.id, in: cardMotion)
        }
    }

    private func summary(_ item: OnboardingQuickCheckItem) -> some View {
        Button {
            guard !isTransitioning else { return }
            advanceTask?.cancel()
            withAnimation(motion) { viewModel.editFamiliarity(at: item.id) }
        } label: {
            HStack(spacing: 12) {
                Text("\(item.id + 1)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(HomeStyle.body)
                MathExpressionView(latex: item.latex, accessibilityText: item.expression, fontSize: 18, centered: false)
                Spacer(minLength: 0)
                if let answer = viewModel.familiarityAnswers[item.id] {
                    Image(systemName: answer.symbol)
                        .font(.caption.weight(.bold))
                        .frame(width: 26, height: 26)
                        .background(wash(answer), in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .foregroundStyle(HomeStyle.ink)
            .padding(14)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .fill(HomeStyle.paper)
                    .onboardingCardShadow()
                    .matchedGeometryEffect(id: item.id, in: cardMotion)
            }
        }
        .buttonStyle(GentlePressStyle())
        .accessibilityLabel("Contoh \(item.id + 1), \(item.prompt), pilihan \(viewModel.familiarityAnswers[item.id]?.title ?? ""). Ketuk untuk mengubah.")
    }

    private var choices: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingFamiliarity.allCases) { choice in
                let selected = viewModel.familiarityAnswers[viewModel.quickCheckIndex] == choice
                Button { answer(choice) } label: {
                    HStack(spacing: 7) {
                        Image(systemName: choice.symbol)
                            .font(.caption.weight(.bold))
                            .frame(width: 22, height: 22)
                            .background(selected ? Color.clear : wash(choice), in: RoundedRectangle(cornerRadius: 7))
                        Text(choice.title).font(.subheadline.weight(.medium))
                    }
                    .foregroundStyle(HomeStyle.ink)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(HomeStyle.paper)
                        if selected {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(wash(choice))

                        }
                    }
                    .onboardingCardShadow()
                    .scaleEffect(selected && !reduceMotion ? 1.025 : 1)
                }
                .buttonStyle(GentlePressStyle())
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
        .allowsHitTesting(!isTransitioning)
        .accessibilityElement(children: .contain)
    }

    private var confirmation: some View {
        VStack(spacing: 18) {
            HStack(spacing: 12) {
                Image("JimmyMascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 88)
                    .accessibilityHidden(true)
                Text("Pilihan sudah sesuai semua?")
                    .font(.headline.weight(.medium))
                    .foregroundStyle(HomeStyle.ink)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(HomeStyle.powder, in: RoundedRectangle(cornerRadius: 22))
                    .onboardingCardShadow()
            }

            HStack(spacing: 12) {
                reviewButton("Edit pilihan", symbol: "slider.horizontal.3") {
                    showEditPicker = true
                }
                reviewButton("Ulangi semua", symbol: "arrow.counterclockwise") {
                    withAnimation(motion) { viewModel.resetFamiliarity() }
                }
            }
            .disabled(isTransitioning)
        }
    }

    private func reviewButton(_ title: String, symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 9) {
                Image(systemName: symbol)
                    .font(.system(size: 19, weight: .semibold))
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundStyle(HomeStyle.ink)
            .frame(maxWidth: .infinity, minHeight: 82)
            .background(HomeStyle.paper, in: RoundedRectangle(cornerRadius: 20))
            .onboardingCardShadow()
            .contentShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(GentlePressStyle())
    }

    private func answer(_ choice: OnboardingFamiliarity) {
        guard !isTransitioning else { return }
        advanceTask?.cancel()
        isTransitioning = true
        let index = viewModel.quickCheckIndex
        withAnimation(reduceMotion ? nil : .smooth(duration: 0.22)) {
            viewModel.recordFamiliarity(choice)
        }
        advanceTask = Task { @MainActor in
            defer { isTransitioning = false }
            do { try await Task.sleep(nanoseconds: 360_000_000) }
            catch { return }
            guard !Task.isCancelled else { return }
            withAnimation(motion) { viewModel.advanceQuickCheck(from: index) }
            // Keep repeated taps from interrupting the card-to-history transition.
            try? await Task.sleep(nanoseconds: 520_000_000)
        }
    }

    private func wash(_ choice: OnboardingFamiliarity) -> Color {
        switch choice {
        case .notYet: Color("OnboardingNotYet")
        case .unsure: Color("OnboardingUnsure")
        case .familiar: HomeStyle.mint
        }
    }
}
