import SwiftUI

/// Full-page presentation only. The parent owns navigation and retry behavior.
struct EmptyStateView: View {
    let kind: EmptyStateKind
    let onPrimaryAction: () -> Void
    var onSecondaryAction: (() -> Void)? = nil
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 27) {
                    artwork(size: typeSize.isAccessibilitySize ? 140 : min(geometry.size.width * 0.57, 230))
                    VStack(spacing: 18) {
                        BrandTag(text: kind.label, symbol: kind.symbol, fill: .white.opacity(0.85))
                        Text(kind.title)
                            .brandHeading(34)
                            .accessibilityAddTraits(.isHeader)
                        Text(kind.message)
                            .font(.body)
                            .foregroundStyle(HomeStyle.body)
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 430)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height, alignment: .center)
            }
        }
        .background(HomeStyle.sky.ignoresSafeArea())
        .navigationTitle(kind.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 10) {
                Button(action: onPrimaryAction) {
                    HStack(spacing: 11) {
                        Text(kind.actionTitle)
                        Image(systemName: isRetry ? "arrow.clockwise" : "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(DarkCapsuleStyle())
                if let onSecondaryAction {
                    Button("Kembali", action: onSecondaryAction)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(HomeStyle.body)
                        .frame(minHeight: 44)
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 16)
            .padding(.bottom, 22)
            .frame(maxWidth: 540)
            .frame(maxWidth: .infinity)
            .background(HomeStyle.sky)
        }
        .preferredColorScheme(.light)
    }

    private var isRetry: Bool {
        kind == .connectionLost || kind == .catalogUnavailable
    }

    private var wash: Color {
        switch kind {
        case .noLearning: HomeStyle.powder
        case .noAssessment: HomeStyle.lavender
        case .catalogUnavailable: HomeStyle.butter
        case .connectionLost: HomeStyle.peach
        }
    }

    private func artwork(size: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(wash.opacity(0.65))
                .frame(width: size * 1.05, height: size * 0.82)
                .rotationEffect(.degrees(-17))
            BrandIllustration(name: kind.illustration, size: size * 0.92, tilt: -7)
            Image(systemName: "sparkle")
                .font(.system(size: 25, weight: .light))
                .foregroundStyle(HomeStyle.blue.opacity(0.65))
                .offset(x: -size * 0.49, y: -size * 0.25)
            Circle()
                .fill(.white)
                .frame(width: 13, height: 13)
                .offset(x: size * 0.45, y: -size * 0.34)
            Image(systemName: kind.symbol)
                .font(.system(size: 19, weight: .light))
                .foregroundStyle(HomeStyle.blue)
                .frame(width: 47, height: 47)
                .background(.white, in: Circle())
                .offset(x: size * 0.4, y: size * 0.34)
        }
        .frame(width: size * 1.15, height: size * 1.12)
        .accessibilityHidden(true)
    }
}

#Preview("Belum ada sesi") {
    NavigationStack {
        EmptyStateView(kind: .noLearning, onPrimaryAction: {})
    }
}

#Preview("Belum ada hasil") {
    NavigationStack {
        EmptyStateView(kind: .noAssessment, onPrimaryAction: {})
    }
}

#Preview("Katalog kosong") {
    NavigationStack {
        EmptyStateView(kind: .catalogUnavailable, onPrimaryAction: {}, onSecondaryAction: {})
    }
}

#Preview("Koneksi terputus") {
    NavigationStack {
        EmptyStateView(kind: .connectionLost, onPrimaryAction: {}, onSecondaryAction: {})
    }
}
