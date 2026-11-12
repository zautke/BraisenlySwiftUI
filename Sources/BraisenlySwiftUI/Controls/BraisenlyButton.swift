import SwiftUI

public enum BraisenlyButtonProminence: Sendable { case standard, prominent }

/// Themed button: interactive glass capsule under a glass theme, solid capsule otherwise.
/// One `Button` with one style whose values follow the theme, so switching themes keeps
/// the button's identity (no structural branch).
public struct BraisenlyButton: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let systemImage: String?
    public let prominence: BraisenlyButtonProminence
    private let action: () -> Void

    public init(
        _ title: String,
        systemImage: String? = nil,
        prominence: BraisenlyButtonProminence = .standard,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.prominence = prominence
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: theme.metrics.spacing[.xs]) {
                if let systemImage { Image(systemName: systemImage) }
                Text(title)
            }
            .font(theme.typography.rowLabelMedium)
            .frame(minHeight: theme.metrics.circleButtonSize)
            .padding(.horizontal, theme.metrics.spacing[.l])
        }
        .buttonStyle(BraisenlyButtonStyle(theme: theme, prominent: prominence == .prominent))
    }
}

private struct BraisenlyButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    let theme: BraisenlyThemeDefinition
    let prominent: Bool

    func makeBody(configuration: Configuration) -> some View {
        let shape = Capsule(style: .continuous)
        let glass = theme.surface.glass(for: .control)
        let solid = glass == nil
        let fill = prominent ? theme.colors.accentTeal : theme.colors.surfaceElevated
        return configuration.label
            .foregroundStyle(prominent ? theme.colors.matchForeground : theme.colors.textBright)
            .background(shape.fill(solid ? fill : Color.clear))
            .overlay(shape.strokeBorder(theme.colors.borderSubtle.opacity(solid && !prominent ? 1 : 0)))
            .glassEffect(glass.map { prominent ? $0.tint(theme.colors.accentTeal) : $0 } ?? .identity, in: shape)
            .opacity(isEnabled ? (configuration.isPressed ? 0.75 : 1) : 0.4)
    }
}
