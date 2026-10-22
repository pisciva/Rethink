import SwiftUI

struct CatalogCategoryItem: Identifiable {
    let id: String
    let title: String
    let image: String
}

struct CatalogCategoryStrip: View {
    var title: String = "Materi"
    let items: [CatalogCategoryItem]
    let selectedID: String?
    let onSelect: (String) -> Void
    @Namespace private var selection
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(HomeStyle.body)
                .padding(.horizontal, 22)
                .padding(.top, 12)
                .accessibilityAddTraits(.isHeader)
            ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(items) { item in
                        let selected = item.id == selectedID
                        Button { onSelect(item.id) } label: {
                            VStack(spacing: 12) {
                                Image(item.image)
                                    .resizable().scaledToFit()
                                    .frame(width: 56, height: 56)
                                    .scaleEffect(selected && !reduceMotion ? 1.06 : 1)
                                    .animation(reduceMotion ? nil : .smooth(duration: 0.3), value: selected)
                                    .padding(.vertical, 9)
                                    .frame(maxWidth: .infinity)
                                    .background(selected ? HomeStyle.lavender.opacity(0.55) : Color.white, in: RoundedRectangle(cornerRadius: 18))
                                    .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(selected ? HomeStyle.blue : HomeStyle.line, lineWidth: selected ? 2 : 1.5))
                                Text(item.title)
                                    .font(.subheadline.weight(.medium))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(minHeight: 38, alignment: .top)
                                ZStack {
                                    Capsule().fill(.clear)
                                    if selected {
                                        Capsule().fill(HomeStyle.blue)
                                            .matchedGeometryEffect(id: "underline", in: selection)
                                    }
                                }
                                .frame(height: 4)
                            }
                            .foregroundStyle(HomeStyle.ink)
                            .frame(width: 112)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(GentlePressStyle())
                        .accessibilityAddTraits(selected ? .isSelected : [])
                        .id(item.id)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 8)
            }
            .onChange(of: selectedID) { _, id in
                guard let id else { return }
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                    proxy.scrollTo(id, anchor: .center)
                }
            }
        }
        }
        .background(Color.white)
    }
}

enum CatalogNavigationLevel: Equatable {
    case material, subtopic, lesson

    var title: String {
        switch self {
        case .material: "Materi"
        case .subtopic: "Subtopik"
        case .lesson: "Bagian belajar"
        }
    }
    var symbol: String {
        switch self {
        case .material: "square.grid.2x2"
        case .subtopic: "folder"
        case .lesson: "doc.text"
        }
    }
    var wash: Color {
        switch self {
        case .material: HomeStyle.powder
        case .subtopic: HomeStyle.lavender
        case .lesson: HomeStyle.paper
        }
    }
}

struct CatalogLevelHeader: View {
    let level: CatalogNavigationLevel
    let title: String
    let path: [String]
    let guidance: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    ForEach(Array(path.enumerated()), id: \.offset) { index, label in
                        if index > 0 {
                            Image(systemName: "chevron.right").font(.system(size: 9, weight: .semibold))
                        }
                        Text(label).font(.caption)
                    }
                }
                .foregroundStyle(HomeStyle.body)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Posisi: " + path.joined(separator: ", "))

            HStack(alignment: .top, spacing: 13) {
                Image(systemName: level.symbol)
                    .font(.system(size: 21, weight: .medium))
                    .foregroundStyle(HomeStyle.blue)
                    .frame(width: 48, height: 48)
                    .background(level.wash, in: RoundedRectangle(cornerRadius: 16))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 5) {
                    Text(level.title.uppercased())
                        .font(.caption2.weight(.semibold))
                        .tracking(1.1)
                        .foregroundStyle(HomeStyle.blue)
                    Text(title).brandHeading(27)
                        .accessibilityAddTraits(.isHeader)
                }
                Spacer(minLength: 0)
            }
            Text(guidance)
                .font(.subheadline)
                .foregroundStyle(HomeStyle.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 18)
    }
}

/// A folder is a navigational group; a lesson card shows actual content availability.
struct CatalogCurriculumCard: View {
    let title: String
    let detail: String
    let image: String
    var level: CatalogNavigationLevel = .subtopic
    var order: Int? = nil
    var isLocked = false
    @Environment(\.dynamicTypeSize) private var typeSize

    private var compact: Bool { level == .lesson }

