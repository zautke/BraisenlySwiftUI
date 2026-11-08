import Foundation

public struct AIMultiProviderChatClient: AIChatClient {
    public let configurationProvider: @Sendable () -> AIInferenceConfiguration

    public init(configuration: AIInferenceConfiguration) {
        self.configurationProvider = { configuration }
    }

    public init(configurationProvider: @escaping @Sendable () -> AIInferenceConfiguration) {
        self.configurationProvider = configurationProvider
    }

    public func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        let config = configurationProvider()
        switch config.activeProfile.provider {
        case .mlxOnDevice:
            let client = AIOnDeviceMLXChatClient(
                modelIdentifier: config.activeProfile.modelIdentifier
            )
            return try await client.streamResponse(to: request)
        case .appleIntelligence:
            let client = AIFoundationModelsChatClient(
                fallbackClient: AISmartLocalAssistantClient()
            )
            return try await client.streamResponse(to: request)
        case .openAICompatible:
            let baseURL = URL(string: config.openAIBaseURL) ?? URL(string: "https://api.openai.com/v1")!
            let client = AIOpenAICompatibleChatClient(
                baseURL: baseURL,
                apiKey: config.openAIAPIKey,
                defaultModel: config.activeProfile.modelIdentifier
            )
            return try await client.streamResponse(to: request)
        case .anthropic:
            let client = AIAnthropicChatClient(
                apiKey: config.anthropicAPIKey,
                defaultModel: config.activeProfile.modelIdentifier
            )
            return try await client.streamResponse(to: request)
        }
    }
}
