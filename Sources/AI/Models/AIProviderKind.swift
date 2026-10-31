import Foundation

public enum AIProviderKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case mlxOnDevice
    case appleIntelligence
    case openAICompatible
    case anthropic

    public var id: Self { self }

    public var displayName: String {
        switch self {
        case .mlxOnDevice: "On-Device MLX (Open Weight)"
        case .appleIntelligence: "Apple Intelligence"
        case .openAICompatible: "OpenAI Compatible"
        case .anthropic: "Anthropic Claude"
        }
    }

    public var iconName: String {
        switch self {
        case .mlxOnDevice: "cpu.fill"
        case .appleIntelligence: "apple.intelligence"
        case .openAICompatible: "network"
        case .anthropic: "sparkles"
        }
    }

    public var requiresAPIKey: Bool {
        switch self {
        case .mlxOnDevice, .appleIntelligence: false
        case .openAICompatible, .anthropic: true
        }
    }
}
