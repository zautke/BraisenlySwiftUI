import SwiftUI

public enum BraisenlyThemeSwitcherStyle: Sendable, Equatable { case row, cycle }

/// Picks a theme by id: one capsule per theme (`.row`) or a single cycling button (`.cycle`).
public struct BraisenlyThemeSwitcher: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding private var selection: BraisenlyThemeDefinition.ID

    public let themes: [BraisenlyThemeDefinition]
    public let style: BraisenlyThemeSwitcherStyle
    public let platform: BraisenlyPlatform

    public init(
        selection: Binding<BraisenlyThemeDefinition.ID>,
        themes: [BraisenlyThemeDefinition] = BraisenlyThemes.all,
        style: BraisenlyThemeSwitcherStyle = .row,
        platform: BraisenlyPlatform = .automatic
    ) {
        _selection = selection
        self.themes = themes
        self.style = style
        self.platform = platform
    }

    /// Unknown selection renders as `themes.first`.
    private var current: BraisenlyThemeDefinition? {
        themes.first { $0.id == selection } ?? themes.first
    }

    public var body: some View {
        switch style {
        case .row: rowBody
        case .cycle: cycleBody
        }
    }

    private var rowBody: some View {
        BraisenlyGlassGroup {
            HStack(spacing: theme.metrics.spacing[.xs]) {
                ForEach(themes, id: \.id) { item in
                    let isSelected = item.id == current?.id
                    Button { choose(item.id) } label: {
                        Label(item.name, systemImage: item.symbolName)
                            .font(theme.typography.chipLabel)
                            .foregroundStyle(isSelected ? theme.colors.accentTeal : theme.colors.textSecondary)
                            .padding(.horizontal, theme.metrics.spacing[.m])
                            .padding(.vertical, theme.metrics.spacing[.s])
                            .braisenlyCapsule()
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
    }

    private var cycleBody: some View {
        let size = platform.resolved(horizontalSizeClass: horizontalSizeClass).controlSize
        let nextName = BraisenlyThemes.theme(
            withID: BraisenlyThemes.nextID(after: current?.id ?? selection, in: themes), in: themes
        ).name
        return Button { choose(BraisenlyThemes.nextID(after: current?.id ?? selection, in: themes)) } label: {
            Image(systemName: current?.symbolName ?? "circle")
                .font(theme.typography.controlIcon)
                .foregroundStyle(theme.colors.accentTeal)
                .contentTransition(.symbolEffect(.replace.downUp))
                .frame(width: size, height: size)
                .braisenlyCapsule()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Theme")
        .accessibilityValue(current?.name ?? "")
        .accessibilityHint("Switches to \(nextName)")
    }

    private func choose(_ id: BraisenlyThemeDefinition.ID) {
        if reduceMotion {
            selection = id
        } else {
            withAnimation(.snappy(duration: 0.35)) { selection = id }
        }
    }
}
