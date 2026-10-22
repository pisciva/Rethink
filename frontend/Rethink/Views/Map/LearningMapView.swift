import SwiftUI

struct LearningMapView: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var catalog: CatalogStore
    @EnvironmentObject private var journeyStore: JourneyStore
    @EnvironmentObject private var navigation: AppNavigationViewModel
    @State private var selectedLayer: MapLayer = .explore

    private enum MapLayer: String, CaseIterable {
        case explore = "Jelajah"
        case focus = "Fokus"
        case progress = "Hasil"
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                BrandPageHeading(
                    eyebrow: "Peta belajarmu",
                    title: "Semuanya\nsaling terhubung.",
                    subtitle: "Lihat hubungan antarkonsep dan temukan posisi belajarmu.",
                    illustration: "asset 23"
                )

                Picker("Tampilan peta", selection: $selectedLayer) {
                    ForEach(MapLayer.allCases, id: \.self) { layer in
                        Text(layer.rawValue).tag(layer)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityHint("Pilih relasi konsep, fokus diagnosis, atau hasil validasi.")

                if hasSupportedRelationship {
                    conceptDiagram
                } else {
                    BrandEmptyState(illustration: "asset 23", title: "Petanya sedang dimuat", message: "Relasi konsep akan muncul setelah katalog terhubung.")
                    if !catalog.isLoading {
                        Button("Muat ulang peta") { Task { await catalog.load() } }
                            .buttonStyle(DarkCapsuleStyle())
                    }
                }

                layerExplanation

                if let error = journeyStore.errorMessage, !journeyStore.resetRequired {
                    Text(error).font(.subheadline).foregroundStyle(.red)
                }

                if let journey = journeyStore.journey, journey.selectedTopic != nil {
                    NavigationLink { JourneyFlowView() } label: {
                        HStack {
                            Image(systemName: "book.closed")
                            Text("Buka sesi belajarmu")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(HomeStyle.ink)
                        .padding(22)
                        .brandSurface()
                    }
                    .buttonStyle(GentlePressStyle())
                } else {
                    LearningPrimaryButton(title: "Mulai dari katalog") { navigation.selectedTab = .explore }
                }
            }
            .padding(24)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle("Peta belajar")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if catalog.catalog == nil { await catalog.load() }
            if journeyStore.journey == nil && !journeyStore.resetRequired { await journeyStore.load(auth: auth) }
        }
        .refreshable {
            await catalog.load()
            await journeyStore.load(auth: auth)
        }
    }

    private var hasSupportedRelationship: Bool {
        catalog.catalog?.relationships.contains {
            $0.from == "distribution" && $0.to == "spl" && $0.kind == "prerequisite"
        } == true
    }

    private var conceptDiagram: some View {
        VStack(spacing: 0) {
            HStack {
                Text("ALJABAR")
                    .font(.caption2.weight(.semibold))
                    .tracking(1.6)
                Spacer()
                Image(systemName: "point.3.connected.trianglepath.dotted")
            }
            .foregroundStyle(HomeStyle.blue)
            .padding(.bottom, 22)

            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    Image(systemName: "function")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundStyle(HomeStyle.blue)
                        .frame(width: 48, height: 48)
                        .background(HomeStyle.powder, in: RoundedRectangle(cornerRadius: 17))
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Sifat Distributif").brandHeading(21)
                        Text("Konsep prasyarat").font(.caption).foregroundStyle(HomeStyle.body)
                    }
                }
                if selectedLayer == .focus && journeyStore.journey?.map.focus == "distribution" && !journeyStore.resetRequired {
                    BrandTag(text: "Fokus pemulihan", symbol: "scope", fill: HomeStyle.lavender)
                } else if selectedLayer == .progress, let state = journeyStore.journey?.map.progress, !journeyStore.resetRequired {
                    BrandTag(text: stateLabel(state), symbol: "doc.text.magnifyingglass", fill: HomeStyle.mint)
                }
            }
            .padding(21)
            .frame(maxWidth: .infinity)
            .brandSurface(.white, radius: 25)
            .overlay(RoundedRectangle(cornerRadius: 25).strokeBorder(selectedLayer == .focus && journeyStore.journey?.map.focus != nil ? HomeStyle.blue.opacity(0.6) : .clear, lineWidth: 1.5))

            VStack(spacing: 0) {
                Rectangle().fill(HomeStyle.blue.opacity(0.35)).frame(width: 1.5, height: 22)
                Text("prasyarat untuk")
                    .font(.caption)
                    .foregroundStyle(HomeStyle.body)
                    .padding(.vertical, 7)
                Image(systemName: "arrow.down")
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(HomeStyle.blue)
                    .padding(.bottom, 13)
            }
            .accessibilityHidden(true)

            HStack(spacing: 14) {
                BrandIllustration(name: "asset 33", size: 62, tilt: -5)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Sistem Persamaan Linear").brandHeading(20)
                    Text("Topik yang didukung").font(.caption).foregroundStyle(HomeStyle.body)
                }
                Spacer(minLength: 0)
            }
            .padding(19)
            .frame(maxWidth: .infinity, alignment: .leading)
            .brandSurface(.white, radius: 25)
        }
        .padding(22)
        .brandSurface(HomeStyle.powder.opacity(0.55))
        .accessibilityElement(children: .combine)
        .accessibilityHint("Sifat Distributif adalah prasyarat terkurasi untuk Sistem Persamaan Linear.")
    }

    private var layerExplanation: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 9) {
                Image(systemName: layerSymbol)
                    .foregroundStyle(HomeStyle.blue)
                Text(layerTitle).brandHeading(22)
            }
            Text(layerText)
                .font(.subheadline)
                .lineSpacing(5)
                .foregroundStyle(HomeStyle.body)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .brandSurface()
    }

    private var layerSymbol: String {
        switch selectedLayer {
        case .explore: "point.3.connected.trianglepath.dotted"
        case .focus: "scope"
        case .progress: "doc.text.magnifyingglass"
        }
    }

    private var layerTitle: String {
        switch selectedLayer {
        case .explore: "Kenali hubungannya"
        case .focus: "Fokus yang tepat"
        case .progress: "Hasil dari usahamu"
        }
    }

    private var layerText: String {
        if selectedLayer == .explore {
            return "Sifat Distributif membantu penyelesaian SPL. Hubungan ini adalah peta konsep terkurasi, bukan penilaian atas kemampuanmu."
        }
        if journeyStore.resetRequired { return "Sesi perlu dimulai ulang sebelum hasil belajarmu dapat ditampilkan." }
        guard let journey = journeyStore.journey else { return "Belum ada hasil. Mulai dari katalog dan kenali konsepmu lewat pemeriksaan singkat." }
        if selectedLayer == .focus {
            switch journey.diagnosticOutcome {
            case .confirmed: return "Bukti pemeriksaan mendukung Sifat Distributif sebagai fokus pemulihan konsepmu. Kamu bisa melanjutkan ke pembelajaran terpandu."
            case .rejected: return "Dugaan hambatan Sifat Distributif tidak terkonfirmasi pada pemeriksaan ini. Kamu tetap dapat meninjau konsep secara opsional."
            case .uncertain: return "Bukti belum cukup untuk menentukan hambatan konsep. Kamu dapat meninjau Sifat Distributif secara opsional."
            case .none: return "Fokus muncul setelah pemeriksaan selesai. Belum ada kesimpulan tentang hambatan konsepmu."
            }
        }
        switch journey.map.progress {
        case .understood: return "Understood: penerapan mandiri dan transfer Sifat Distributif berhasil pada tugas yang diuji. Hasil ini tidak menyatakan penguasaan seluruh SPL."
        case .proceduralOnly: return "Procedural Only: penerapan mandiri berhasil, tetapi transfer belum berhasil. Kamu dapat kembali mempelajari konsep."
        case .needsReinforcement: return "Needs Reinforcement: pengerjaan mandiri belum berhasil. Ulangi pembelajaran untuk menguatkan konsep sebelum mencoba lagi."
        case .none: return "Belum ada hasil validasi Sifat Distributif. Selesai membaca materi saja belum menjadi bukti pemahaman."
        }
    }

    private func stateLabel(_ state: RemoteLearnerState) -> String {
        switch state {
        case .understood: "Dipahami pada uji ini"
        case .proceduralOnly: "Prosedur berhasil"
        case .needsReinforcement: "Perlu penguatan"
        }
    }
}
