import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var catalogStore: CatalogStore
    @EnvironmentObject private var journeyStore: JourneyStore
    @Environment(\.dynamicTypeSize) private var typeSize
    let openExplore: () -> Void
    let openMap: () -> Void
    let openProfile: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                header
                introduction

                if let journey = journeyStore.journey, journey.selectedTopic != nil, journey.phase != .entry {
                    continueCard(journey)
                } else if let topic = catalogStore.subjects.flatMap(\.topics).first(where: { $0.id == "spl" && $0.availability == .available }) {
                    featuredTopic(topic)
                }

                catalogSection
                mapCard
                closingNote
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 28)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .refreshable {
            await viewModel.reload()
            await catalogStore.load()
            await journeyStore.load(auth: auth)
        }
    }

    private var header: some View {
        HStack(spacing: 7) {
            Image(systemName: "sparkles")
                .font(.system(size: 19, weight: .medium))
            Text("Rethink")
                .font(.system(size: 22, weight: .medium))
                .tracking(-0.9)
            Spacer()
            Button(action: openProfile) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 24, weight: .light))
                    .frame(width: 48, height: 48)
                    .background(.white.opacity(0.8), in: Circle())
            }
            .buttonStyle(GentlePressStyle())
            .accessibilityLabel("Buka profil")
        }
        .foregroundStyle(HomeStyle.ink)
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(viewModel.snapshot?.displayName.map { "Halo, \($0)." } ?? "Halo, pemikir hebat.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(HomeStyle.body)
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Bikin konsep")
                    Text("jadi klik.")
                        .foregroundStyle(HomeStyle.blue)
                }
                .brandHeading(37)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
                .frame(maxWidth: .infinity, alignment: .leading)
                if !typeSize.isAccessibilitySize {
                    BrandIllustration(name: "asset 13", size: 97, tilt: 9)
                }
            }
            Text("Sedikit rasa penasaran.\nSatu konsep yang lebih kamu pahami.")
                .font(.subheadline)
                .lineSpacing(4)
                .foregroundStyle(HomeStyle.body)
        }
        .padding(.top, 6)
    }

    private func featuredTopic(_ topic: TopicSummary) -> some View {
        NavigationLink {
            TopicOverviewView(topic: topic)
        } label: {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    BrandTag(text: "Mulai dari sini", symbol: "sparkle")
                    Spacer()
                    Text("01")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(HomeStyle.blue)
                }
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sistem\nPersamaan\nLinear")
                            .brandHeading(29)
                            .multilineTextAlignment(.leading)
                        Text("Aljabar · Pemeriksaan konsep")
                            .font(.caption)
                            .foregroundStyle(HomeStyle.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if !typeSize.isAccessibilitySize {
                        BrandIllustration(name: topic.illustrationName, size: 120, tilt: -8)
                    }
                }
                HStack {
                    Text("Yuk, kenali konsepnya")
                        .font(.subheadline.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 19)
                .padding(.vertical, 16)
                .background(HomeStyle.charcoal, in: Capsule())
            }
            .padding(24)
            .brandSurface(HomeStyle.powder)
        }
        .buttonStyle(GentlePressStyle())
        .accessibilityElement(children: .combine)
    }

    private func continueCard(_ journey: RemoteJourney) -> some View {
        NavigationLink {
            JourneyFlowView()
        } label: {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    BrandTag(text: "Lanjut dari sini", symbol: "arrow.turn.down.right")
                    Spacer()
                    BrandIllustration(name: "asset 04", size: 64, tilt: -7)
                }
                Text("Satu langkah\nlebih paham.")
                    .brandHeading(31)
                    .multilineTextAlignment(.leading)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sistem Persamaan Linear")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(HomeStyle.ink)
                    Text(phaseLabel(journey.phase))
                        .font(.subheadline)
                        .foregroundStyle(HomeStyle.body)
                }
                HStack {
                    Text(journey.phase == .validationResult || journey.phase == .reviewComplete ? "Lihat hasil belajarmu" : "Lanjutkan belajar")
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .padding(17)
                .background(HomeStyle.charcoal, in: Capsule())
            }
            .padding(24)
            .brandSurface(HomeStyle.powder)
        }
        .buttonStyle(GentlePressStyle())
    }

    private var catalogSection: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack(alignment: .center) {
                BrandSectionHeading(title: "Mau jelajah apa?")
                Spacer(minLength: 8)
                Button(action: openExplore) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.8), in: Circle())
                }
                .foregroundStyle(HomeStyle.ink)
                .accessibilityLabel("Lihat semua bidang matematika")
            }
            if catalogStore.isLoading && catalogStore.subjects.isEmpty {
                ProgressView("Memuat katalog...")
                    .frame(maxWidth: .infinity, minHeight: 160)
            } else if let message = catalogStore.errorMessage, catalogStore.subjects.isEmpty {
                VStack(spacing: 16) {
                    BrandEmptyState(illustration: "asset 02", title: "Belum terhubung", message: message)
                    Button("Coba lagi") { Task { await catalogStore.load() } }
                        .buttonStyle(DarkCapsuleStyle())
                }
            } else if catalogStore.subjects.count == 1, let subject = catalogStore.subjects.first {
                if subject.availability == .available {
                    NavigationLink { SubjectOverviewView(subject: subject) } label: { subjectRow(subject) }
                        .buttonStyle(GentlePressStyle())
                } else {
                    subjectRow(subject)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(catalogStore.subjects) { subject in
                            if subject.availability == .available {
                                NavigationLink { SubjectOverviewView(subject: subject) } label: {
                                    compactSubject(subject)
                                }
                                .buttonStyle(GentlePressStyle())
                            } else {
                                compactSubject(subject)
                            }
                        }
                    }
                    .padding(.bottom, 2)
                }
                .contentMargins(.trailing, 24)
            }
        }
    }

    private func subjectRow(_ subject: SubjectSummary) -> some View {
        HStack(spacing: 17) {
            if !typeSize.isAccessibilitySize {
                BrandIllustration(name: subject.illustrationName, size: 76, tilt: -8)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(subject.title).brandHeading(24)
                Text(subject.availability == .available ? "Jelajahi konsepnya" : "Belum tersedia")
                    .font(.subheadline)
                    .foregroundStyle(HomeStyle.body)
            }
            Spacer(minLength: 0)
            BrandArrow()
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .brandSurface(HomeStyle.lavender)
        .accessibilityElement(children: .combine)
    }

    private func compactSubject(_ subject: SubjectSummary) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Image(systemName: subject.availability == .available ? "arrow.up.right" : "lock")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(HomeStyle.body)
            }
            BrandIllustration(name: subject.illustrationName, size: 83, tilt: subject.id == "algebra" ? -8 : 6)
                .frame(maxWidth: .infinity)
            Text(subject.title).font(.headline.weight(.medium)).foregroundStyle(HomeStyle.ink)
            Text(subject.availability == .available ? "Jelajahi konsep" : "Belum tersedia")
                .font(.caption)
                .foregroundStyle(HomeStyle.body)
        }
        .padding(18)
        .frame(width: 153, alignment: .leading)
        .brandSurface(HomeStyle.subjectColor(subject.id), radius: 27)
        .accessibilityElement(children: .combine)
    }

    private var mapCard: some View {
        Button(action: openMap) {
            HStack(spacing: 12) {
                if !typeSize.isAccessibilitySize {
                    BrandIllustration(name: "asset 23", size: 80, tilt: -5)
                }
                VStack(alignment: .leading, spacing: 7) {
                    Text("Semua konsep,\nsaling terhubung.")
                        .brandHeading(22)
                    Text("Intip peta belajarmu")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(HomeStyle.body)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right")
                    .foregroundStyle(HomeStyle.ink)
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .brandSurface()
        }
        .buttonStyle(GentlePressStyle())
    }

    private var closingNote: some View {
        HStack(spacing: 7) {
            Image(systemName: "sparkle")
            Text("Paham itu proses. Nikmati setiap langkahnya.")
        }
        .font(.caption)
        .foregroundStyle(HomeStyle.body)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }

    private func phaseLabel(_ phase: RemotePhase) -> String {
        switch phase {
        case .entry: return "Pilih topik untuk memulai"
        case .diagnosis: return "Pemeriksaan konsep sedang berlangsung"
        case .diagnosticResult: return "Hasil pemeriksaanmu sudah tersedia"
        case .diagnosticDecisionPending: return "Hasil menunggu peninjauan"
        case .visual, .worked, .practice: return "Lanjutkan memahami Sifat Distributif"
        case .reviewComplete: return "Ulasan konsep telah selesai"
        case .retry, .transfer: return "Saatnya mencoba secara mandiri"
        case .validationResult: return "Lihat hasil validasi konsep"
        }
    }
}
