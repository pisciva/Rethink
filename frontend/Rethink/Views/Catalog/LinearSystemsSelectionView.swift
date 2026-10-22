import SwiftUI

struct LinearSystemsSelectionView: View {
    @State private var lockedAttempts = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 9) {
                    Text("Pilih fokus belajarmu")
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .font(.system(size: 30, weight: .medium))
                        .tracking(-0.8)
                }
                .padding(.vertical, 8)

                NavigationLink {
                    TopicOverviewView(topic: TopicSummary(id: "spl", title: "Sistem Persamaan Linear Dua Variabel", description: "Periksa konsep pendukung dalam pengerjaan SPLDV.", illustrationName: "asset 33", availability: .available))
                } label: {
                    systemCard(title: "SPLDV", subtitle: "Sistem Persamaan Linear\nDua Variabel", variables: "x, y", equation: "x + y = 7\nx − y = 1", color: Color(red: 0.89, green: 0.62, blue: 0.97), symbol: "square.on.square", locked: false)
                }
                .buttonStyle(GentlePressStyle())

                Button { lockedAttempts += 1 } label: {
                    systemCard(title: "SPLTV", subtitle: "Sistem Persamaan Linear\nTiga Variabel", variables: "x, y, z", equation: "x + y + z = 6\nx − y + z = 4", color: Color(red: 1, green: 0.63, blue: 0.23), symbol: "cube", locked: true)
                }
                .buttonStyle(GentlePressStyle())
                .sensoryFeedback(.warning, trigger: lockedAttempts)
                .keyframeAnimator(initialValue: CGFloat.zero, trigger: lockedAttempts) { content, offset in
                    content.offset(x: reduceMotion ? 0 : offset)
                } keyframes: { _ in
                    KeyframeTrack {
                        LinearKeyframe(-4, duration: 0.05)
                        LinearKeyframe(4, duration: 0.06)
                        LinearKeyframe(-2, duration: 0.06)
                        LinearKeyframe(0, duration: 0.06)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("Sistem Persamaan Linear")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    private func systemCard(title: String, subtitle: String, variables: String, equation: String, color: Color, symbol: String, locked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 26) {
            HStack(alignment: .top) {
                Image(systemName: symbol)
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 54, height: 54)
                    .background(.black, in: Circle())
                Spacer()
                ZStack {
                    Circle().trim(from: 0.12, to: 0.97)
                        .stroke(.black.opacity(0.8), style: StrokeStyle(lineWidth: 1.3, lineCap: .round))
                        .rotationEffect(.degrees(-75))
                    Text(locked ? "3" : "2")
                        .font(.system(size: 17, weight: .medium))
                }
                .frame(width: 45, height: 45)
                .accessibilityLabel(locked ? "Tiga variabel" : "Dua variabel")
            }
            HStack(alignment: .bottom, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(variables)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .overlay(Capsule().stroke(.black.opacity(0.3), lineWidth: 0.75))
                    Text(title)
                        .font(.system(size: 28, weight: .semibold))
                        .tracking(-0.6)
                    Text(subtitle)
                        .font(.system(size: 13))
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                    Label(locked ? "Terkunci" : "Pilih fokus ini", systemImage: locked ? "lock" : "arrow.up.right")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.top, 4)
                }
                Spacer(minLength: 0)
                VStack(spacing: 12) {
                    Image(systemName: locked ? "cube.transparent" : "chart.xyaxis.line")
                        .font(.system(size: 39, weight: .ultraLight))
                    Text(equation)
                        .font(.system(size: 11, weight: .regular, design: .monospaced))
                        .multilineTextAlignment(.center)
                }
                .rotationEffect(.degrees(locked ? 8 : -8))
                .opacity(0.65)
                .accessibilityHidden(true)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.black)
        .background(color, in: RoundedRectangle(cornerRadius: 32))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { LinearSystemsSelectionView() }
}
