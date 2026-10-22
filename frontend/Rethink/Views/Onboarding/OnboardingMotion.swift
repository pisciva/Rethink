import SwiftUI

struct OnboardingEntrance: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared || reduceMotion ? 0 : 14)
            .onAppear {
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.45)) { appeared = true }
            }
    }
}

private struct OnboardingFloat: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var lifted = false

    func body(content: Content) -> some View {
        content
            .offset(y: lifted && !reduceMotion && scenePhase == .active ? -7 : 0)
            .animation(reduceMotion || scenePhase != .active ? nil : .easeInOut(duration: 2.8).repeatForever(autoreverses: true), value: lifted)
            .onAppear { lifted = !reduceMotion && scenePhase == .active }
            .onChange(of: scenePhase) { _, phase in lifted = phase == .active && !reduceMotion }
            .onChange(of: reduceMotion) { _, reduced in lifted = !reduced && scenePhase == .active }
            .onDisappear { lifted = false }
    }
}

extension View {
    func onboardingFloat() -> some View { modifier(OnboardingFloat()) }
}

// Explicit onboarding elevation requested for card visibility; shared by slides 3–4.
extension View {
    func onboardingCardShadow() -> some View {
        shadow(color: HomeStyle.ink.opacity(0.07), radius: 12, x: 0, y: 6)
            .shadow(color: HomeStyle.ink.opacity(0.04), radius: 3, x: 0, y: 2)
    }
}

/// A restrained editorial reveal, with no character-by-character typing.
private struct OnboardingEditorialReveal: ViewModifier {
    let delay: UInt64
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var visible = false

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .blur(radius: visible || reduceMotion ? 0 : 3)
            .offset(y: visible || reduceMotion ? 0 : 10)
            .allowsHitTesting(visible)
            .accessibilityHidden(!visible)
            .task {
                if reduceMotion { visible = true; return }
                do { try await Task.sleep(nanoseconds: delay) }
                catch { return }
                guard !Task.isCancelled else { return }
                withAnimation(.easeOut(duration: 0.55)) { visible = true }
            }
    }
}

extension View {
    func onboardingEditorialReveal(delay: UInt64 = 0) -> some View {
        modifier(OnboardingEditorialReveal(delay: delay))
    }
}
