import BraisenlySwiftUI
import SwiftUI

public struct AIChatView: View {
    @Bindable private var session: AIChatSession
    @State private var internalTheme: BraisenlyThemeDefinition.ID
    private var externalTheme: Binding<BraisenlyThemeDefinition.ID>?

    public let platform: BraisenlyPlatform
    public let modelName: String?
    public let onToggleSidebar: (() -> Void)?
    public let onNewChat: (() -> Void)?
    public let onSelectModel: (() -> Void)?
    public let onMoreActions: (() -> Void)?

    public init(
        session: AIChatSession,
        platform: BraisenlyPlatform = .automatic,
        initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id,
        theme: Binding<BraisenlyThemeDefinition.ID>? = nil,
        modelName: String? = nil,
        onToggleSidebar: (() -> Void)? = nil,
        onNewChat: (() -> Void)? = nil,
        onSelectModel: (() -> Void)? = nil,
        onMoreActions: (() -> Void)? = nil
    ) {
        self.session = session
        self.platform = platform
        self.modelName = modelName
        self.externalTheme = theme
        self.onToggleSidebar = onToggleSidebar
        self.onNewChat = onNewChat
        self.onSelectModel = onSelectModel
        self.onMoreActions = onMoreActions
        _internalTheme = State(initialValue: initialTheme)
    }

    private var activeThemeBinding: Binding<BraisenlyThemeDefinition.ID> {
        externalTheme ?? $internalTheme
    }

    /// Resolved from the binding: this view applies the theme itself when unbound, so the
    /// environment value read here would be the parent's.
    private var theme: BraisenlyThemeDefinition {
        BraisenlyThemes.theme(withID: activeThemeBinding.wrappedValue)
    }

    public var body: some View {
        let content = chat
        if externalTheme == nil {
            content.braisenlyTheme(theme)
        } else {
            content
        }
    }

    private var chat: some View {
        VStack(spacing: 0) {
            AIChatHeader(
                title: session.conversation.title,
                modelName: modelName,
                theme: activeThemeBinding,
                platform: platform,
                onToggleSidebar: onToggleSidebar,
                onNewChat: onNewChat,
                onSelectModel: onSelectModel,
                onMoreActions: onMoreActions
            )
            AIMessageList(
                messages: session.messages,
                onSelectSuggestion: { session.draft = $0 },
                onRegenerate: session.regenerateLastResponse
            )
            if let failure = session.failure {
                AIChatErrorBanner(failure: failure, onDismiss: session.clearFailure)
                    .padding(.horizontal, theme.metrics.spacing[.l])
                    .padding(.bottom, theme.metrics.spacing[.s])
            }
            AIComposer(
                text: $session.draft,
                isResponding: session.isResponding,
                onSend: session.send,
                onCancel: session.cancel
            )
            .frame(maxWidth: 860)
            .padding(.horizontal, theme.metrics.spacing[.l])
            .padding(.vertical, theme.metrics.spacing[.m])
        }
        .background(theme.colors.backgroundPrimary.ignoresSafeArea())
    }
}
