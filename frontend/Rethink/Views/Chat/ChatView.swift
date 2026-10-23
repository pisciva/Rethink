import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model = ChatViewModel()
    @FocusState private var isTyping: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showOptions = false
    @State private var showHistory = false

    private let suggestions: [(title: String, icon: String, color: Color, prompt: String)] = [
        ("Belajar\naljabar", "map", .purple, "Aku ingin belajar aljabar."),
        ("Bahas\nsoal latihan", "pencil.and.outline", .blue, "Bantu aku membahas soal latihan."),
        ("Siapkan\npemahaman", "target", .green, "Aku ingin memahami Sifat Distributif."),
        ("Belajar\nSPLDV", "function", .orange, "Bantu aku belajar SPLDV.")
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if model.messages.isEmpty {
                    welcome(height: geometry.size.height)
                } else {
                    conversation
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded { isTyping = false }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 24)
                    .onChanged { value in
                        if isTyping && value.translation.height > 36 && value.translation.height > abs(value.translation.width) {
                            isTyping = false
                        }
                    }
            )
        }
        .onDisappear { model.stop() }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                Button {
                    isTyping = false
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .accessibilityLabel("Kembali")
                Spacer()
                HStack(spacing: 2) {
                    Button {
                        isTyping = false
                        model.reset()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Percakapan baru")
                    Button {
                        isTyping = false
                        showHistory = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Riwayat percakapan")
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 5)
                .glassEffect(.regular.interactive(), in: .capsule)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            composer
                .padding(.horizontal, isTyping ? 12 : 40)
                .padding(.top, 12)
                // Resting composer sits lower, like the floating tab bar.
                // Keyboard spacing stays positive and is independent of resting placement.
                .padding(.bottom, isTyping ? 12 : -10)
        }
        .background(Color.white.ignoresSafeArea())
        .foregroundStyle(HomeStyle.ink)
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityHidden(showHistory)
        .overlay {
            GeometryReader { geometry in
                ZStack(alignment: .trailing) {
                    if showHistory {
                        Color.black.opacity(0.14)
                            .ignoresSafeArea()
                            .onTapGesture { showHistory = false }
                            .accessibilityLabel("Tutup riwayat")
                            .accessibilityAddTraits(.isButton)
                            .transition(.opacity)
                        ChatHistoryPanel(model: model, isPresented: $showHistory)
                            .frame(width: min(geometry.size.width * 0.86, 380))
                            .frame(maxHeight: .infinity)
                            .background {
                                UnevenRoundedRectangle(topLeadingRadius: 44, bottomLeadingRadius: 44)
                                    .fill(.white)
                                    .ignoresSafeArea(.container, edges: .vertical)
                            }
                            .shadow(color: .black.opacity(0.12), radius: 24, x: -8)
                            .gesture(
                                DragGesture(minimumDistance: 24)
                                    .onEnded { value in
                                        if value.translation.width > 65 && value.translation.width > abs(value.translation.height) {
                                            showHistory = false
                                        }
                                    }
                            )
                            .transition(.move(edge: .trailing))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .animation(reduceMotion ? nil : .spring(response: 0.38, dampingFraction: 0.92), value: showHistory)
        .confirmationDialog("Percakapan", isPresented: $showOptions, titleVisibility: .visible) {
            Button("Percakapan baru", role: .destructive) { model.reset() }
            Button("Batal", role: .cancel) {}
        } message: {
            Text("Chat masih berupa simulasi. Lampiran dan pesan suara belum tersedia.")
        }
    }

    private func welcome(height: CGFloat) -> some View {
        ViewThatFits(in: .vertical) {
            welcomeContent(height: height)
            ScrollView(showsIndicators: false) {
                welcomeContent(height: max(height, 340))
            }
        }
    }

    private func welcomeContent(height: CGFloat) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 12)
            Text("Mau belajar apa\nhari ini?")
                .font(.system(size: 27, weight: .medium))
                .tracking(-0.7)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .padding(.horizontal, 24)
            suggestionScene
                .frame(height: min(270, max(200, height * 0.48)))
                .padding(.top, 28)
            Spacer(minLength: 12)
        }
    }

    private var suggestionScene: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, 430)
            let cardWidth = width * 0.37
            let cardHeight = cardWidth * 0.72
            ZStack {
                suggestionCard(1, width: cardWidth, height: cardHeight)
                    .scaleEffect(0.82)
                    .opacity(0.32)
                    .blur(radius: 1.4)
                    .offset(x: -width * 0.12, y: -68)
                    .accessibilityHidden(true)
                    .allowsHitTesting(false)
                suggestionCard(3, width: cardWidth, height: cardHeight)
                    .scaleEffect(0.86)
                    .opacity(0.38)
                    .blur(radius: 1)
                    .offset(x: width * 0.27, y: -40)
                    .accessibilityHidden(true)
                    .allowsHitTesting(false)

                Image("AppLogo")
                    .resizable().scaledToFit()
                    .frame(width: width * 0.34, height: width * 0.36)
                    .offset(y: -30)
                    .accessibilityHidden(true)

                suggestionCard(0, width: cardWidth, height: cardHeight)
                    .offset(x: -width * 0.245, y: 34)
                suggestionCard(2, width: cardWidth, height: cardHeight)
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.green.opacity(0.55), lineWidth: 1)
                    }
                    .shadow(color: .green.opacity(0.15), radius: 12, y: 10)
                    .offset(x: width * 0.19, y: 65)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .accessibilityElement(children: .contain)
    }

    private func suggestionCard(_ index: Int, width: CGFloat, height: CGFloat) -> some View {
        let suggestion = suggestions[index]
        return Button {
            model.draft = suggestion.prompt
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) { model.send() }
            isTyping = false
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: suggestion.icon)
                    .font(.system(size: 21, weight: .medium))
                    .foregroundStyle(suggestion.color)
                Spacer(minLength: 0)
                Text(suggestion.title)
                    .font(.system(size: 15, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(HomeStyle.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(17)
            .frame(width: width, height: height, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.07), radius: 9, y: 3)
        }
        .buttonStyle(GentlePressStyle())
        .accessibilityLabel(suggestion.title.replacingOccurrences(of: "\n", with: " "))
    }

    private var conversation: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 18) {
                        ForEach(model.messages) { message in
                            HStack {
                                if message.isUser { Spacer(minLength: 44) }
                                Text(message.text)
                                    .font(.system(size: 15))
                                    .lineSpacing(4)
                                    .textSelection(.enabled)
                                    .padding(16)
                                    .background(message.isUser ? Color.gray.opacity(0.08) : Color.white, in: RoundedRectangle(cornerRadius: 22))
                                if !message.isUser { Spacer(minLength: 24) }
                            }
                        }
                        if model.isResponding {
                            HStack(spacing: 8) {
                                ProgressView().controlSize(.small)
                                Text("Jimmy menyiapkan balasan simulasi…")
                                    .font(.caption)
                                    .foregroundStyle(HomeStyle.body)
                                Spacer()
                            }
                            .accessibilityElement(children: .combine)
                        }
                        Color.clear.frame(height: 1).id("bottom")
                    }
                    .padding(20)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: model.messages.count) { _, _ in
                    withAnimation(reduceMotion ? nil : .easeOut(duration: 0.25)) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
        }
    }

    private var composer: some View {
        ZStack(alignment: .bottomLeading) {
            // Animate geometry, never replace/reparent the focused TextField.
            messageField
                .padding(.leading, isTyping ? 8 : 48)
                .padding(.trailing, isTyping ? 8 : 104)
                .padding(.top, isTyping ? 8 : 0)
                .padding(.bottom, isTyping ? 42 : 0)
                .frame(minHeight: isTyping ? 82 : 44, alignment: .topLeading)
            HStack(spacing: 10) {
                Button { showOptions = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .light))
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Opsi percakapan")
                Spacer(minLength: 0)
                Button { showOptions = true } label: {
                    Image(systemName: "mic")
                        .font(.system(size: 22))
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Pesan suara, belum tersedia")
                Button {
                    if model.isResponding {
                        model.stop()
                    } else if model.canSend {
                        isTyping = false
                        model.send()
                    } else {
                        showOptions = true
                    }
                } label: {
                    Image(systemName: model.isResponding ? "stop.fill" : (model.canSend ? "arrow.up" : "waveform"))
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(model.canSend ? HomeStyle.ink : Color.purple, in: Circle())
                }
                .accessibilityLabel(model.isResponding ? "Hentikan balasan" : (model.canSend ? "Kirim pertanyaan" : "Mode suara, belum tersedia"))
            }
        }
        .foregroundStyle(HomeStyle.ink)
        .padding(.horizontal, 12)
        .padding(.vertical, isTyping ? 10 : 5)
        // iOS 26: native Liquid Glass on the control layer only.
        .glassEffect(.regular, in: .rect(cornerRadius: isTyping ? 28 : 27))
        .animation(reduceMotion ? nil : .spring(response: 0.38, dampingFraction: 0.9), value: isTyping)
    }

    private var messageField: some View {
        TextField("Tanya Jimmy…", text: $model.draft, axis: .vertical)
            .font(.system(size: 16))
            .lineLimit(1...(isTyping ? 5 : 1))
            .frame(minHeight: 44, alignment: isTyping ? .topLeading : .leading)
            .focused($isTyping)
            .accessibilityLabel("Pertanyaan untuk Jimmy")
    }

}

#Preview {
    NavigationStack { ChatView() }
}
