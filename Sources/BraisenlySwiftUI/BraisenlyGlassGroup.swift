import SwiftUI

extension EnvironmentValues {
    /// True below a `BraisenlyGlassGroup`; a nested group then renders its content without a second container.
    @Entry var braisenlyIsInGlassGroup: Bool = false
}

/// The single owner of `GlassEffectContainer` (spec §5.2). Nested groups render `content`
/// without a container, so containers never nest. The container is always present for a
/// top-level group (it is inert without glass children), so theme switches keep the
/// view structure and the content's state.
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
        if isInGlassGroup {
            content
        } else {
            GlassEffectContainer(spacing: theme.metrics.spacing[spacing]) { content }
                .environment(\.braisenlyIsInGlassGroup, true)
        }
    }
}
