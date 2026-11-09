import SwiftUI

extension EnvironmentValues {
    /// True below a `BraisenlyGlassGroup`; a nested group then renders its content without a second container.
    @Entry var braisenlyIsInGlassGroup: Bool = false
}

/// The single owner of `GlassEffectContainer` (spec §5.2). Solid themes and nested groups
/// render `content` without a container, so containers never nest.
struct BraisenlyGlassGroup<Content: View>: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.braisenlyIsInGlassGroup) private var isInGlassGroup

    private let spacing: BraisenlyStep
    private let content: Content

    init(spacing: BraisenlyStep = .s, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        if theme.surface == .solid || isInGlassGroup {
            content.environment(\.braisenlyIsInGlassGroup, true)
        } else {
            GlassEffectContainer(spacing: theme.metrics.spacing[spacing]) { content }
                .environment(\.braisenlyIsInGlassGroup, true)
        }
    }
}
