import SwiftUI

/// Rounded-rect surface. Solid fill + hairline stroke, or glass for non-content roles
/// when the environment theme is a glass theme (spec §5).
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

    @ViewBuilder
    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius ?? theme.metrics.radius[.l], style: .continuous)
        if let glass = theme.surface.glass(for: role) {
            content.glassEffect(glass, in: shape)
        } else {
            content
                .background(shape.fill(fill ?? theme.colors.surfaceElevated))
                .overlay(
                    shape.strokeBorder(
                        theme.colors.borderSubtle.opacity(0.6),
                        lineWidth: theme.metrics.hairline * 1.6
                    )
                )
        }
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
