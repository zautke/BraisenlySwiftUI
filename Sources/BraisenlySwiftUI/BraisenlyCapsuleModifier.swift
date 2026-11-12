import SwiftUI

/// Capsule surface. Solid fill + stroke + shadow, or glass for non-content roles
/// when the environment theme is a glass theme (spec §5).
///
/// The view structure is identical for glass and solid themes; only values change,
/// so switching themes never tears down the wrapped content (state, focus, transitions).
public struct BraisenlyCapsuleModifier: ViewModifier {
    @Environment(\.braisenlyTheme) private var theme

    /// Solid-mode fill only; nil = `theme.colors.surfaceElevated`. Ignored when the surface is glass.
    public let fill: Color?
    public let role: BraisenlySurfaceRole

    public init(fill: Color? = nil, role: BraisenlySurfaceRole = .control) {
        self.fill = fill
        self.role = role
    }

    public func body(content: Content) -> some View {
        let shape = Capsule(style: .continuous)
        let glass = theme.surface.glass(for: role)
        let solid = glass == nil
        return content
            .background(shape.fill(solid ? (fill ?? theme.colors.surfaceElevated).opacity(0.94) : Color.clear))
            .overlay(shape.strokeBorder(theme.colors.borderSubtle.opacity(solid ? 1 : 0)))
            .shadow(color: solid ? theme.colors.shadow : Color.clear, radius: 12, x: 0, y: 6)
            .glassEffect(glass ?? .identity, in: shape)
    }
}

public extension View {
    func braisenlyCapsule(fill: Color? = nil, role: BraisenlySurfaceRole = .control) -> some View {
        modifier(BraisenlyCapsuleModifier(fill: fill, role: role))
    }
}
