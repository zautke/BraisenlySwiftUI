import BraisenlySwiftUI
import SwiftUI

public struct AIConversationSidebar: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
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
            BraisenlyDS.Colors.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0) {
                BraisenlySidebarSearchHeader(searchText: $searchText, platform: resolvedPlatform)
                Divider().overlay(BraisenlyDS.Colors.divider)

                HStack {
                    Text("\(conversations.count) thread\(conversations.count == 1 ? "" : "s")")
                        .font(BraisenlyDS.Typography.metadata)
                        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                    Spacer()
                    Button(action: onNewConversation) {
                        Label("New Chat", systemImage: "plus")
                            .font(BraisenlyDS.Typography.metadata)
                            .foregroundStyle(BraisenlyDS.Colors.accentTeal)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .braisenlyCapsule(fill: BraisenlyDS.Colors.surfaceElevated)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 6) {
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
                    .padding(.horizontal, resolvedPlatform == .mac ? 10 : 12)
                    .padding(.vertical, 6)
                }

                Divider().overlay(BraisenlyDS.Colors.divider)

                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Askenly")
                            .font(BraisenlyDS.Typography.vaultTitle)
                            .foregroundStyle(BraisenlyDS.Colors.textBright)
                        Text(activeModelName)
                            .font(BraisenlyDS.Typography.metadata)
                            .foregroundStyle(BraisenlyDS.Colors.textSecondary)
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
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
        }
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(BraisenlyDS.Colors.borderSubtle.opacity(0.4))
                .frame(width: 0.5)
                .ignoresSafeArea()
        }
    }
}
