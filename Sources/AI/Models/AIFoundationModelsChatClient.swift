import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

public struct AIFoundationModelsChatClient: AIChatClient {
    public let fallbackClient: AISmartLocalAssistantClient

    public init(fallbackClient: AISmartLocalAssistantClient = AISmartLocalAssistantClient()) {
        self.fallbackClient = fallbackClient
    }

    public static var isSystemModelAvailable: Bool {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 26.0, *) {
            return SystemLanguageModel.default.isAvailable
        }
        #endif
        return false
    }

    public nonisolated func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 26.0, *),
           SystemLanguageModel.default.isAvailable {
            return streamWithSystemModel(request: request)
        }
        #endif
        return try await fallbackClient.streamResponse(to: request)
    }

    #if canImport(FoundationModels)
    @available(iOS 26.0, macOS 26.0, *)
    private nonisolated func streamWithSystemModel(
        request: AIChatRequest
    ) -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        let fallback = fallbackClient
        return AsyncThrowingStream { continuation in
            let task = Task.detached {
                do {
                    let instructions = request.systemPrompt
                    let session = LanguageModelSession(
                        model: SystemLanguageModel.default,
                        instructions: instructions
                    )
                    let prompt = Self.buildTranscriptPrompt(from: request.messages)
                    let responseStream = session.streamResponse(to: prompt)
                    var previousLength = 0
                    for try await snapshot in responseStream {
                        try Task.checkCancellation()
                        let current = snapshot.content
                        if current.count > previousLength {
                            let startIndex = current.index(current.startIndex, offsetBy: previousLength)
                            let delta = String(current[startIndex...])
                            previousLength = current.count
                            continuation.yield(.textDelta(delta))
                        }
                    }
                    continuation.yield(.finished)
                    continuation.finish()
                } catch is CancellationError {
                    continuation.finish(throwing: CancellationError())
                } catch {
                    do {
                        let stream = try await fallback.streamResponse(to: request)
                        for try await event in stream {
                            try Task.checkCancellation()
                            continuation.yield(event)
                        }
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    private nonisolated static func buildTranscriptPrompt(from messages: [AIMessage]) -> String {
        guard messages.count > 1 else {
            return messages.last?.text ?? ""
        }
        let history = messages.dropLast().map { message in
            let speaker = message.role == .user ? "User" : "Assistant"
            return "\(speaker): \(message.text)"
        }.joined(separator: "\n\n")
        let latest = messages.last?.text ?? ""
        return """
        Conversation history:
        \(history)

        User: \(latest)
        """
    }
    #endif
}
