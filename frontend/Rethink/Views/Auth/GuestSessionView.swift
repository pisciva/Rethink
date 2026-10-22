import SwiftUI

struct GuestSessionView: View {
    @EnvironmentObject private var auth: AuthStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                HStack(spacing: 7) {
                    Image(systemName: "sparkles")
                    Text("Rethink").tracking(-0.8)
                }
                .font(.system(size: 23, weight: .medium))
                .foregroundStyle(HomeStyle.ink)
                .padding(.top, 28)

                ZStack {
                    Circle().fill(HomeStyle.powder.opacity(0.6)).frame(width: 230, height: 230)
                    BrandIllustration(name: "asset 04", size: 205, tilt: -9)
                    BrandIllustration(name: "asset 07", size: 90, tilt: 12).offset(x: 110, y: 80)
                    Image(systemName: "sparkle")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(HomeStyle.blue.opacity(0.6))
                        .offset(x: -115, y: -70)
                }
                .frame(height: 290)
                .accessibilityHidden(true)

                VStack(spacing: 16) {
                    Text("Mulai dengan\nrasa penasaran.").brandHeading(38)
                    Text("Kenali konsepmu, pelajari perlahan,\ndan temukan momen ‘oh, begitu!’.")
                        .font(.body)
                        .lineSpacing(5)
                        .foregroundStyle(HomeStyle.body)
                }
                .multilineTextAlignment(.center)

                VStack(spacing: 15) {
                    Button { Task { await auth.ensureSession() } } label: {
                        HStack(spacing: 10) {
                            if auth.isWorking { ProgressView().tint(.white) }
                            Text(auth.isWorking ? "Menyiapkan ruang belajarmu..." : "Yuk, mulai belajar")
                            if !auth.isWorking { Image(systemName: "arrow.right") }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(DarkCapsuleStyle())
                    .disabled(auth.isWorking)
                    Text("Tanpa email. Tanpa password. Langsung belajar.")
                        .font(.caption)
                        .foregroundStyle(HomeStyle.body)
                    if !AppConfig.isConfigured {
                        Text("Ruang belajar belum siap. Hubungi pengelola aplikasi untuk mengaktifkannya.")
                            .font(.subheadline).foregroundStyle(HomeStyle.body)
                    }
                    if let error = auth.errorMessage {
                        Text(error).font(.subheadline).foregroundStyle(.red)
                    }
                }
                .multilineTextAlignment(.center)
            }
            .padding(28)
            .padding(.bottom, 20)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .background(HomeStyle.sky.ignoresSafeArea())
    }
}
