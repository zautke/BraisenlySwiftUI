import SwiftUI

/// Capsule surface. Solid fill + stroke + shadow, or glass for non-content roles
/// when the environment theme is a glass theme (spec §5).
public struct BraisenlyCapsuleModifier: ViewModifier {
    @Environment(\.braisenlyTheme) private var theme

    /// Solid-mode fill only; nil = `theme.colors.surfaceElevated`. Ignored when the surface is glass.
    public let fill: Color?
    public let role: BraisenlySurfaceRole

    public init(fill: Color? = nil, role: BraisenlySurfaceRole = .control) {
        self.fill = fill
        self.role = role
    }

    @ViewBuilder
    public func body(content: Content) -> some View {
        if let glass = theme.surface.glass(for: role) {
            content.glassEffect(glass, in: Capsule(style: .continuous))
        } else {
            content
                .background(Capsule(style: .continuous).fill((fill ?? theme.colors.surfaceElevated).opacity(0.94)))
                .overlay(Capsule(style: .continuous).strokeBorder(theme.colors.borderSubtle))
                .shadow(color: theme.colors.shadow, radius: 12, x: 0, y: 6)
        }
    }
}

public extension View {
    func braisenlyCapsule(fill: Color? = nil, role: BraisenlySurfaceRole = .control) -> some View {
        modifier(BraisenlyCapsuleModifier(fill: fill, role: role))
    }
}
