import SwiftUI
import SwiftMath
import UIKit

/// Native LaTeX rendering. Keep an equivalent plain-text label for VoiceOver.
struct MathExpressionView: View {
    let latex: String
    let accessibilityText: String
    @ScaledMetric(relativeTo: .title2) private var fontSize: CGFloat = 28
    var centered: Bool

    init(latex: String, accessibilityText: String, fontSize: CGFloat = 28, centered: Bool = true) {
        self.latex = latex
        self.accessibilityText = accessibilityText
        self._fontSize = ScaledMetric(wrappedValue: fontSize, relativeTo: .title2)
        self.centered = centered
    }

    var body: some View {
        VStack(alignment: centered ? .center : .leading, spacing: 12) {
            ForEach(Array(latex.components(separatedBy: "\n").enumerated()), id: \.offset) { _, line in
                NativeMathLabel(latex: line, fontSize: fontSize, centered: centered)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }
}

private struct NativeMathLabel: UIViewRepresentable {
    let latex: String
    let fontSize: CGFloat
    let centered: Bool

    final class Coordinator {
        var availableWidth: CGFloat?
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> MTMathUILabel {
        let label = MTMathUILabel()
        label.backgroundColor = .clear
        label.contentInsets = .init(top: 6, left: 4, bottom: 6, right: 4)
        label.isAccessibilityElement = false
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }

    func updateUIView(_ label: MTMathUILabel, context: Context) {
        let normalized = latex
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "×", with: "\\times ")
            .replacingOccurrences(of: "÷", with: "\\div ")
        if label.latex != normalized { label.latex = normalized }
        label.labelMode = .display
        label.textAlignment = centered ? .center : .left
        label.textColor = UIColor(HomeStyle.ink)
        fit(label, to: context.coordinator.availableWidth)
        label.invalidateIntrinsicContentSize()
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: MTMathUILabel, context: Context) -> CGSize? {
        let width = proposal.width.flatMap { $0.isFinite && $0 > 0 ? $0 : nil }
        context.coordinator.availableWidth = width
        fit(uiView, to: width)
        let size = uiView.intrinsicContentSize
        return CGSize(width: width ?? ceil(size.width), height: ceil(size.height) + 2)
    }

    private func fit(_ label: MTMathUILabel, to width: CGFloat?) {
        label.fontSize = fontSize
        guard let width else { return }
        let naturalWidth = label.intrinsicContentSize.width
        let insets = label.contentInsets.left + label.contentInsets.right
        guard naturalWidth > width, naturalWidth > insets else { return }
        let ratio = max(1, width - insets - 2) / (naturalWidth - insets)
        label.fontSize = fontSize * ratio
    }
}
