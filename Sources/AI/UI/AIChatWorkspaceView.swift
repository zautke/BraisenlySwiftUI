import BraisenlySwiftUI
import SwiftUI

public struct AIChatWorkspaceView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Bindable private var controller: AIChatWorkspaceController
    @State private var isSidebarOpen = false
    @State private var isModelSettingsPresented = false
    @State private var isConversationActionsPresented = false
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var themeID: BraisenlyThemeDefinition.ID

    public let platform: BraisenlyPlatform

    /// This view owns the theme state and applies it, so it resolves the theme from its id.
    private var theme: BraisenlyThemeDefinition { BraisenlyThemes.theme(withID: themeID) }

    public init(
        controller: AIChatWorkspaceController,
        initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id,
        platform: BraisenlyPlatform = .automatic
    ) {
        self.controller = controller
        self.platform = platform
        _themeID = State(initialValue: initialTheme)
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        Group {
            if resolvedPlatform == .iPhone {
                compactWorkspace
            } else {
                regularWorkspace(resolvedPlatform: resolvedPlatform)
            }
        }
        .braisenlyTheme(theme)
        .onChange(of: controller.session.messages) { _, _ in
            controller.syncSessionChanges()
        }
        .sheet(isPresented: $isModelSettingsPresented) {
            AIModelSettingsSheet(
                configuration: $controller.configuration,
                platform: resolvedPlatform
            )
            .presentationDetents(resolvedPlatform == .mac ? [.large] : [.fraction(0.82), .large])
            .presentationDragIndicator(.hidden)
            .braisenlySheetBackground()
            .braisenlyTheme(theme)
        }
        .sheet(isPresented: $isConversationActionsPresented) {
            AIConversationActionSheet(
                conversationTitle: controller.session.conversation.title,
                isPinned: controller.session.conversation.isPinned,
                platform: resolvedPlatform,
                onRename: { controller.session.renameConversation($0) },
                onTogglePin: controller.togglePinCurrentConversation,
                onExportMarkdown: controller.exportCurrentConversationMarkdown,
                onClearMessages: controller.clearCurrentConversation,
                onDeleteConversation: {
                    controller.deleteConversation(controller.selectedConversationID)
                }
            )
            .presentationDetents(resolvedPlatform == .mac ? [.large] : [.fraction(0.65), .large])
            .presentationDragIndicator(.hidden)
            .braisenlySheetBackground()
            .braisenlyTheme(theme)
        }
    }

    private var compactWorkspace: some View {
        GeometryReader { proxy in
            let sidebarWidth = proxy.size.width * theme.metrics.sidebarWidthRatio
            ZStack(alignment: .leading) {
                AIChatView(
                    session: controller.session,
                    platform: .iPhone,
                    theme: $themeID,
                    modelName: controller.configuration.activeProfile.name,
                    onToggleSidebar: toggleCompactSidebar,
                    onNewChat: controller.createNewConversation,
                    onSelectModel: { isModelSettingsPresented = true },
                    onMoreActions: { isConversationActionsPresented = true }
                )
                .offset(x: isSidebarOpen ? sidebarWidth : 0)
                .overlay {
                    if isSidebarOpen {
                        theme.colors.scrim
                            .ignoresSafeArea()
                            .onTapGesture(perform: closeCompactSidebar)
                    }
                }

                if isSidebarOpen {
                    AIConversationSidebar(
                        conversations: controller.filteredConversations,
                        selectedConversationID: controller.selectedConversationID,
                        searchText: $controller.searchQuery,
                        activeModelName: controller.configuration.activeProfile.name,
                        platform: .iPhone,
                        onSelectConversation: { id in
                            controller.selectConversation(id)
                            closeCompactSidebar()
                        },
                        onNewConversation: {
                            controller.createNewConversation()
                            closeCompactSidebar()
                        },
                        onDeleteConversation: controller.deleteConversation,
                        onOpenSettings: {
                            closeCompactSidebar()
                            isModelSettingsPresented = true
                        }
                    )
                    .frame(width: sidebarWidth)
                    .transition(.move(edge: .leading))
                }
            }
        }
    }

    private func regularWorkspace(resolvedPlatform: BraisenlyPlatform) -> some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            AIConversationSidebar(
                conversations: controller.filteredConversations,
                selectedConversationID: controller.selectedConversationID,
                searchText: $controller.searchQuery,
                activeModelName: controller.configuration.activeProfile.name,
                platform: resolvedPlatform,
                onSelectConversation: controller.selectConversation,
                onNewConversation: controller.createNewConversation,
                onDeleteConversation: controller.deleteConversation,
                onOpenSettings: { isModelSettingsPresented = true }
            )
            .navigationSplitViewColumnWidth(
                min: resolvedPlatform == .mac ? 260 : 300,
                ideal: resolvedPlatform == .mac ? 320 : 360,
                max: resolvedPlatform == .mac ? 420 : 460
            )
        } detail: {
            AIChatView(
                session: controller.session,
                platform: resolvedPlatform,
                theme: $themeID,
                modelName: controller.configuration.activeProfile.name,
                onToggleSidebar: {
                    withAnimation {
                        columnVisibility = columnVisibility == .all ? .detailOnly : .all
                    }
                },
                onNewChat: controller.createNewConversation,
                onSelectModel: { isModelSettingsPresented = true },
                onMoreActions: { isConversationActionsPresented = true }
            )
        }
        .navigationSplitViewStyle(.balanced)
    }

    private func toggleCompactSidebar() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            isSidebarOpen.toggle()
        }
    }

    private func closeCompactSidebar() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            isSidebarOpen = false
        }
    }
}
