import Foundation
internal import MLX
internal import MLXLLM
internal import MLXLMCommon

// MARK: - On-Device MLX Weight Downloader & Metal GPU Inference Engine

internal actor AIOnDeviceMLXModelManager {
    public static let shared = AIOnDeviceMLXModelManager()

    private var isRegistered = false
    private var loadedContainers: [String: ModelContainer] = [:]

    private init() {}

    public func resolveHuggingFaceRepoID(for rawModelID: String) -> String {
        switch rawModelID {
        case "mlx-community/LFM3-1.7B-4bit", "LiquidAI/LFM3-1.7B-MLX-4bit":
            return "LiquidAI/LFM3-1.7B-MLX-4bit"
        case "LiquidAI/LFM3-1.7B", "LiquidAI/LFM3-1.7B-MLX-bf16":
            return "LiquidAI/LFM3-1.7B-MLX-bf16"
        case "lfm3-omni", "LiquidAI/LFM3-Omni-2B-MLX-4bit", "LiquidAI/LFM3-Omni":
            return "LiquidAI/LFM3-Omni-2B-MLX-4bit"
        case "mlx-community/Qwen3.5-4B-4bit", "mlx-community/Qwen3.5-4B-MLX-4bit":
            return "mlx-community/Qwen3.5-4B-MLX-4bit"
        case "mlx-community/gemma-4-E4B-it-4bit", "mlx-community/gemma-4-e4b-it-4bit":
            return "mlx-community/gemma-4-e4b-it-4bit"
        default:
            return rawModelID
        }
    }

    private func ensureCustomArchitecturesRegistered() async {
        guard !isRegistered else { return }
        isRegistered = true

        // Configure Apple M4 GPU unified memory budget (256 MB buffer cache, 6 GB working set)
        MLX.GPU.set(cacheLimit: 256 * 1024 * 1024)
        MLX.GPU.set(memoryLimit: 6 * 1024 * 1024 * 1024)

        let lfm3Creator: @Sendable (Data) throws -> any LanguageModel = { data in
            let config = try JSONDecoder().decode(AILFM3Configuration.self, from: data)
            return AILFM3Model(config)
        }
        await LLMTypeRegistry.shared.registerModelType("lfm3", creator: lfm3Creator)
        await LLMTypeRegistry.shared.registerModelType("lfm3_omni", creator: lfm3Creator)

        let gemma4Creator: @Sendable (Data) throws -> any LanguageModel = { data in
            let config = try JSONDecoder().decode(AIGemma4Configuration.self, from: data)
            return AIGemma4Model(config)
        }
        let gemma4TextCreator: @Sendable (Data) throws -> any LanguageModel = { data in
            let config = try JSONDecoder().decode(AIGemma4TextConfiguration.self, from: data)
            return AIGemma4TextModel(config)
        }
        await LLMTypeRegistry.shared.registerModelType("gemma4", creator: gemma4Creator)
        await LLMTypeRegistry.shared.registerModelType("gemma4_unified", creator: gemma4Creator)
        await LLMTypeRegistry.shared.registerModelType("gemma4_text", creator: gemma4TextCreator)
    }

    public func loadContainer(
        for rawModelID: String,
        onProgress: @escaping @Sendable (Double, String) -> Void
    ) async throws -> (ModelContainer, String, Bool) {
        await ensureCustomArchitecturesRegistered()
        let repoID = resolveHuggingFaceRepoID(for: rawModelID)

        if let existing = loadedContainers[repoID] {
            return (existing, repoID, false)
        }

        // Evict previous model container before loading a new multi-GB model on iPad unified RAM
        loadedContainers.removeAll()
        MLX.GPU.clearCache()

        let modelConfig = ModelConfiguration(
            id: repoID,
            extraEOSTokens: ["<|im_end|>", "<|endoftext|>", "<end_of_turn>"]
        )

        let container = try await LLMModelFactory.shared.loadContainer(
            configuration: modelConfig
        ) { progress in
            let fraction = min(max(progress.fractionCompleted, 0.0), 1.0)
            let completed = progress.completedUnitCount
            let total = max(progress.totalUnitCount, 1)
            let status = "Downloading \(repoID) from Hugging Face (\(Int(fraction * 100))% • file \(completed)/\(total))"
            onProgress(fraction, status)
        }

        loadedContainers[repoID] = container
        return (container, repoID, true)
    }
}

