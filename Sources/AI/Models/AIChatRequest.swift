public struct AIChatRequest: Sendable, Equatable {
    public let messages: [AIMessage]
    public let modelID: String?
    public let systemPrompt: String?

    public init(messages: [AIMessage], modelID: String? = nil, systemPrompt: String? = nil) {
        self.messages = messages
        self.modelID = modelID
        self.systemPrompt = systemPrompt
    }
}
