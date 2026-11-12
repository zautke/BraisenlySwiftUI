import SwiftUI

public struct BraisenlyDocumentChrome: View {
    @Environment(\.braisenlyTheme) private var theme
    @Binding private var themeID: BraisenlyThemeDefinition.ID

    public let platform: BraisenlyPlatform
    public let onToggleSidebar: () -> Void
    public let onEdit: () -> Void
    public let onOpenActionSheet: () -> Void

    public init(
        theme: Binding<BraisenlyThemeDefinition.ID> = .constant(BraisenlyThemes.liquidGlass.id),
        platform: BraisenlyPlatform = .automatic,
        onToggleSidebar: @escaping () -> Void = {},
        onEdit: @escaping () -> Void = {},
        onOpenActionSheet: @escaping () -> Void = {}
    ) {
        _themeID = theme
        self.platform = platform
        self.onToggleSidebar = onToggleSidebar
        self.onEdit = onEdit
        self.onOpenActionSheet = onOpenActionSheet
    }

    public var body: some View {
        BraisenlyGlassGroup {
        VStack {
            HStack {
                BraisenlyCircleIconButton(
                    systemName: "sidebar.left",
                    accessibilityLabel: "Toggle sidebar",
                    platform: platform,
                    action: onToggleSidebar
                )
                BraisenlyThemeSwitcher(selection: $themeID, style: .cycle, platform: platform)
                Spacer()
                BraisenlyDualActionPill(platform: platform, onEdit: onEdit, onMore: onOpenActionSheet)
            }
            .padding(.horizontal, platform == .mac ? theme.metrics.spacing[.xl] : theme.metrics.spacing[.l])
            .padding(.top, platform == .mac ? theme.metrics.spacing[.m] : theme.metrics.spacing[.s])
            Spacer()
            BraisenlyBottomToolbar(
                platform: platform,
                onSearch: onToggleSidebar,
                onMenu: onOpenActionSheet
            )
            .padding(.bottom, platform == .mac ? theme.metrics.spacing[.l] : theme.metrics.spacing[.m])
        }
        }
    }
}
