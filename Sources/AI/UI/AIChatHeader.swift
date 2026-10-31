import BraisenlySwiftUI
import SwiftUI

public struct AIChatHeader: View {
    @Binding private var theme: BraisenlyTheme

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
        theme: Binding<BraisenlyTheme>,
        platform: BraisenlyPlatform = .automatic,
        onToggleSidebar: (() -> Void)? = nil,
        onNewChat: (() -> Void)? = nil,
        onSelectModel: (() -> Void)? = nil,
        onMoreActions: (() -> Void)? = nil
    ) {
        self.title = title
        self.modelName = modelName
        _theme = theme
        self.platform = platform
        self.onToggleSidebar = onToggleSidebar
        self.onNewChat = onNewChat
        self.onSelectModel = onSelectModel
        self.onMoreActions = onMoreActions
    }

    public var body: some View {
        HStack(spacing: 12) {
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

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(BraisenlyDS.Typography.rowLabelMedium)
                    .foregroundStyle(BraisenlyDS.Colors.textBright)
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

            BraisenlyThemeToggle(theme: $theme, platform: platform)

            if let onMoreActions {
                BraisenlyCircleIconButton(
                    systemName: "ellipsis",
                    accessibilityLabel: "Conversation actions",
                    platform: platform,
                    action: onMoreActions
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(BraisenlyDS.Colors.backgroundPrimary.opacity(0.96))
        .overlay(alignment: .bottom) { Divider().overlay(BraisenlyDS.Colors.divider) }
    }
}
