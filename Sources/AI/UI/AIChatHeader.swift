import BraisenlySwiftUI
import SwiftUI

public struct AIChatHeader: View {
    @Environment(\.braisenlyTheme) private var theme
    @Binding private var themeID: BraisenlyThemeDefinition.ID

    public let title: String
    public let modelName: String?
    public let platform: BraisenlyPlatform
    public let onToggleSidebar: (() -> Void)?
    public let onNewChat: (() -> Void)?
    public let onSelectModel: (() -> Void)?
    public let onMoreActions: (() -> Void)?

    public init(
        title: String,
        modelName: String? = nil,
        theme: Binding<BraisenlyThemeDefinition.ID>,
        platform: BraisenlyPlatform = .automatic,
        onToggleSidebar: (() -> Void)? = nil,
        onNewChat: (() -> Void)? = nil,
        onSelectModel: (() -> Void)? = nil,
        onMoreActions: (() -> Void)? = nil
    ) {
        self.title = title
        self.modelName = modelName
        _themeID = theme
        self.platform = platform
        self.onToggleSidebar = onToggleSidebar
        self.onNewChat = onNewChat
        self.onSelectModel = onSelectModel
        self.onMoreActions = onMoreActions
    }

    public var body: some View {
        HStack(spacing: theme.metrics.spacing[.m]) {
            if let onToggleSidebar {
                BraisenlyCircleIconButton(
                    systemName: "sidebar.left",
                    accessibilityLabel: "Toggle sidebar",
                    platform: platform,
                    action: onToggleSidebar
                )
            } else {
                BraisenlyAvatarBadge(systemName: "sparkles")
            }

            VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                Text(title)
                    .font(theme.typography.rowLabelMedium)
                    .foregroundStyle(theme.colors.textBright)
                    .lineLimit(1)
                if let modelName {
                    BraisenlyModelPill(
                        title: modelName,
                        systemImage: "cpu",
                        action: onSelectModel
                    )
                }
            }

            Spacer()

            if let onNewChat {
                BraisenlyCircleIconButton(
                    systemName: "square.and.pencil",
                    accessibilityLabel: "New conversation",
                    platform: platform,
                    action: onNewChat
                )
            }

            BraisenlyThemeSwitcher(selection: $themeID, style: .cycle, platform: platform)

            if let onMoreActions {
                BraisenlyCircleIconButton(
                    systemName: "ellipsis",
                    accessibilityLabel: "Conversation actions",
                    platform: platform,
                    action: onMoreActions
                )
            }
        }
        .padding(.horizontal, theme.metrics.spacing[.l])
        .padding(.vertical, theme.metrics.spacing[.s])
        .background(theme.colors.backgroundPrimary.opacity(0.96))
        .overlay(alignment: .bottom) { Divider().overlay(theme.colors.divider) }
    }
}
