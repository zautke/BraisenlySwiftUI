import BraisenlySwiftUI
import SwiftUI

public struct AIChatView: View {
    @Bindable private var session: AIChatSession
    @State private var internalTheme: BraisenlyTheme
    private var externalTheme: Binding<BraisenlyTheme>?

    public let platform: BraisenlyPlatform
    public let modelName: String?
    public let onToggleSidebar: (() -> Void)?
    public let onNewChat: (() -> Void)?
    public let onSelectModel: (() -> Void)?
    public let onMoreActions: (() -> Void)?

    public init(
        session: AIChatSession,
        platform: BraisenlyPlatform = .automatic,
        initialTheme: BraisenlyTheme = .dark,
        theme: Binding<BraisenlyTheme>? = nil,
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

    private var activeThemeBinding: Binding<BraisenlyTheme> {
        externalTheme ?? $internalTheme
    }

    public var body: some View {
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
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
            AIComposer(
                text: $session.draft,
                isResponding: session.isResponding,
                onSend: session.send,
                onCancel: session.cancel
            )
            .frame(maxWidth: 860)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(BraisenlyDS.Colors.backgroundPrimary.ignoresSafeArea())
        .braisenlyTheme(activeThemeBinding.wrappedValue)
    }
}
