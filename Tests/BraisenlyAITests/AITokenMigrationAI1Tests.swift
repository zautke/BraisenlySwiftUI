import BraisenlySwiftUI
import SwiftUI
import Testing
@testable import BraisenlyAI

@MainActor
private func renders<V: View>(_ view: V, theme: BraisenlyThemeDefinition) -> Bool {
    let content = view
        .braisenlyTheme(theme)
        .frame(width: 390, height: 640)
    return ImageRenderer(content: content).cgImage != nil
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func ai1ViewsRender(theme: BraisenlyThemeDefinition) {
    let message = AIMessage(role: .assistant, text: "Hi")
    let call = AIToolCall(name: "search", state: .complete)
    #expect(renders(AIChatErrorBanner(failure: .responseUnavailable) {}, theme: theme))
    #expect(renders(AICitationChip(citation: AICitation(title: "Doc")), theme: theme))
    #expect(renders(AIComposer(text: .constant("x"), isResponding: false, onSend: {}, onCancel: {}), theme: theme))
    #expect(renders(AIEmptyState { _ in }, theme: theme))
    #expect(renders(AIMessageBubble(message: message), theme: theme))
    #expect(renders(AIMessageList(messages: [message], onSelectSuggestion: { _ in }, onRegenerate: {}), theme: theme))
    #expect(renders(AIStreamingIndicator(), theme: theme))
    #expect(renders(AIToolCallCard(toolCall: call), theme: theme))
}
