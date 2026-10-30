import SwiftUI

public struct BraisenlyThemeToggle: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding private var theme: BraisenlyTheme

    public let platform: BraisenlyPlatform

    public init(theme: Binding<BraisenlyTheme>, platform: BraisenlyPlatform = .automatic) {
        _theme = theme
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        Button(action: toggleTheme) {
            Image(systemName: theme.symbolName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(BraisenlyDS.Colors.accentTeal)
                .contentTransition(.symbolEffect(.replace.downUp))
                .frame(width: resolvedPlatform.controlSize, height: resolvedPlatform.controlSize)
                .braisenlyCapsule()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(theme == .dark ? "Switch to Solarized Light" : "Switch to Solarized Dark")
        .accessibilityValue(theme == .dark ? "Solarized Dark" : "Solarized Light")
    }

    private func toggleTheme() {
        if reduceMotion {
            theme = theme.next
        } else {
            withAnimation(.snappy(duration: 0.35)) {
                theme = theme.next
            }
        }
    }
}
