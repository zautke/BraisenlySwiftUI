import SwiftUI

/// Rounded-rect surface. Solid fill + hairline stroke, or glass for non-content roles
/// when the environment theme is a glass theme (spec §5).
///
/// The view structure is identical for glass and solid themes; only values change,
/// so switching themes never tears down the wrapped content (state, focus, scroll).
public struct BraisenlyCardModifier: ViewModifier {
    @Environment(\.braisenlyTheme) private var theme

    /// nil = `theme.metrics.radius[.l]`.
    public let cornerRadius: CGFloat?
    /// Solid-mode fill only; nil = `theme.colors.surfaceElevated`. Ignored when the surface is glass.
    public let fill: Color?
    public let role: BraisenlySurfaceRole

    public init(cornerRadius: CGFloat? = nil, fill: Color? = nil, role: BraisenlySurfaceRole = .content) {
        self.cornerRadius = cornerRadius
        self.fill = fill
        self.role = role
    }

    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius ?? theme.metrics.radius[.l], style: .continuous)
        let glass = theme.surface.glass(for: role)
        let solid = glass == nil
        return content
            .background(shape.fill(solid ? (fill ?? theme.colors.surfaceElevated) : Color.clear))
            .overlay(
                shape.strokeBorder(
                    theme.colors.borderSubtle.opacity(solid ? 0.6 : 0),
                    lineWidth: theme.metrics.hairline * 1.6
                )
            )
            .glassEffect(glass ?? .identity, in: shape)
    }
}

public extension View {
    func braisenlyCard(
        cornerRadius: CGFloat? = nil,
        fill: Color? = nil,
        role: BraisenlySurfaceRole = .content
    ) -> some View {
        modifier(BraisenlyCardModifier(cornerRadius: cornerRadius, fill: fill, role: role))
    }
}
