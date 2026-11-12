import SwiftUI

/// How a theme draws non-content surfaces.
public enum BraisenlySurfaceStyle: Sendable, Equatable {
    case glass(Glass)
    case solid

    /// nil = draw the solid fill. Glass only for non-content roles;
    /// `.control` adds `.interactive()`.
    public func glass(for role: BraisenlySurfaceRole) -> Glass? {
        guard case .glass(let glass) = self else { return nil }
        switch role {
        case .content: return nil
        case .control: return glass.interactive()
        case .chrome: return glass
        }
    }
}

/// What a surface is, which decides whether it may be glass.
public enum BraisenlySurfaceRole: Sendable, Equatable {
    /// Cards, bubbles, banners, code, sheet content: always solid.
    case content
    /// Tappable surface: glass + interactive.
    case control
    /// Non-tappable floating navigation/toolbar/popover surface: glass, not interactive.
    case chrome
}

/// A complete, environment-delivered Braisenly theme.
public struct BraisenlyThemeDefinition: Sendable, Identifiable, Equatable {
    public var id: String
    public var name: String
    public var symbolName: String
    /// nil = follow system.
    public var colorScheme: ColorScheme?
    public var colors: BraisenlyColorTokens
    public var typography: BraisenlyTypographyTokens
    public var metrics: BraisenlyMetricTokens
    public var surface: BraisenlySurfaceStyle

    public init(
        id: String,
        name: String,
        symbolName: String,
        colorScheme: ColorScheme?,
        colors: BraisenlyColorTokens,
        typography: BraisenlyTypographyTokens = .standard,
        metrics: BraisenlyMetricTokens = .standard,
        surface: BraisenlySurfaceStyle
    ) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
        self.colorScheme = colorScheme
        self.colors = colors
        self.typography = typography
        self.metrics = metrics
        self.surface = surface
    }
}

public extension BraisenlyThemeDefinition {
    static var liquidGlass: Self { BraisenlyThemes.liquidGlass }
    static var solarizedLight: Self { BraisenlyThemes.solarizedLight }
    static var solarizedDark: Self { BraisenlyThemes.solarizedDark }
}

extension EnvironmentValues {
    @Entry public var braisenlyTheme: BraisenlyThemeDefinition = .liquidGlass
}

public extension View {
    /// Sets the environment theme, applies `preferredColorScheme(theme.colorScheme)`
    /// (nil = no preference) and `.tint(theme.colors.accentTeal)` so system controls follow the theme.
    func braisenlyTheme(_ theme: BraisenlyThemeDefinition) -> some View {
        environment(\.braisenlyTheme, theme)
            .preferredColorScheme(theme.colorScheme)
            .tint(theme.colors.accentTeal)
    }
}
