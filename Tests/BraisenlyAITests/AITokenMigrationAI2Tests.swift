import BraisenlySwiftUI
import Foundation
import SwiftUI
import Testing
@testable import BraisenlyAI

private struct MockClient: AIChatClient {
    nonisolated func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        AsyncThrowingStream { $0.finish() }
    }
}

@MainActor
private func renders<V: View>(_ view: V, theme: BraisenlyThemeDefinition) -> Bool {
    let content = view
        .braisenlyTheme(theme)
        .frame(width: 390, height: 640)
    return ImageRenderer(content: content).cgImage != nil
}

@MainActor
private func makeController() -> AIChatWorkspaceController {
    let file = FileManager.default.temporaryDirectory.appending(path: "ai2-\(UUID()).json")
    return AIChatWorkspaceController(
        store: AIConversationStore(fileURL: file),
        defaults: UserDefaults(suiteName: "ai2-\(UUID())")!
    )
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func ai2ViewsRender(theme: BraisenlyThemeDefinition) {
    let session = AIChatSession(client: MockClient())
    #expect(renders(
        AIChatHeader(title: "T", modelName: "M", theme: .constant(theme.id), onToggleSidebar: {}, onNewChat: {},
                     onSelectModel: {}, onMoreActions: {}), theme: theme))
    #expect(renders(AIChatView(session: session, initialTheme: theme.id), theme: theme))
    #expect(renders(AIChatView(session: session, theme: .constant(theme.id)), theme: theme))
    #expect(renders(AIChatWorkspaceView(controller: makeController(), initialTheme: theme.id), theme: theme))
    #expect(renders(
        AIConversationActionSheet(
            conversationTitle: "T", isPinned: false, onRename: { _ in }, onTogglePin: {},
            onExportMarkdown: { "" }, onClearMessages: {}, onDeleteConversation: {}), theme: theme))
    #expect(renders(
        AIConversationSidebar(
            conversations: [AIConversation()], selectedConversationID: UUID(), searchText: .constant(""),
            activeModelName: "M", onSelectConversation: { _ in }, onNewConversation: {},
            onDeleteConversation: { _ in }, onOpenSettings: {}), theme: theme))
    #expect(renders(AIModelSettingsSheet(configuration: .constant(AIInferenceConfiguration())), theme: theme))
}
