import BraisenlySwiftUI
import SwiftUI

public struct AIConversationSidebar: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.braisenlyTheme) private var theme
    @Binding private var searchText: String

    public let conversations: [AIConversation]
    public let selectedConversationID: UUID
    public let activeModelName: String
    public let platform: BraisenlyPlatform
    public let onSelectConversation: (UUID) -> Void
    public let onNewConversation: () -> Void
    public let onDeleteConversation: (UUID) -> Void
    public let onOpenSettings: () -> Void

    public init(
        conversations: [AIConversation],
        selectedConversationID: UUID,
        searchText: Binding<String>,
        activeModelName: String,
        platform: BraisenlyPlatform = .automatic,
        onSelectConversation: @escaping (UUID) -> Void,
        onNewConversation: @escaping () -> Void,
        onDeleteConversation: @escaping (UUID) -> Void,
        onOpenSettings: @escaping () -> Void
    ) {
        self.conversations = conversations
        self.selectedConversationID = selectedConversationID
        _searchText = searchText
        self.activeModelName = activeModelName
        self.platform = platform
        self.onSelectConversation = onSelectConversation
        self.onNewConversation = onNewConversation
        self.onDeleteConversation = onDeleteConversation
        self.onOpenSettings = onOpenSettings
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        ZStack(alignment: .bottom) {
            theme.colors.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0) {
                BraisenlySidebarSearchHeader(searchText: $searchText, platform: resolvedPlatform)
                Divider().overlay(theme.colors.divider)

                HStack {
                    Text("\(conversations.count) thread\(conversations.count == 1 ? "" : "s")")
                        .font(theme.typography.metadata)
                        .foregroundStyle(theme.colors.textSecondary)
                    Spacer()
                    Button(action: onNewConversation) {
                        Label("New Chat", systemImage: "plus")
                            .font(theme.typography.metadata)
                            .foregroundStyle(theme.colors.accentTeal)
                            .padding(.horizontal, theme.metrics.spacing[.s])
                            .padding(.vertical, theme.metrics.spacing[.xs])
                            .braisenlyCapsule(fill: theme.colors.surfaceElevated)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, theme.metrics.spacing[.l])
                .padding(.vertical, theme.metrics.spacing[.s])

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: theme.metrics.spacing[.s]) {
                        ForEach(conversations) { conversation in
                            BraisenlyConversationRow(
                                title: conversation.title,
                                subtitle: conversation.lastMessagePreview,
                                timestampText: conversation.updatedAt.formatted(.dateTime.hour().minute()),
                                isSelected: conversation.id == selectedConversationID,
                                isPinned: conversation.isPinned,
                                platform: resolvedPlatform,
                                action: { onSelectConversation(conversation.id) }
                            )
                            .contextMenu {
                                Button(role: .destructive) {
                                    onDeleteConversation(conversation.id)
                                } label: {
                                    Label("Delete Thread", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, resolvedPlatform == .mac ? theme.metrics.spacing[.s] : theme.metrics.spacing[.m])
                    .padding(.vertical, theme.metrics.spacing[.s])
                }

                Divider().overlay(theme.colors.divider)

                HStack {
                    VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                        Text("Askenly")
                            .font(theme.typography.vaultTitle)
                            .foregroundStyle(theme.colors.textBright)
                        Text(activeModelName)
                            .font(theme.typography.metadata)
                            .foregroundStyle(theme.colors.textSecondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    BraisenlyCircleIconButton(
                        systemName: "slider.horizontal.3",
                        accessibilityLabel: "Model Settings",
                        platform: resolvedPlatform,
                        action: onOpenSettings
                    )
                }
                .padding(.horizontal, theme.metrics.spacing[.m])
                .padding(.vertical, theme.metrics.spacing[.m])
            }
        }
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(theme.colors.borderSubtle.opacity(0.4))
                .frame(width: theme.metrics.hairline)
                .ignoresSafeArea()
        }
    }
}
