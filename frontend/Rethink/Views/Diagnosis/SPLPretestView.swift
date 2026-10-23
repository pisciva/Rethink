import SwiftUI
import AVFoundation

struct SPLPretestView: View {
    @StateObject private var model = SPLPretestViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var isAnswerFocused: Bool
    @State private var showExit = false
    @State private var showHelp = false
    @State private var audioEnabled = false
    @State private var narrator = AVSpeechSynthesizer()

    var body: some View {
        Group {
            if model.isComplete {
                completion
            } else {
                assessment
            }
        }
        .onChange(of: model.index) { _, _ in narrateQuestion() }
        .onChange(of: model.isComplete) { _, complete in
            if complete { narrator.stopSpeaking(at: .immediate) }
        }
        .onDisappear { narrator.stopSpeaking(at: .immediate) }
        .background(Color.white.ignoresSafeArea())
        .foregroundStyle(HomeStyle.ink)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .confirmationDialog("Keluar dari pre-test?", isPresented: $showExit, titleVisibility: .visible) {
            Button("Keluar", role: .destructive) { dismiss() }
            Button("Lanjut mengerjakan", role: .cancel) {}
        } message: {
            Text("Jawaban pada sesi ini belum dikirim dan akan hilang jika kamu keluar.")
        }
        .sheet(isPresented: $showHelp) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 20) {
                    Label("Jimmy", systemImage: "bubble.left.and.bubble.right")
                        .font(.title2.weight(.medium))
                    Text("Pilih satu jawaban terlebih dahulu. Setelah itu, Jimmy akan menanyakan alasan atau langkahmu.")
                    Text("Gunakan Kembali untuk meninjau jawaban sebelumnya. Jawabanmu tetap tersimpan selama sesi ini terbuka.")
                    Text("Selama pre-test, Jimmy tidak memberikan petunjuk matematika atau jawaban soal.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(24)
                .navigationTitle("Bantuan pre-test")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Tutup") { showHelp = false } } }
            }
            .presentationDetents([.medium, .large])
        }
    }

    private var assessment: some View {
        VStack(spacing: 0) {
            header
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        Color.clear.frame(height: 0).id("questionTop")
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Soal \(model.index + 1) dari \(model.questions.count)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(HomeStyle.body)
                            Text(model.question.prompt)
                                .font(.system(size: 20, weight: .medium))
                                .lineSpacing(5)
                                .fixedSize(horizontal: false, vertical: true)
                                .accessibilityAddTraits(.isHeader)
                        }
                        if !model.question.latex.isEmpty {
                            MathExpressionView(latex: model.question.latex, accessibilityText: model.question.spokenMath, fontSize: 29)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                        }
                        VStack(spacing: 10) {
                            ForEach(Array(model.question.options.enumerated()), id: \.offset) { index, option in
                                Button {
                                    isAnswerFocused = false
                                    model.select(option)
                                } label: {
                                    HStack(spacing: 14) {
                                        Text(String(UnicodeScalar(65 + index)!))
                                            .font(.system(size: 13, weight: .medium))
                                            .frame(width: 30, height: 30)
                                            .background(Color.black.opacity(0.05), in: Circle())
                                        Text(option)
                                            .font(.system(size: 17, weight: .medium))
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        if model.answers[model.index] == option {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(HomeStyle.blue)
                                        }
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(model.answers[model.index] == option ? HomeStyle.powder : Color.gray.opacity(0.04), in: RoundedRectangle(cornerRadius: 20))
                                    .overlay { RoundedRectangle(cornerRadius: 20).stroke(model.answers[model.index] == option ? HomeStyle.blue : Color.gray.opacity(0.15), lineWidth: 1) }
                                }
                                .buttonStyle(.plain)
                                .accessibilityAddTraits(model.answers[model.index] == option ? .isSelected : [])
                            }
                        }
                        if !model.answers[model.index].isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                Label("Jimmy", systemImage: "bubble.left")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Kamu memilih \(model.answers[model.index]). \(model.question.followUp)")
                                    .font(.system(size: 15))
                                    .lineSpacing(4)
                                TextField("Tulis alasan atau langkahmu…", text: $model.explanations[model.index], axis: .vertical)
                                    .font(.system(size: 16))
                                    .lineLimit(3...8)
                                    .focused($isAnswerFocused)
                                    .padding(16)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 18))
                                    .accessibilityLabel("Penjelasan jawaban soal \(model.index + 1)")
                            }
                            .padding(18)
                            .background(HomeStyle.sky, in: RoundedRectangle(cornerRadius: 24))
                            .id("followUp")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: model.index) { _, _ in proxy.scrollTo("questionTop", anchor: .top) }
                .onChange(of: model.answers[model.index]) { _, value in
                    if !value.isEmpty {
                        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                            proxy.scrollTo("followUp", anchor: .bottom)
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) { footer }
    }

    private var header: some View {
        HStack(spacing: 18) {
            Button {
                isAnswerFocused = false
                if model.index == 0 { showExit = true } else { model.back() }
            } label: {
                Image(systemName: model.index == 0 ? "xmark" : "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(HomeStyle.body)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(model.index == 0 ? "Keluar dari pre-test" : "Soal sebelumnya")
            ProgressView(value: Double(model.index), total: Double(model.questions.count))
                .tint(Color.green)
                .scaleEffect(x: 1, y: 2)
                .accessibilityLabel("Progres soal")
                .accessibilityValue("\(model.index) dari \(model.questions.count) soal dilewati")
                .animation(reduceMotion ? nil : .smooth(duration: 0.25), value: model.index)
            Button {
                audioEnabled.toggle()
                narrateQuestion()
            } label: {
                Image(systemName: audioEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.system(size: 21, weight: .regular))
                    .foregroundStyle(audioEnabled ? HomeStyle.ink : HomeStyle.body)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(audioEnabled ? "Matikan audio soal" : "Aktifkan audio soal")
            .accessibilityValue(audioEnabled ? "Aktif" : "Nonaktif")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func narrateQuestion() {
        narrator.stopSpeaking(at: .immediate)
        guard audioEnabled, !model.isComplete else { return }
        let question = model.question
        let utterance = AVSpeechUtterance(string: question.prompt + ". " + question.spokenMath)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        narrator.speak(utterance)
    }

    private var footer: some View {
        HStack(spacing: 16) {
            Button {
                isAnswerFocused = false
                showHelp = true
            } label: {
                Image("AppLogo")
                    .resizable().scaledToFit()
                    .frame(width: 52, height: 52)
                    .frame(width: 60, height: 60)
            }
            .accessibilityLabel("Buka bantuan Jimmy")
            Button {
                isAnswerFocused = false
                model.next()
            } label: {
                Text(model.index == model.questions.count - 1 ? "Selesai" : "Lanjut")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(model.canContinue ? HomeStyle.charcoal : Color.gray.opacity(0.45), in: Capsule())
                    .shadow(color: model.canContinue ? .black : .clear, radius: 0, y: 4)
            }
            .disabled(!model.canContinue)
            .buttonStyle(GentlePressStyle())
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(.white)
    }

    private var completion: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 55, weight: .light))
            Text("Jawabanmu sudah lengkap")
                .font(.system(size: 26, weight: .medium))
                .multilineTextAlignment(.center)
            Text("\(model.completedCount) jawaban tercatat dalam sesi ini. Penilaian diagnosis dan follow-up AI belum terhubung, jadi belum ada hasil pemahaman yang ditetapkan.")
                .font(.subheadline)
                .foregroundStyle(HomeStyle.body)
                .multilineTextAlignment(.center)
            Button("Tinjau jawaban") { model.review() }
                .buttonStyle(DarkCapsuleStyle())
            NavigationLink("Lihat pilihan materi") { LinearSystemsSelectionView() }
                .font(.subheadline.weight(.medium))
            Button("Tutup") { dismiss() }.foregroundStyle(HomeStyle.body)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack { SPLPretestView() }
}
