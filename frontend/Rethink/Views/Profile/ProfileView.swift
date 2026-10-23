import SwiftUI
import PhotosUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject private var auth: AuthStore
    @EnvironmentObject private var journeyStore: JourneyStore
    @State private var showResetConfirmation = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoError: String?
    @State private var isLoadingPhoto = false
    @AppStorage("rethink.profile.avatar") private var avatar = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 16) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        VStack(spacing: 10) {
                            ProfileAvatar(size: 112)
                            Text(isLoadingPhoto ? "Menyiapkan foto…" : "Ubah foto profil")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(HomeStyle.blue)
                        }
                    }
                    .disabled(isLoadingPhoto)
                    .accessibilityLabel("Pilih foto profil")
                    if let photoError {
                        Text(photoError).font(.caption).foregroundStyle(.red)
                    }
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
        .background(HomeStyle.background.ignoresSafeArea())
        .toolbar(.visible, for: .navigationBar)
        .navigationTitle("Profil")
        .task(id: selectedPhoto) {
            guard let selectedPhoto else { return }
            isLoadingPhoto = true
            photoError = nil
            defer { isLoadingPhoto = false }
            do {
                guard let data = try await selectedPhoto.loadTransferable(type: Data.self),
                      let image = UIImage(data: data), image.size.width > 0, image.size.height > 0 else {
                    photoError = "Foto belum bisa dibuka. Pilih foto lain."
                    return
                }
                guard !Task.isCancelled else { return }
                let side: CGFloat = 256
                let scale = max(side / image.size.width, side / image.size.height)
                let format = UIGraphicsImageRendererFormat()
                format.scale = 1
                let thumbnail = UIGraphicsImageRenderer(size: CGSize(width: side, height: side), format: format).image { _ in
                    let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
                    image.draw(in: CGRect(x: (side - size.width) / 2, y: (side - size.height) / 2, width: size.width, height: size.height))
                }
                if let jpeg = thumbnail.jpegData(compressionQuality: 0.8) {
                    avatar = jpeg.base64EncodedString()
                } else {
                    photoError = "Foto belum bisa disimpan. Coba foto lain."
                }
            } catch {
                guard !Task.isCancelled else { return }
                photoError = "Foto belum bisa dimuat. Coba lagi."
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Mulai ulang sesi belajar?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("Mulai ulang", role: .destructive) { Task { await journeyStore.reset(auth: auth) } }
            Button("Batal", role: .cancel) {}
        } message: {
            Text(journeyStore.journey?.version == 3
                 ? "Pemeriksaan dan konteks belajar akan dimulai ulang. Riwayat asesmen akhir SPL tetap disimpan."
                 : "Jawaban dan kemajuan sesi saat ini akan diganti dengan sesi baru.")
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
        case .finalAssessment: "Asesmen akhir SPL sedang berlangsung"
        case .finalResult: "Hasil asesmen akhir SPL tersedia"
        }
    }
}
