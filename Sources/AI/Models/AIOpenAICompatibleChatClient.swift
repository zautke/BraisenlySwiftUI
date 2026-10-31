import Foundation

public struct AIOpenAICompatibleChatClient: AIChatClient {
    public let baseURL: URL
    public let apiKey: String
    public let defaultModel: String

    public init(
        baseURL: URL = URL(string: "https://api.openai.com/v1")!,
        apiKey: String,
        defaultModel: String = "gpt-4o"
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.defaultModel = defaultModel
    }

    public nonisolated func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else {
            throw AIChatFailure.provider("Missing OpenAI API key. Configure your key in Model Settings.")
        }

        let endpoint = baseURL.appending(path: "chat/completions")
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(trimmedKey)", forHTTPHeaderField: "Authorization")

        var payloadMessages: [[String: String]] = []
        if let systemPrompt = request.systemPrompt, !systemPrompt.isEmpty {
            payloadMessages.append(["role": "system", "content": systemPrompt])
        }
        for message in request.messages where !message.text.isEmpty {
            payloadMessages.append([
                "role": message.role.rawValue,
                "content": message.text
            ])
        }

        let body: [String: Any] = [
            "model": request.modelID ?? defaultModel,
            "messages": payloadMessages,
            "temperature": request.temperature,
            "stream": true
        ]
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        let immutableRequest = urlRequest

        return AsyncThrowingStream { continuation in
            let task = Task.detached {
                do {
                    let (bytes, response) = try await URLSession.shared.bytes(for: immutableRequest)
                    if let httpResponse = response as? HTTPURLResponse,
                       !(200..<300).contains(httpResponse.statusCode) {
                        throw AIChatFailure.provider("OpenAI endpoint returned HTTP \(httpResponse.statusCode).")
                    }

                    for try await line in bytes.lines {
                        try Task.checkCancellation()
                        guard let jsonString = AISSELineParser.extractPayload(from: line),
                              let data = jsonString.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let choices = json["choices"] as? [[String: Any]],
                              let delta = choices.first?["delta"] as? [String: Any],
                              let content = delta["content"] as? String,
                              !content.isEmpty else {
                            continue
                        }
                        continuation.yield(.textDelta(content))
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
