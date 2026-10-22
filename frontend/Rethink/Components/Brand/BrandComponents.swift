import SwiftUI

private struct BrandHeadingStyle: ViewModifier {
    @ScaledMetric private var size: CGFloat = 32

    init(size: CGFloat) {
        _size = ScaledMetric(wrappedValue: size, relativeTo: .title)
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .medium))
            .tracking(-size * 0.035)
            .foregroundStyle(HomeStyle.ink)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    func brandHeading(_ size: CGFloat = 32) -> some View {
        modifier(BrandHeadingStyle(size: size))
    }

    func brandSurface(_ color: Color = HomeStyle.paper, radius: CGFloat = 32) -> some View {
        background(color, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

struct BrandTag: View {
    let text: String
    var symbol: String? = nil
    var color: Color = HomeStyle.blue
    var fill: Color = .white.opacity(0.7)

    var body: some View {
        HStack(spacing: 5) {
            if let symbol { Image(systemName: symbol) }
            Text(text)
        }
        .font(.caption.weight(.medium))
        .foregroundStyle(color)
        .padding(.horizontal, 11)
        .padding(.vertical, 7)
        .background(fill, in: Capsule())
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct BrandIllustration: View {
    let name: String
    var size: CGFloat = 140
    var tilt: Double = 0

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .rotationEffect(.degrees(tilt))
            .accessibilityHidden(true)
    }
}

struct BrandPageHeading: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let eyebrow: String
    let title: String
    let subtitle: String
    var illustration: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(eyebrow.uppercased())
                    .font(.caption2.weight(.semibold))
                    .tracking(1.8)
                    .foregroundStyle(HomeStyle.blue)
                Spacer()
                Image(systemName: "sparkle")
                    .foregroundStyle(HomeStyle.blue.opacity(0.5))
                    .accessibilityHidden(true)
            }
            HStack(alignment: .center, spacing: 4) {
                Text(title)
                    .brandHeading(35)
                    .accessibilityAddTraits(.isHeader)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let illustration, !typeSize.isAccessibilitySize {
                    BrandIllustration(name: illustration, size: 88, tilt: 6)
                }
            }
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(HomeStyle.body)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 12)
    }
}

struct BrandSectionHeading: View {
    let title: String
    var detail: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).brandHeading(23).accessibilityAddTraits(.isHeader)
            if let detail {
                Text(detail).font(.subheadline).foregroundStyle(HomeStyle.body)
            }
        }
    }
}

struct BrandEmptyState: View {
    let illustration: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            BrandIllustration(name: illustration, size: 108)
            Text(title).brandHeading(24)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(HomeStyle.body)
                .lineSpacing(4)
        }
        .multilineTextAlignment(.center)
        .padding(28)
        .frame(maxWidth: .infinity)
        .brandSurface()
    }
}

struct BrandArrow: View {
    var filled = false

    var body: some View {
        Image(systemName: "arrow.up.right")
            .font(.system(size: 17, weight: .medium))
            .foregroundStyle(filled ? .white : HomeStyle.ink)
            .frame(width: 42, height: 42)
            .background(filled ? HomeStyle.charcoal : .white.opacity(0.65), in: Circle())
            .accessibilityHidden(true)
    }
}
