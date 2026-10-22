import SwiftUI

struct LearningStepHeader: View {
    let stage: String
    let progress: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                BrandTag(text: stage, symbol: "sparkle", fill: HomeStyle.sky)
                Spacer()
                Text(progress)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(HomeStyle.body)
            }
            Text(title)
                .brandHeading(28)
                .accessibilityAddTraits(.isHeader)
        }
    }
}

struct LearningPrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(DarkCapsuleStyle())
    }
}

struct LearningCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) { content }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .brandSurface()
    }
}
