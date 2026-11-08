import SwiftUI

public struct BraisenlyDocumentChrome: View {
    @Binding private var theme: BraisenlyTheme

    public let platform: BraisenlyPlatform
    public let onToggleSidebar: () -> Void
    public let onEdit: () -> Void
    public let onOpenActionSheet: () -> Void

    public init(
        theme: Binding<BraisenlyTheme> = .constant(.dark),
        platform: BraisenlyPlatform = .automatic,
        onToggleSidebar: @escaping () -> Void = {},
        onEdit: @escaping () -> Void = {},
        onOpenActionSheet: @escaping () -> Void = {}
    ) {
        _theme = theme
        self.platform = platform
        self.onToggleSidebar = onToggleSidebar
        self.onEdit = onEdit
        self.onOpenActionSheet = onOpenActionSheet
    }

    public var body: some View {
        VStack {
            HStack {
                BraisenlyCircleIconButton(
                    systemName: "sidebar.left",
                    accessibilityLabel: "Toggle sidebar",
                    platform: platform,
                    action: onToggleSidebar
                )
                BraisenlyThemeToggle(theme: $theme, platform: platform)
                Spacer()
                BraisenlyDualActionPill(platform: platform, onEdit: onEdit, onMore: onOpenActionSheet)
            }
            .padding(.horizontal, platform == .mac ? 20 : 16)
            .padding(.top, platform == .mac ? 12 : 6)
            Spacer()
            BraisenlyBottomToolbar(
                platform: platform,
                onSearch: onToggleSidebar,
                onMenu: onOpenActionSheet
            )
            .padding(.bottom, platform == .mac ? 16 : 12)
        }
    }
}
