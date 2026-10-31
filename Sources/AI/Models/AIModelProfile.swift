import Foundation

public struct AIModelProfile: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let subtitle: String
    public let provider: AIProviderKind
    public let modelIdentifier: String
    public let family: String
    public let parameterCount: String
    public let quantization: String
    public let contextWindow: Int
    public let defaultTemperature: Double
    public let topP: Double
    public let supportsThinking: Bool
    public let supportsTools: Bool
    public let isLocalMLX: Bool

    public init(
        id: String,
        name: String,
        subtitle: String,
        provider: AIProviderKind,
        modelIdentifier: String,
        family: String = "General",
        parameterCount: String = "Cloud",
        quantization: String = "Native",
        contextWindow: Int = 128_000,
        defaultTemperature: Double = 0.6,
        topP: Double = 0.95,
        supportsThinking: Bool = true,
        supportsTools: Bool = true,
        isLocalMLX: Bool = false
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.provider = provider
        self.modelIdentifier = modelIdentifier
        self.family = family
        self.parameterCount = parameterCount
        self.quantization = quantization
        self.contextWindow = contextWindow
        self.defaultTemperature = defaultTemperature
        self.topP = topP
        self.supportsThinking = supportsThinking
        self.supportsTools = supportsTools
        self.isLocalMLX = isLocalMLX
    }

    /// Default Main Open-Weight Model: Liquid AI LFM3-1.7B 4-bit (24-layer Tri-Hybrid: 13 Conv + 5 SWA + 6 Global Attention)
    public static let lfm3_1_7B_4bit = Self(
        id: "mlx-community/LFM3-1.7B-4bit",
        name: "LFM3 1.7B",
        subtitle: "Liquid Tri-Hybrid • 4-bit (~1.05 GB) • 256K ctx",
        provider: .mlxOnDevice,
        modelIdentifier: "mlx-community/LFM3-1.7B-4bit",
        family: "Liquid Tri-Hybrid",
        parameterCount: "1.73B",
        quantization: "4-bit (~1.05 GB)",
        contextWindow: 262_144,
        defaultTemperature: 0.6,
        topP: 0.95,
        supportsThinking: true,
        supportsTools: true,
        isLocalMLX: true
    )

    /// High-Precision Open-Weight BF16 Sibling (~3.4 GB — runs effortlessly on 8GB/16GB M4 iPad Pro)
    public static let lfm3_1_7B_bf16 = Self(
        id: "LiquidAI/LFM3-1.7B",
        name: "LFM3 1.7B (BF16)",
        subtitle: "Liquid Tri-Hybrid • BF16 (~3.4 GB) • 256K ctx",
        provider: .mlxOnDevice,
        modelIdentifier: "LiquidAI/LFM3-1.7B",
        family: "Liquid Tri-Hybrid",
        parameterCount: "1.73B",
        quantization: "BF16 (~3.4 GB)",
        contextWindow: 262_144,
        defaultTemperature: 0.6,
        topP: 0.95,
        supportsThinking: true,
        supportsTools: true,
        isLocalMLX: true
    )

    /// Open-Weight Multimodal Omni Model: Liquid AI LFM3-Omni (Vision, Audio, and Text Tri-Hybrid)
    public static let lfm3Omni = Self(
        id: "lfm3-omni",
        name: "LFM3 Omni",
        subtitle: "Liquid Multimodal Omni • 4-bit (~1.85 GB) • 256K ctx",
        provider: .mlxOnDevice,
        modelIdentifier: "lfm3-omni",
        family: "Liquid Multimodal Omni",
        parameterCount: "3.0B",
        quantization: "4-bit (~1.85 GB)",
        contextWindow: 262_144,
        defaultTemperature: 0.6,
        topP: 0.95,
        supportsThinking: true,
        supportsTools: true,
        isLocalMLX: true
    )

    /// Pluggable Local Open-Weight Alternative: Qwen3.5 4B 4-bit
    public static let qwen3_5_4B = Self(
        id: "mlx-community/Qwen3.5-4B-4bit",
        name: "Qwen 3.5 4B",
        subtitle: "Qwen Dense • 4-bit (~2.4 GB) • 256K ctx",
        provider: .mlxOnDevice,
        modelIdentifier: "mlx-community/Qwen3.5-4B-4bit",
        family: "Qwen Dense",
        parameterCount: "4.0B",
        quantization: "4-bit (~2.4 GB)",
        contextWindow: 262_144,
        defaultTemperature: 0.7,
        topP: 0.95,
        supportsThinking: true,
        supportsTools: true,
        isLocalMLX: true
    )

    /// Pluggable Local Open-Weight Alternative: Gemma 4 E4B 4-bit
    public static let gemma4_e4b = Self(
        id: "mlx-community/gemma-4-E4B-it-4bit",
        name: "Gemma 4 E4B",
        subtitle: "Gemma • 4-bit (~2.5 GB) • 128K ctx",
        provider: .mlxOnDevice,
        modelIdentifier: "mlx-community/gemma-4-E4B-it-4bit",
        family: "Gemma",
        parameterCount: "4.0B",
        quantization: "4-bit (~2.5 GB)",
        contextWindow: 131_072,
        defaultTemperature: 0.7,
        topP: 0.95,
        supportsThinking: false,
        supportsTools: true,
        isLocalMLX: true
    )

    public static let appleOnDevice = Self(
        id: "apple-on-device",
        name: "Apple Foundation Model",
        subtitle: "On-device private inference",
        provider: .appleIntelligence,
        modelIdentifier: "system-default",
        family: "Apple Intelligence",
        parameterCount: "3B On-Device",
        quantization: "Mixed 2/4-bit",
        contextWindow: 65_536
    )

    public static let gpt4o = Self(
        id: "openai-gpt-4o",
        name: "GPT-4o",
        subtitle: "OpenAI flagship reasoning",
        provider: .openAICompatible,
        modelIdentifier: "gpt-4o",
        family: "OpenAI Omni",
        parameterCount: "Cloud",
        quantization: "BF16",
        contextWindow: 128_000
    )

    public static let gpt4oMini = Self(
        id: "openai-gpt-4o-mini",
        name: "GPT-4o Mini",
        subtitle: "Fast & lightweight cloud",
        provider: .openAICompatible,
        modelIdentifier: "gpt-4o-mini",
        family: "OpenAI Mini",
        parameterCount: "Cloud",
        quantization: "BF16",
        contextWindow: 128_000
    )

    public static let claudeSonnet = Self(
        id: "anthropic-claude-sonnet",
        name: "Claude Sonnet 4.5",
        subtitle: "Anthropic balanced intelligence",
        provider: .anthropic,
        modelIdentifier: "claude-sonnet-4-5",
        family: "Claude 4.5",
        parameterCount: "Cloud",
        quantization: "BF16",
        contextWindow: 200_000
    )

    /// Open-weight MLX catalog from the Braisenly M4 iPad Pro specification, including LFM3-Omni
    public static let openWeightCatalog: [Self] = [
        .lfm3_1_7B_4bit,
        .lfm3_1_7B_bf16,
        .lfm3Omni,
        .qwen3_5_4B,
        .gemma4_e4b
    ]

    public static let defaultProfiles: [Self] = [
        .lfm3_1_7B_4bit,
        .lfm3_1_7B_bf16,
        .lfm3Omni,
        .qwen3_5_4B,
        .gemma4_e4b,
        .appleOnDevice,
        .claudeSonnet,
        .gpt4o,
        .gpt4oMini
    ]
}
