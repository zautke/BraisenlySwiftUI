public protocol AIChatClient: Sendable {
    func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error>
}
