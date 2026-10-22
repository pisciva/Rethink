import SwiftUI

struct MainTabBar: View {
    @Binding var selection: AppTab
    let openChat: () -> Void
    @Namespace private var selectionMotion
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let items: [(tab: AppTab, title: String, icon: String)] = [
        (.home, "Beranda", "house"),
        (.explore, "Jelajahi", "square.grid.2x2"),
        (.map, "Peta", "map")
    ]

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 2) {
                ForEach(items, id: \.tab) { item in
                    Button {
                        selection = item.tab
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: selection == item.tab ? item.icon + ".fill" : item.icon)
                                .font(.system(size: 21, weight: .regular))
                                .environment(\.symbolVariants, .none)
                            Text(item.title).font(.system(size: 10, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background {
                            if selection == item.tab {
                                Capsule()
                                    .fill(HomeStyle.ink.opacity(0.07))
                                    .overlay {
                                        Capsule().stroke(.white.opacity(0.65), lineWidth: 0.75)
                                    }
                                    .matchedGeometryEffect(id: "selectedTab", in: selectionMotion)
                            }
                        }
                        .foregroundStyle(selection == item.tab ? HomeStyle.blue : HomeStyle.ink)
                        .contentShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selection == item.tab ? .isSelected : [])
                }
            }
            .padding(4)
            .animation(reduceMotion ? nil : .spring(response: 0.38, dampingFraction: 0.82), value: selection)
            .glassEffect(.regular, in: .capsule)

            Button(action: openChat) {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.system(size: 23, weight: .regular))
                    .frame(width: 58, height: 58)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .accessibilityLabel("Buka Chatbot")
        }
        .foregroundStyle(HomeStyle.ink)
    }
}
