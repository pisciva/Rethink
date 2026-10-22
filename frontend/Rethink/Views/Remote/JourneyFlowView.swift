import SwiftUI

struct JourneyFlowView: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var journeyStore: JourneyStore
    @EnvironmentObject private var navigation: AppNavigationViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showResetConfirmation = false

    var body: some View {
        Group {
            if let question = journeyStore.journey?.currentQuestion, !journeyStore.resetRequired {
                RemoteQuestionCard(question: question).id(question.id)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        if let presentation = journeyStore.journey?.presentation, !journeyStore.resetRequired {
                            JourneyProgressView(presentation: presentation)
                        }
                        if journeyStore.isLoading && journeyStore.journey == nil {
                            ProgressView("Membuka sesi belajarmu...")
                                .frame(maxWidth: .infinity, minHeight: 250)
                        } else if journeyStore.resetRequired {
                            resetCard
                        } else if let journey = journeyStore.journey {
                            phaseContent(journey)
                        } else {
                            emptyCard
                        }
                        if let feedback = journeyStore.feedback {
                            Label(feedback, systemImage: "text.bubble")
                                .font(.subheadline)
                                .foregroundStyle(HomeStyle.blue)
                                .padding(18)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .brandSurface(HomeStyle.powder, radius: 22)
                        }
                        JourneyErrorNotice()
                        draftNotice
                    }
                    .padding(24)
                    .frame(maxWidth: 640)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .task {
            if journeyStore.journey == nil && !journeyStore.resetRequired {
                await journeyStore.load(auth: auth)
            }
        }
        .confirmationDialog("Mulai ulang sesi belajar?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("Mulai ulang", role: .destructive) { Task { await journeyStore.reset(auth: auth) } }
            Button("Batal", role: .cancel) {}
        } message: {
            Text("Jawaban dan kemajuan sesi saat ini akan diganti dengan sesi baru.")
        }
    }

    private var navigationTitle: String {
        switch journeyStore.journey?.phase {
        case .visual, .worked, .practice: "Belajar konsep"
        case .retry, .transfer: "Coba mandiri"
        case .validationResult, .diagnosticResult: "Hasil belajarmu"
        default: "Pemeriksaan konsep"
        }
    }

    private var draftNotice: some View {
        Label("Versi uji coba · soal dan penilaian masih ditinjau", systemImage: "info.circle")
            .font(.caption)
            .foregroundStyle(HomeStyle.body)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 6)
    }

    private var resetCard: some View {
        LearningCard {
            LearningStepHeader(stage: "Sesi", progress: "", title: "Sesi lama perlu dimulai ulang")
            Text("Materi atau aturan sesi telah berubah, atau bukti tersimpan tidak dapat dilanjutkan. Mulai sesi baru untuk melanjutkan pemeriksaan.")
                .font(.system(size: 15))
                .foregroundStyle(HomeStyle.body)
            LearningPrimaryButton(title: "Mulai ulang sesi") {
                showResetConfirmation = true
            }
            Button("Kembali") { dismiss() }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
                .frame(maxWidth: .infinity)
        }
    }

    private var emptyCard: some View {
        LearningCard {
            LearningStepHeader(stage: "Pemeriksaan", progress: "", title: "Belum ada sesi")
            Text("Pilih Sistem Persamaan Linear dari katalog untuk memulai pemeriksaan.")
                .font(.system(size: 15))
                .foregroundStyle(HomeStyle.body)
            Button("Kembali") { dismiss() }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
                .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func phaseContent(_ journey: RemoteJourney) -> some View {
        switch journey.phase {
        case .entry:
            entryCard
        case .diagnosticDecisionPending:
            pendingCard(journey)
        case .diagnosticResult:
            resultCard(
                stage: "Hasil pemeriksaan",
                title: diagnosticTitle(journey.diagnosticOutcome),
                explanation: journey.resultExplanation,
                actions: journey.availableActions,
                showMap: true
            )
        case .visual, .worked:
            learningContentCard(journey)
        case .reviewComplete:
            resultCard(
                stage: "Ulasan selesai",
                title: "Ulasan konsep selesai",
                explanation: journey.resultExplanation,
                actions: [],
                showMap: true
            )
        case .validationResult:
            resultCard(
                stage: "Hasil validasi",
                title: learnerTitle(journey.learnerState),
                explanation: journey.resultExplanation,
                actions: journey.availableActions,
                showMap: true
            )
        case .diagnosis, .practice, .retry, .transfer:
            emptyCard
        }
    }

    private var entryCard: some View {
        LearningCard {
            LearningStepHeader(stage: "Pemeriksaan", progress: "", title: "Mulai pemeriksaan konsep")
            Text("Pemeriksaan akan berfokus pada Sifat Distributif dalam konteks Sistem Persamaan Linear.")
                .font(.system(size: 15))
                .foregroundStyle(HomeStyle.body)
            LearningPrimaryButton(title: "Mulai pemeriksaan") {
                Task { await journeyStore.selectTopic("spl", auth: auth) }
            }
            .disabled(!journeyStore.canMutate)
        }
    }

    private func pendingCard(_ journey: RemoteJourney) -> some View {
        LearningCard {
            BrandIllustration(name: "asset 02", size: 115, tilt: -6)
                .frame(maxWidth: .infinity)
            LearningStepHeader(stage: "Hasil pemeriksaan", progress: "", title: "Sesi perlu dimulai ulang")
            Text("Aturan sesi ini telah diperbarui. Mulai ulang pemeriksaan untuk melanjutkan.")
                .font(.system(size: 15))
                .foregroundStyle(HomeStyle.body)
            LearningPrimaryButton(title: "Mulai ulang pemeriksaan") {
                showResetConfirmation = true
            }
            Button("Kembali") { dismiss() }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
                .frame(maxWidth: .infinity)
        }
    }

    private func learningContentCard(_ journey: RemoteJourney) -> some View {
        LearningCard {
            if let content = journey.learningContent {
                LearningStepHeader(
                    stage: "Belajar konsep",
                    progress: journey.phase == .visual ? "Tahap 1 dari 3" : "Tahap 2 dari 3",
                    title: content.title
                )
                if content.kind == "visual" {
                    if let explanation = content.explanation {
                        Text(explanation)
                            .font(.body)
                            .lineSpacing(5)
                            .foregroundStyle(HomeStyle.body)
                    }
                    if let groups = content.groups, let terms = content.termsPerGroup {
                        DistributionGroupsView(groups: groups, terms: terms)
                    }
                    if let result = content.resultTerms {
                        Label(result.joined(separator: " + "), systemImage: "equal")
                            .font(.system(.title, design: .rounded, weight: .medium))
                            .foregroundStyle(HomeStyle.ink)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .brandSurface(HomeStyle.mint, radius: 22)
                            .accessibilityLabel("Hasil setara: \(result.joined(separator: " ditambah "))")
                    }
                } else {
                    if let problem = content.problem {
                        Text(problem)
                            .font(.system(.title2, design: .rounded, weight: .medium))
                            .foregroundStyle(HomeStyle.ink)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .brandSurface(HomeStyle.powder, radius: 22)
                    }
                    ForEach(Array((content.steps ?? []).enumerated()), id: \.element.id) { index, step in
                        HStack(alignment: .top, spacing: 13) {
                            Text("\(index + 1)")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(HomeStyle.blue)
                                .frame(width: 30, height: 30)
                                .background(HomeStyle.powder, in: Circle())
                            VStack(alignment: .leading, spacing: 9) {
                                MathExpressionView(latex: step.expression, accessibilityText: step.expression, fontSize: 22, centered: false)
                                Text(step.reason)
                                    .font(.subheadline)
                                    .lineSpacing(4)
                                    .foregroundStyle(HomeStyle.body)
                            }
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            } else {
                Text("Materi belum tersedia.")
                    .foregroundStyle(HomeStyle.body)
            }

            ForEach(actionValues(journey.availableActions), id: \.rawValue) { action in
                LearningPrimaryButton(title: actionLabel(action)) {
                    Task { await journeyStore.perform(action, auth: auth) }
                }
                .disabled(!journeyStore.canMutate)
            }
        }
    }

    private func resultCard(
        stage: String,
        title: String,
        explanation: String?,
        actions: [String],
        showMap: Bool
    ) -> some View {
        LearningCard {
            BrandIllustration(name: stage == "Hasil pemeriksaan" ? "asset 02" : "asset 13", size: 125, tilt: -6)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            LearningStepHeader(stage: stage, progress: "", title: title)
            if let explanation {
                Text(explanation)
                    .font(.system(size: 16))
                    .foregroundStyle(HomeStyle.body)
            }
            Text("Hasil ini berlaku untuk konsep yang diuji, bukan penguasaan seluruh Sistem Persamaan Linear.")
                .font(.system(size: 13))
                .foregroundStyle(HomeStyle.muted)

            if let journey = journeyStore.journey, journey.phase == .validationResult,
               let evidence = journey.presentation?.validation {
                ValidationEvidenceView(evidence: evidence)
            }
            if let journey = journeyStore.journey {
                ConceptAchievementView(journey: journey)
            }

            ForEach(actionValues(actions), id: \.rawValue) { action in
                LearningPrimaryButton(title: actionLabel(action)) {
                    Task { await journeyStore.perform(action, auth: auth) }
                }
                .disabled(!journeyStore.canMutate)
            }

            if showMap {
                LearningPrimaryButton(title: "Lihat Peta Belajar") {
                    navigation.selectedTab = .map
                    dismiss()
                }
            }

            Button("Jelajahi katalog") {
                dismiss()
                navigation.showCatalog()
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(HomeStyle.blue)
            .frame(maxWidth: .infinity, minHeight: 44)

            Button("Kembali") { dismiss() }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(HomeStyle.blue)
                .frame(maxWidth: .infinity)

            if !actions.contains(RemoteAction.reset.rawValue) {
                Button("Mulai ulang sesi") {
                    showResetConfirmation = true
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(HomeStyle.muted)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func actionValues(_ values: [String]) -> [RemoteAction] {
        values.compactMap(RemoteAction.init(rawValue:))
    }

    private func actionLabel(_ action: RemoteAction) -> String {
        switch action {
        case .advance: return "Lanjutkan"
        case .startRecovery: return "Pelajari Sifat Distributif"
        case .startReview: return "Tinjau konsep secara opsional"
        case .reinforce: return "Ulangi pembelajaran"
        case .reset: return "Mulai ulang sesi"
        case .selectTopic: return "Mulai pemeriksaan"
        case .startValidation: return "Mulai validasi"
        case .submit: return "Kirim jawaban"
        }
    }

    private func diagnosticTitle(_ outcome: RemoteDiagnosticOutcome?) -> String {
        switch outcome {
        case .confirmed: return "Dugaan hambatan terkonfirmasi"
        case .rejected: return "Dugaan tidak terkonfirmasi"
        case .uncertain: return "Bukti belum cukup"
        case .none: return "Hasil pemeriksaan"
        }
    }

    private func learnerTitle(_ state: RemoteLearnerState?) -> String {
        switch state {
        case .understood: return "Dipahami pada uji ini"
        case .proceduralOnly: return "Prosedur bisa, transfer belum"
        case .needsReinforcement: return "Perlu penguatan"
        case .none: return "Hasil validasi"
        }
    }
}

private struct DistributionGroupsView: View {
    let groups: Int
    let terms: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(groups) kelompok yang sama")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(HomeStyle.blue)

            ForEach(0..<min(groups, 6), id: \.self) { index in
                HStack(spacing: 10) {
                    Text("\(index + 1)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(HomeStyle.blue)
                        .frame(width: 28, height: 28)
                        .background(HomeStyle.powder, in: Circle())

                    HStack(spacing: 9) {
                        ForEach(Array(terms.enumerated()), id: \.offset) { termIndex, term in
                            if termIndex > 0 {
                                Text("+")
                                    .foregroundStyle(HomeStyle.body)
                            }
                            Text(term)
                                .font(.system(.title2, design: .rounded, weight: .medium))
                                .foregroundStyle(HomeStyle.ink)
                                .frame(maxWidth: .infinity, minHeight: 58)
                                .brandSurface(termIndex == 0 ? HomeStyle.lavender : HomeStyle.butter, radius: 15)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Kelompok \(index + 1): \(terms.joined(separator: " ditambah "))")
            }
            Text("Setiap kelompok berisi suku yang sama; pengali berlaku untuk semuanya.")
                .font(.caption)
                .lineSpacing(3)
                .foregroundStyle(HomeStyle.body)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .brandSurface(HomeStyle.sky, radius: 24)
    }
}

private struct JourneyErrorNotice: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var journeyStore: JourneyStore

    var body: some View {
        if let error = journeyStore.errorMessage, !journeyStore.resetRequired {
            VStack(alignment: .leading, spacing: 12) {
                Label(error, systemImage: "exclamationmark.circle")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                Button("Muat ulang kemajuan") { Task { await journeyStore.load(auth: auth) } }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(HomeStyle.blue)
                    .frame(minHeight: 44)
                    .disabled(journeyStore.isLoading || journeyStore.isWorking)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .brandSurface()
            .accessibilityElement(children: .contain)
        }
    }
}

private struct RemoteQuestionCard: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var journeyStore: JourneyStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let question: RemoteQuestion
    @State private var answer = ""
    @State private var selectedOptionID: String?
    @State private var showResetConfirmation = false
    @FocusState private var isAnswerFocused: Bool

    private var submittedAnswer: String {
        question.format == .choice ? (selectedOptionID ?? "") : answer
    }

    private var canSubmit: Bool {
        !submittedAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && submittedAnswer.count <= (question.format == .explanation ? 1200 : 160)
            && journeyStore.canMutate
            && !(journeyStore.journey?.availableActions.contains("reset") ?? false)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                if let presentation = journeyStore.journey?.presentation {
                    JourneyProgressView(presentation: presentation)
                }
                HStack(alignment: .center) {
                    BrandTag(text: stageLabel, symbol: question.role == "practice" ? "pencil" : "magnifyingglass", fill: .white)
                    Spacer(minLength: 8)
                    Text(roleLabel)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(HomeStyle.body)
                        .multilineTextAlignment(.trailing)
                }
                VStack(alignment: .leading, spacing: 23) {
                    Text(question.prompt).brandHeading(26).accessibilityAddTraits(.isHeader)
                    if let math = question.math {
                        VStack(alignment: .leading, spacing: 13) {
                            Text("SOAL")
                                .font(.caption2.weight(.semibold))
                                .tracking(1.7)
                                .foregroundStyle(HomeStyle.blue)
                            Text(math)
                                .font(.system(.title2, design: .rounded, weight: .medium))
                                .foregroundStyle(HomeStyle.ink)
                                .lineSpacing(8)
                                .textSelection(.enabled)
                        }
                        .padding(22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .brandSurface(HomeStyle.powder.opacity(0.65), radius: 24)
                    }
                    answerInput
                    Text(formatHint)
                        .font(.caption)
                        .foregroundStyle(HomeStyle.body)
                        .lineSpacing(3)
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .brandSurface()

                JourneyErrorNotice()
                if journeyStore.journey?.availableActions.contains("reset") == true {
                    Text("Batas teknis jawaban sesi ini tercapai. Ini bukan hasil penilaian matematika.")
                        .font(.subheadline)
                        .foregroundStyle(HomeStyle.body)
                    Button("Mulai ulang sesi") { showResetConfirmation = true }
                        .buttonStyle(DarkCapsuleStyle())
                        .disabled(!journeyStore.canMutate)
                }
                if question.role == "practice", let feedback = journeyStore.feedback {
                    Label(feedback, systemImage: "text.bubble")
                        .font(.subheadline)
                        .foregroundStyle(HomeStyle.blue)
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .brandSurface(HomeStyle.powder, radius: 22)
                        .accessibilityAddTraits(.updatesFrequently)
                }
                if question.role.hasPrefix("q") {
                    Label("Jawab sesuai pemahamanmu. Hasil muncul setelah pemeriksaan selesai.", systemImage: "lock.open")
                        .font(.caption)
                        .lineSpacing(3)
                        .foregroundStyle(HomeStyle.body)
                        .padding(.horizontal, 4)
                }
                Text("Versi uji coba · soal dan penilaian masih ditinjau")
                    .font(.caption2)
                    .foregroundStyle(HomeStyle.body)
                    .frame(maxWidth: .infinity)
            }
            .padding(24)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .confirmationDialog("Mulai ulang sesi belajar?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("Mulai ulang", role: .destructive) { Task { await journeyStore.reset(auth: auth) } }
            Button("Batal", role: .cancel) {}
        } message: {
            Text("Jawaban dan kemajuan sesi saat ini akan diganti dengan sesi baru.")
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                isAnswerFocused = false
                Task { await journeyStore.submit(questionId: question.id, answer: submittedAnswer, auth: auth) }
            } label: {
                HStack(spacing: 10) {
                    if journeyStore.isWorking { ProgressView().tint(.white) }
                    Text(journeyStore.isWorking ? "Menyimpan jawaban..." : "Kirim jawaban")
                    if !journeyStore.isWorking { Image(systemName: "arrow.right") }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(DarkCapsuleStyle())
            .disabled(!canSubmit)
            .padding(.horizontal, 24)
            .padding(.top, 14)
            .padding(.bottom, 12)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
            .background(HomeStyle.sky.opacity(0.98))
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Selesai") { isAnswerFocused = false }.tint(HomeStyle.blue)
            }
        }
    }

    @ViewBuilder
    private var answerInput: some View {
        switch question.format {
        case .choice:
            VStack(spacing: 11) {
                ForEach(question.options ?? []) { option in
                    Button {
                        withAnimation(reduceMotion ? nil : .easeOut(duration: 0.18)) { selectedOptionID = option.id }
                    } label: {
                        HStack(spacing: 13) {
                            Text(option.id.uppercased())
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(selectedOptionID == option.id ? .white : HomeStyle.body)
                                .frame(width: 35, height: 35)
                                .background(selectedOptionID == option.id ? HomeStyle.blue : .white, in: Circle())
                            Text(option.text)
                                .font(.body)
                                .foregroundStyle(HomeStyle.ink)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if selectedOptionID == option.id {
                                Image(systemName: "circle.inset.filled")
                                    .font(.system(size: 15))
                                    .foregroundStyle(HomeStyle.blue)
                                    .accessibilityHidden(true)
                            }
                        }
                        .padding(15)
                        .frame(minHeight: 66)
                        .brandSurface(selectedOptionID == option.id ? HomeStyle.sky : Color.white, radius: 21)
                        .overlay(RoundedRectangle(cornerRadius: 21).strokeBorder(selectedOptionID == option.id ? HomeStyle.blue : HomeStyle.line, lineWidth: selectedOptionID == option.id ? 1.5 : 1))
                    }
                    .buttonStyle(GentlePressStyle())
                    .accessibilityAddTraits(selectedOptionID == option.id ? .isSelected : [])
                    .disabled(journeyStore.isWorking)
                }
            }
        case .explanation:
            VStack(alignment: .leading, spacing: 10) {
                Text("Ceritakan alasanmu").font(.subheadline.weight(.medium)).foregroundStyle(HomeStyle.ink)
                TextEditor(text: $answer)
                    .font(.body)
                    .autocorrectionDisabled()
                    .foregroundStyle(HomeStyle.ink)
                    .frame(minHeight: 150)
                    .padding(13)
                    .scrollContentBackground(.hidden)
                    .brandSurface(.white, radius: 20)
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(isAnswerFocused ? HomeStyle.blue : HomeStyle.line, lineWidth: 1))
                    .overlay(alignment: .topLeading) {
                        if answer.isEmpty {
                            Text("Menurutku, karena...")
                                .font(.body)
                                .foregroundStyle(HomeStyle.body.opacity(0.65))
                                .padding(18)
                                .padding(.top, 3)
                                .allowsHitTesting(false)
                        }
                    }
                    .focused($isAnswerFocused)
                    .accessibilityLabel("Penjelasan jawaban")
                Text("\(answer.count)/1200 karakter")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(answer.count > 1200 ? .red : HomeStyle.body)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        case .number, .expression:
            VStack(alignment: .leading, spacing: 10) {
                Text("Jawabanmu").font(.subheadline.weight(.medium)).foregroundStyle(HomeStyle.ink)
                TextField(question.format == .number ? "Tulis bilangan di sini" : "Tulis ekspresi di sini", text: $answer)
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .foregroundStyle(HomeStyle.ink)
                    .keyboardType(question.format == .number ? .numbersAndPunctuation : .asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .onSubmit { isAnswerFocused = false }
                    .padding(20)
                    .brandSurface(.white, radius: 20)
                    .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(isAnswerFocused ? HomeStyle.blue : HomeStyle.line, lineWidth: 1))
                    .focused($isAnswerFocused)
                    .accessibilityLabel("Jawaban matematika")
            }
        }
    }

    private var stageLabel: String {
        switch question.role {
        case "practice": "Latihan terbimbing"
        case "retry": "Uji mandiri"
        case "transfer": "Soal transfer"
        default: "Kenali konsep"
        }
    }

    private var roleLabel: String {
        switch question.role {
        case "q1-target": "Soal inti 1 dari 3"
        case "q2-application": "Soal inti 2 dari 3"
        case "q3-reasoning": "Soal inti 3 dari 3"
        case "q4-trace": "1 soal tambahan"
        case "practice": "Latihan"
        case "retry": "Penerapan mandiri"
        case "transfer": "Penerapan konteks baru"
        default: ""
        }
    }

    private var formatHint: String {
        switch question.role {
        case "q2-application", "retry", "transfer": "Tuliskan ekspresi setara dalam bentuk tanpa tanda kurung."
        case "q4-trace", "practice": "Masukkan satu bilangan."
        case "q3-reasoning": "Jelaskan alasan matematikanya secara singkat."
        default: "Pilih satu jawaban yang paling sesuai."
        }
    }
}
