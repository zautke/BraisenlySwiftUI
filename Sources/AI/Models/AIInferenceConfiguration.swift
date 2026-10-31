import Foundation

public struct AIInferenceConfiguration: Codable, Hashable, Sendable {
    public var activeProfile: AIModelProfile
    public var systemPrompt: String
    public var temperature: Double
    public var openAIBaseURL: String
    public var openAIAPIKey: String
    public var anthropicAPIKey: String
    public var enableBuiltInTools: Bool

    public init(
        activeProfile: AIModelProfile = .appleOnDevice,
        systemPrompt: String = "You are Askenly, a focused, articulate research and knowledge assistant. Provide clear, well-structured answers with concise markdown.",
        temperature: Double = 0.7,
        openAIBaseURL: String = "https://api.openai.com/v1",
        openAIAPIKey: String = "",
        anthropicAPIKey: String = "",
        enableBuiltInTools: Bool = true
    ) {
        self.activeProfile = activeProfile
        self.systemPrompt = systemPrompt
        self.temperature = temperature
        self.openAIBaseURL = openAIBaseURL
        self.openAIAPIKey = openAIAPIKey
        self.anthropicAPIKey = anthropicAPIKey
        self.enableBuiltInTools = enableBuiltInTools
    }
}
