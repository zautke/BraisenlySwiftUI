public struct AIChatRequest: Sendable, Equatable {
    public let messages: [AIMessage]
    public let modelID: String?
    public let systemPrompt: String?
    public let temperature: Double

    public init(
        messages: [AIMessage],
        modelID: String? = nil,
        systemPrompt: String? = nil,
        temperature: Double = 0.7
    ) {
        self.messages = messages
        self.modelID = modelID
        self.systemPrompt = systemPrompt
        self.temperature = temperature
    }
}