public struct AIOnDeviceMLXChatClient: AIChatClient {
    public let modelIdentifier: String

    public init(modelIdentifier: String) {
        self.modelIdentifier = modelIdentifier
    }

    public func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        let targetModelID: String
        if let requested = request.modelID, !requested.isEmpty {
            targetModelID = requested
        } else {
            targetModelID = modelIdentifier
        }

        return AsyncThrowingStream { continuation in
            let task = Task {
                let downloadCallID = UUID()
                do {
                    let repoID = await AIOnDeviceMLXModelManager.shared.resolveHuggingFaceRepoID(for: targetModelID)

                    final class ProgressThrottle: @unchecked Sendable {
                        var lastBucket: Int = -1
                        var didEmitDownloadToolCall = false
                    }
                    let throttle = ProgressThrottle()

                    let (container, resolvedRepoID, didDownloadOrLoad) = try await AIOnDeviceMLXModelManager.shared.loadContainer(
                        for: targetModelID
                    ) { fraction, statusText in
                        let bucket = Int((fraction * 20.0).rounded(.down))
                        guard bucket != throttle.lastBucket else { return }
                        throttle.lastBucket = bucket
                        throttle.didEmitDownloadToolCall = true

                        continuation.yield(
                            .toolCall(
                                AIToolCall(
                                    id: downloadCallID,
                                    name: "huggingface_mlx_loader",
                                    summary: statusText,
                                    state: fraction >= 1.0 ? .complete : .running
                                )
                            )
                        )
                    }

                    if didDownloadOrLoad || throttle.didEmitDownloadToolCall {
                        continuation.yield(
                            .toolCall(
                                AIToolCall(
                                    id: downloadCallID,
                                    name: "huggingface_mlx_loader",
                                    summary: "Loaded \(resolvedRepoID) weights onto Apple M4 Metal GPU",
                                    state: .complete
                                )
                            )
                        )
                    }

                    // Build prior conversation history (excluding latest user message which we pass to streamDetails)
                    var historyMessages: [Chat.Message] = []
                    let nonEmptyMessages = request.messages.filter {
                        !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }
                    let priorMessages = nonEmptyMessages.dropLast()
                    for msg in priorMessages {
                        switch msg.role {
                        case .system:
                            historyMessages.append(.system(msg.text))
                        case .user:
                            historyMessages.append(.user(msg.text))
                        case .assistant:
                            historyMessages.append(.assistant(msg.text))
                        case .tool:
                            historyMessages.append(.tool(msg.text))
                        }
                    }

                    let latestPrompt = nonEmptyMessages.last?.text
                        ?? request.messages.last?.text
                        ?? "Hello"

                    let params = GenerateParameters(
                        maxTokens: 2048,
                        temperature: Float(request.temperature),
                        topP: 0.95
                    )

                    let chatSession = MLXLMCommon.ChatSession(
                        container,
                        instructions: request.systemPrompt,
                        history: historyMessages,
                        generateParameters: params
                    )

                    for try await generation in chatSession.streamDetails(
                        to: latestPrompt,
                        role: .user,
                        images: [],
                        videos: []
                    ) {
                        if Task.isCancelled { break }

                        switch generation {
                        case .chunk(let chunk):
                            if !chunk.isEmpty {
                                continuation.yield(.textDelta(chunk))
                            }

                        case .info(let info):
                            let tokPerSec = String(format: "%.1f", info.tokensPerSecond)
                            continuation.yield(
                                .toolCall(
                                    AIToolCall(
                                        id: downloadCallID,
                                        name: "mlx_metal_telemetry",
                                        summary: "\(resolvedRepoID) • \(tokPerSec) tok/s • \(info.generationTokenCount) tokens on M4 GPU",
                                        state: .complete
                                    )
                                )
                            )

                        case .toolCall(let toolCall):
                            continuation.yield(
                                .toolCall(
                                    AIToolCall(
                                        name: toolCall.function.name,
                                        summary: "\(toolCall.function.arguments)",
                                        state: .complete
                                    )
                                )
                            )
                        }
                    }

                    continuation.yield(.finished)
                    continuation.finish()
                } catch {
                    continuation.finish(
                        throwing: AIChatFailure.provider(
                            "MLX on-device inference error (\(targetModelID)): \(error.localizedDescription)"
                        )
                    )
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
