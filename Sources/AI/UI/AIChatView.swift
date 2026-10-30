import BraisenlySwiftUI
import SwiftUI

public struct AIChatView: View {
    @Bindable private var session: AIChatSession
    @State private var theme: BraisenlyTheme

    public let platform: BraisenlyPlatform
    public let modelName: String?

    public init(
        session: AIChatSession,
        platform: BraisenlyPlatform = .automatic,
        initialTheme: BraisenlyTheme = .dark,
        modelName: String? = nil
    ) {
        self.session = session
        self.platform = platform
        self.modelName = modelName
        _theme = State(initialValue: initialTheme)
    }

    public var body: some View {
        VStack(spacing: 0) {
            AIChatHeader(
                title: session.conversation.title,
                modelName: modelName,
                theme: $theme,
                platform: platform
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
        .braisenlyTheme(theme)
    }
}
