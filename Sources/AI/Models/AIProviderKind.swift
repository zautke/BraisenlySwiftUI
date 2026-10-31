import Foundation

public enum AIProviderKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case appleIntelligence
    case openAICompatible
    case anthropic

    public var id: Self { self }

    public var displayName: String {
        switch self {
        case .appleIntelligence: "Apple Intelligence"
        case .openAICompatible: "OpenAI Compatible"
        case .anthropic: "Anthropic Claude"
        }
    }

    public var iconName: String {
        switch self {
        case .appleIntelligence: "apple.intelligence"
        case .openAICompatible: "network"
        case .anthropic: "sparkles"
        }
    }

    public var requiresAPIKey: Bool {
        switch self {
        case .appleIntelligence: false
        case .openAICompatible, .anthropic: true
        }
    }
}
