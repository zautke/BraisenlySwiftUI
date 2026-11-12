import SwiftUI

/// The built-in themes and theme-list helpers.
public enum BraisenlyThemes {
    public static let liquidGlass = BraisenlyThemeDefinition(
        id: "liquidGlass",
        name: "Liquid Glass",
        symbolName: "sparkles",
        colorScheme: nil,
        colors: .system,
        surface: .glass(.regular)
    )

    public static let solarizedLight = BraisenlyThemeDefinition(
        id: "solarizedLight",
        name: "Solarized Light",
        symbolName: "sun.max.fill",
        colorScheme: .light,
        colors: .solarized(.light),
        surface: .solid
    )

    public static let solarizedDark = BraisenlyThemeDefinition(
        id: "solarizedDark",
        name: "Solarized Dark",
        symbolName: "moon.stars.fill",
        colorScheme: .dark,
        colors: .solarized(.dark),
        surface: .solid
    )

    public static let all: [BraisenlyThemeDefinition] = [liquidGlass, solarizedLight, solarizedDark]

    /// Unknown id falls back to `liquidGlass` (never traps).
    public static func theme(
        withID id: BraisenlyThemeDefinition.ID,
        in themes: [BraisenlyThemeDefinition] = all
    ) -> BraisenlyThemeDefinition {
        themes.first { $0.id == id } ?? liquidGlass
    }

    /// Wraps around; unknown id returns themes.first's id (or the input id when themes is empty).
    public static func nextID(
        after id: BraisenlyThemeDefinition.ID,
        in themes: [BraisenlyThemeDefinition] = all
    ) -> BraisenlyThemeDefinition.ID {
        guard let index = themes.firstIndex(where: { $0.id == id }) else {
            return themes.first?.id ?? id
        }
        return themes[(index + 1) % themes.count].id
    }
}