    var body: some View {
        HStack(spacing: compact ? 14 : 18) {
            if let order {
                Text(String(format: "%02d", order))
                    .font(.system(size: compact ? 24 : 30, weight: .light).monospacedDigit())
                    .tracking(-1)
                    .foregroundStyle(HomeStyle.blue)
                    .frame(minWidth: compact ? 32 : 38)
                    .accessibilityHidden(true)
            }
            Image(image)
                .resizable().scaledToFit()
                .frame(width: typeSize.isAccessibilitySize ? 44 : compact ? 50 : 68, height: compact ? 64 : 88)
                .padding(compact ? 0 : 6)
                .background {
                    if !compact {
                        RoundedRectangle(cornerRadius: 20).fill(HomeStyle.lavender.opacity(0.5))
                    }
                }
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(compact ? .headline.weight(.medium) : .title3.weight(.medium))
                    .foregroundStyle(HomeStyle.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(HomeStyle.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: isLocked ? "lock.fill" : "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(isLocked ? HomeStyle.body : HomeStyle.blue)
                .frame(width: 28, height: 28)
                .background(HomeStyle.powder.opacity(0.65), in: Circle())
                .accessibilityHidden(true)
        }
        .padding(.horizontal, compact ? 16 : 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, minHeight: compact ? 100 : 132, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: compact ? 20 : 26)
                .fill(Color.white)
                .shadow(color: HomeStyle.ink.opacity(compact ? 0.06 : 0.11), radius: 0, x: 0, y: compact ? 3 : 5)
        }
        .overlay(RoundedRectangle(cornerRadius: compact ? 20 : 26).strokeBorder(HomeStyle.line, lineWidth: 1))
        .contentShape(RoundedRectangle(cornerRadius: compact ? 20 : 26))
        .accessibilityElement(children: .combine)
    }
}

private struct CatalogEntrance: ViewModifier {
    let index: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var visible = false

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .offset(y: visible || reduceMotion ? 0 : 14)
            .allowsHitTesting(visible)
            .accessibilityHidden(!visible)
            .task {
                if reduceMotion { visible = true; return }
                do { try await Task.sleep(nanoseconds: UInt64(max(0, min(index, 8))) * 55_000_000) }
                catch { return }
                guard !Task.isCancelled else { return }
                withAnimation(.smooth(duration: 0.45)) { visible = true }
            }
    }
}

extension View {
    func catalogEntrance(_ index: Int = 0) -> some View {
        modifier(CatalogEntrance(index: index))
    }
}

struct CatalogConnector: View {
    var body: some View {
        Rectangle().fill(HomeStyle.line)
            .frame(width: 2, height: 18)
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
    }
}

/// Compact location context; independent of the category selector's level label.
struct CatalogBreadcrumb: View {
    let path: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(Array(path.enumerated()), id: \.offset) { index, title in
                    if index > 0 {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(HomeStyle.muted)
                    }
                    Text(title)
                        .font(.caption.weight(index == path.count - 1 ? .medium : .regular))
                        .foregroundStyle(index == path.count - 1 ? HomeStyle.ink : HomeStyle.body)
                }
            }
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Posisi: " + path.joined(separator: ", "))
    }
}

/// Locked entries stay readable and respond to taps without opening unsupported content.
struct CatalogLockedCard: View {
    let topic: TopicSummary
    let order: Int
    @State private var attempts = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button { attempts += 1 } label: {
            CatalogCurriculumCard(
                title: topic.title, detail: "Belum tersedia dalam MVP",
                image: topic.illustrationName, level: .lesson, order: order, isLocked: true
            )
        }
        .buttonStyle(GentlePressStyle())
        .keyframeAnimator(initialValue: CGFloat.zero, trigger: attempts) { content, displacement in
            content.offset(x: reduceMotion ? 0 : displacement)
        } keyframes: { _ in
            LinearKeyframe(-6, duration: 0.06)
            LinearKeyframe(6, duration: 0.06)
            LinearKeyframe(-4, duration: 0.06)
            LinearKeyframe(4, duration: 0.06)
            LinearKeyframe(0, duration: 0.08)
        }
        .sensoryFeedback(.warning, trigger: attempts)
        .accessibilityLabel("\(order). \(topic.title). Terkunci, belum tersedia.")
        .accessibilityHint("Saat ini pemeriksaan hanya tersedia untuk Sistem Persamaan Linear.")
    }
}
