import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var journeyStore: JourneyStore
    @State private var showResetConfirmation = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 16) {
                    BrandIllustration(name: "asset 35", size: 150, tilt: -7)
                        .padding(20)
                        .background(Circle().fill(HomeStyle.powder.opacity(0.6)))
                    Text("Ruang belajarmu.").brandHeading(34)
                    Text("Setiap pemahaman dimulai\ndari rasa ingin tahu.")
                        .font(.subheadline)
                        .lineSpacing(4)
                        .foregroundStyle(HomeStyle.body)
                        .multilineTextAlignment(.center)
                    BrandTag(text: auth.isAnonymous ? "Penjelajah tamu" : "Akun Rethink", symbol: "person.crop.circle", fill: .white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)

                VStack(alignment: .leading, spacing: 20) {
                    BrandSectionHeading(title: "Sesi belajarmu")
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 21, weight: .light))
                            .frame(width: 45, height: 45)
                            .background(HomeStyle.powder, in: RoundedRectangle(cornerRadius: 15))
                        VStack(alignment: .leading, spacing: 6) {
                            Text(journeyStore.journey?.selectedTopic == nil ? "Lembaran baru" : "Sistem Persamaan Linear")
                                .font(.headline.weight(.medium))
                                .foregroundStyle(HomeStyle.ink)
                            Text(journeyStore.journey.map { phaseLabel($0.phase) } ?? "Siap untuk mulai belajar")
                                .font(.subheadline)
                                .foregroundStyle(HomeStyle.body)
                        }
                    }
                    if journeyStore.journey?.selectedTopic != nil {
                        NavigationLink { JourneyFlowView() } label: {
                            Label("Buka sesi belajar", systemImage: "arrow.right").labelStyle(TextThenIconStyle())
                        }
                        .buttonStyle(DarkCapsuleStyle())
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .brandSurface()

                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 23, weight: .light))
                        .foregroundStyle(HomeStyle.blue)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tersimpan untukmu").font(.headline.weight(.medium)).foregroundStyle(HomeStyle.ink)
                        Text("Kemajuan tersimpan dengan sesi di perangkat ini. Sesi tamu tidak dapat dipulihkan jika aplikasi dihapus atau data perangkat dibersihkan.")
                            .font(.subheadline)
                            .lineSpacing(4)
                            .foregroundStyle(HomeStyle.body)
                    }
                }
                .padding(24)
                .brandSurface(HomeStyle.powder.opacity(0.5))

                if let error = journeyStore.errorMessage {
                    Text(error).font(.subheadline).foregroundStyle(.red)
                    if journeyStore.requiresReload {
                        Button("Muat ulang kemajuan") { Task { await journeyStore.load(auth: auth) } }
                            .buttonStyle(DarkCapsuleStyle())
                            .disabled(journeyStore.isLoading || journeyStore.isWorking)
                    }
                }

                Button { showResetConfirmation = true } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Mulai ulang sesi belajar")
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption)
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(HomeStyle.body)
                    .padding(22)
                    .brandSurface()
                }
                .buttonStyle(GentlePressStyle())
                .disabled(!journeyStore.canMutate)

                Text("Rethink · Satu konsep, satu langkah.")
                    .font(.caption)
                    .foregroundStyle(HomeStyle.body)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .padding(24)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Mulai ulang sesi belajar?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("Mulai ulang", role: .destructive) { Task { await journeyStore.reset(auth: auth) } }
            Button("Batal", role: .cancel) {}
        } message: {
            Text("Jawaban dan kemajuan sesi saat ini akan diganti dengan sesi baru.")
        }
    }

    private func phaseLabel(_ phase: RemotePhase) -> String {
        switch phase {
        case .entry: "Siap untuk mulai belajar"
        case .diagnosis: "Pemeriksaan konsep sedang berlangsung"
        case .diagnosticResult: "Hasil pemeriksaan tersedia"
        case .diagnosticDecisionPending: "Hasil menunggu peninjauan"
        case .visual, .worked, .practice: "Sedang memahami konsep"
        case .reviewComplete: "Ulasan konsep selesai"
        case .retry, .transfer: "Sedang mencoba secara mandiri"
        case .validationResult: "Hasil validasi tersedia"
        }
    }
}
