import Foundation
import Testing
@testable import BraisenlyAI

private struct TestChatClient: AIChatClient {
    let events: [AIChatResponseEvent]

    func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        AsyncThrowingStream { continuation in
            for event in events { continuation.yield(event) }
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
        messages: [AIMessage(role: .user, text: "Question")]
    )

    let data = try JSONEncoder().encode(conversation)
    let decoded = try JSONDecoder().decode(AIConversation.self, from: data)

    #expect(decoded == conversation)
}
