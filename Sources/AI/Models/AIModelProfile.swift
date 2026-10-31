import Foundation

public struct AIModelProfile: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let subtitle: String
    public let provider: AIProviderKind
    public let modelIdentifier: String

    public init(
        id: String,
        name: String,
        subtitle: String,
        provider: AIProviderKind,
        modelIdentifier: String
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.provider = provider
        self.modelIdentifier = modelIdentifier
    }

    public static let appleOnDevice = Self(
        id: "apple-on-device",
        name: "Apple Foundation Model",
        subtitle: "On-device private inference",
        provider: .appleIntelligence,
        modelIdentifier: "system-default"
    )

    public static let gpt4o = Self(
        id: "openai-gpt-4o",
        name: "GPT-4o",
        subtitle: "OpenAI flagship reasoning",
        provider: .openAICompatible,
        modelIdentifier: "gpt-4o"
    )

    public static let gpt4oMini = Self(
        id: "openai-gpt-4o-mini",
        name: "GPT-4o Mini",
        subtitle: "Fast & lightweight cloud",
        provider: .openAICompatible,
        modelIdentifier: "gpt-4o-mini"
    )

    public static let claudeSonnet = Self(
        id: "anthropic-claude-sonnet",
        name: "Claude Sonnet 4.5",
        subtitle: "Anthropic balanced intelligence",
        provider: .anthropic,
        modelIdentifier: "claude-sonnet-4-5"
    )

    public static let defaultProfiles: [Self] = [
        .appleOnDevice,
        .claudeSonnet,
        .gpt4o,
        .gpt4oMini
    ]
}
