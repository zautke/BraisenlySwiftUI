import Foundation
import Testing
@testable import BraisenlyAI

private struct TestChatClient: AIChatClient {
    let events: [AIChatResponseEvent]

    nonisolated func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        let captured = events
        return AsyncThrowingStream { continuation in
            for event in captured { continuation.yield(event) }
            continuation.finish()
        }
    }
}

@MainActor
@Test func sessionStreamsAssistantResponse() async {
    let client = TestChatClient(events: [
        .textDelta("Hello"),
        .textDelta(" there"),
        .citation(AICitation(title: "Source")),
        .finished
    ])
    let session = AIChatSession(client: client)
    session.draft = "Hi"

    session.send()
    while session.isResponding { await Task.yield() }

    #expect(session.messages.count == 2)
    #expect(session.messages[0].role == .user)
    #expect(session.messages[1].text == "Hello there")
    #expect(session.messages[1].status == .complete)
    #expect(session.messages[1].citations.count == 1)
    #expect(session.conversation.title == "Hi")
}

@MainActor
@Test func sessionRejectsEmptyPrompt() {
    let session = AIChatSession(client: TestChatClient(events: []))
    session.draft = "   "

    session.send()

    #expect(session.failure == .emptyPrompt)
    #expect(session.messages.isEmpty)
}

@Test func conversationRoundTripsThroughCodable() throws {
    let conversation = AIConversation(
        title: "Research",
        messages: [AIMessage(role: .user, text: "Question")],
        isPinned: true
    )

    let data = try JSONEncoder().encode(conversation)
    let decoded = try JSONDecoder().decode(AIConversation.self, from: data)

    #expect(decoded == conversation)
    #expect(decoded.lastMessagePreview == "Question")
}

@Test func sseLineParserExtractsValidJSONPayloads() {
    #expect(AISSELineParser.extractPayload(from: "data: {\"delta\":\"hi\"}") == "{\"delta\":\"hi\"}")
    #expect(AISSELineParser.extractPayload(from: "data: [DONE]") == nil)
    #expect(AISSELineParser.extractPayload(from: "event: message") == nil)
}

@Test func smartLocalAssistantBuildsToolCallsAndTextDeltas() {
    let events = AISmartLocalAssistantClient.buildEvents(
        for: "Summarize my research notes",
        messageCount: 1
    )
    let hasToolCall = events.contains {
        if case .toolCall = $0 { return true }
        return false
    }
    let hasCitation = events.contains {
        if case .citation = $0 { return true }
        return false
    }
    let hasTextDelta = events.contains {
        if case .textDelta = $0 { return true }
        return false
    }
    #expect(hasToolCall)
    #expect(hasCitation)
    #expect(hasTextDelta)
}

@Test func openWeightCatalogIncludesLFM3AndOmniModels() {
    let ids = AIModelProfile.openWeightCatalog.map(\.id)
    #expect(ids.contains("LiquidAI/LFM3-1.7B-MLX-4bit"))
    #expect(ids.contains("LiquidAI/LFM3-1.7B-MLX-bf16"))
    #expect(ids.contains("LiquidAI/LFM3-Omni-2B-MLX-4bit"))
    #expect(ids.contains("mlx-community/Qwen3.5-4B-MLX-4bit"))
    #expect(ids.contains("mlx-community/gemma-4-e4b-it-4bit"))
    #expect(AIModelProfile.lfm3Omni.isLocalMLX)
    #expect(AIModelProfile.lfm3Omni.provider == .mlxOnDevice)
    #expect(AIInferenceConfiguration().activeProfile == .lfm3_1_7B_4bit)
}

@MainActor
@Test func workspaceControllerManagesMultipleConversationsAndPersistence() throws {
    let tempURL = FileManager.default.temporaryDirectory
        .appending(path: "AskenlyTest-\(UUID().uuidString).json")
    defer { try? FileManager.default.removeItem(at: tempURL) }

    let store = AIConversationStore(fileURL: tempURL)
    let controller = AIChatWorkspaceController(store: store)

    #expect(controller.conversations.count == 1)
    controller.session.renameConversation("First Thread")
    controller.togglePinCurrentConversation()
    controller.createNewConversation()

    #expect(controller.conversations.count == 2)
    #expect(controller.filteredConversations.first?.title == "First Thread")

    let reloaded = store.loadConversations()
    #expect(reloaded.count == 2)
}
