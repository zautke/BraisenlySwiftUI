import Foundation

public struct AIAnthropicChatClient: AIChatClient {
    public let apiKey: String
    public let defaultModel: String

    public init(apiKey: String, defaultModel: String = "claude-sonnet-4-5") {
        self.apiKey = apiKey
        self.defaultModel = defaultModel
    }

    public nonisolated func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else {
            throw AIChatFailure.provider("Missing Anthropic API key. Configure your key in Model Settings.")
        }

        let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(trimmedKey, forHTTPHeaderField: "x-api-key")
        urlRequest.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let payloadMessages = request.messages.compactMap { message -> [String: String]? in
            guard !message.text.isEmpty, message.role == .user || message.role == .assistant else {
                return nil
            }
            return [
                "role": message.role.rawValue,
                "content": message.text
            ]
        }

        var body: [String: Any] = [
            "model": request.modelID ?? defaultModel,
            "max_tokens": 2048,
            "temperature": request.temperature,
            "messages": payloadMessages,
            "stream": true
        ]
        if let systemPrompt = request.systemPrompt, !systemPrompt.isEmpty {
            body["system"] = systemPrompt
        }
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        let immutableRequest = urlRequest

        return AsyncThrowingStream { continuation in
            let task = Task.detached {
                do {
                    let (bytes, response) = try await URLSession.shared.bytes(for: immutableRequest)
                    if let httpResponse = response as? HTTPURLResponse,
                       !(200..<300).contains(httpResponse.statusCode) {
                        throw AIChatFailure.provider("Anthropic API returned HTTP \(httpResponse.statusCode).")
                    }

                    for try await line in bytes.lines {
                        try Task.checkCancellation()
                        guard let jsonString = AISSELineParser.extractPayload(from: line),
                              let data = jsonString.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let delta = json["delta"] as? [String: Any],
                              let text = delta["text"] as? String,
                              !text.isEmpty else {
                            continue
                        }
                        continuation.yield(.textDelta(text))
                    }
                    continuation.yield(.finished)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
