import Foundation

public struct AISmartLocalAssistantClient: AIChatClient {
    public init() {}

    public nonisolated func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        let prompt = request.messages.last(where: { $0.role == .user })?.text ?? ""
        let messageCount = request.messages.count
        return AsyncThrowingStream { continuation in
            let task = Task.detached {
                do {
                    for event in Self.buildEvents(for: prompt, messageCount: messageCount) {
                        try Task.checkCancellation()
                        if case .textDelta = event {
                            try await Task.sleep(for: .milliseconds(16))
                        } else {
                            try await Task.sleep(for: .milliseconds(35))
                        }
                        continuation.yield(event)
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

    static func buildEvents(for prompt: String, messageCount: Int) -> [AIChatResponseEvent] {
        var events: [AIChatResponseEvent] = []
        let lowered = prompt.lowercased()

        if lowered.contains("research") || lowered.contains("summarize") || lowered.contains("note") {
            events.append(
                .toolCall(
                    AIToolCall(
                        name: "KnowledgeGraphSearch",
                        summary: "Indexed connected notes & semantic citations",
                        state: .complete
                    )
                )
            )
            events.append(
                .citation(
                    AICitation(
                        title: "Solarized Design Architecture",
                        url: URL(string: "https://ethanschoonover.com/solarized/"),
                        source: "Vault"
                    )
                )
            )
        } else if lowered.contains("code") || lowered.contains("swift") || lowered.contains("outline") {
            events.append(
                .toolCall(
                    AIToolCall(
                        name: "StructureSynthesizer",
                        summary: "Generated structured outline & syntax validation",
                        state: .complete
                    )
                )
            )
            events.append(
                .citation(
                    AICitation(
                        title: "Swift 6 Concurrency Guide",
                        url: URL(string: "https://developer.apple.com/documentation/swift"),
                        source: "Apple Docs"
                    )
                )
            )
        }

        let responseText = Self.composeResponse(for: prompt, turn: messageCount)
        let chunks = Self.tokenize(responseText)
        for chunk in chunks {
            events.append(.textDelta(chunk))
        }
        return events
    }

    private static func composeResponse(for prompt: String, turn: Int) -> String {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let lowered = trimmed.lowercased()

        if lowered.contains("summarize") {
            return """
            Here is a concise synthesis of your research workspace:

            • **Atomic Design Primitives**: Every control in `BraisenlySwiftUI` is built from Solarized Dark & Light tokens with adaptive density across iPhone, iPad, and Mac.
            • **Composable AI Architecture**: `BraisenlyAI` separates foundational primitives, compound chat views, and multi-provider streaming inference models.
            • **Actionable Next Steps**: Pin high-priority threads in the sidebar, compare responses across on-device and cloud models, or export your findings as Markdown.
            """
        }

        if lowered.contains("outline") {
            return """
            Here is a structured outline tailored to your topic:

            1. **Problem Statement & Context** — Define core constraints, user personas, and measurable outcomes.
            2. **System Architecture** — Decompose UI surfaces into Single-Responsibility primitives and observable state sessions.
            3. **Inference & Tooling Layer** — Connect on-device `FoundationModels` alongside OpenAI and Anthropic streaming adapters.
            4. **Verification & Ship Readiness** — Validate with deterministic unit tests, UI automation, and accessibility audits.
            """
        }

        if lowered.contains("idea") || lowered.contains("explore") {
            return """
            Let's explore **"\(trimmed)"** from three complementary angles:

            • **First-Principles View**: Strip away assumptions and focus on the essential user workflow and latency budget.
            • **Hybrid Intelligence**: Use private on-device inference for instant drafting and cloud frontier models when deep multi-step synthesis is required.
            • **Iterative Validation**: Capture key hypotheses as linked notes so every conversation builds durable knowledge.
            """
        }

        return """
        **Analysis for:** *"\(trimmed)"*

        • **Key Insight**: Breaking complex questions into modular, testable steps keeps reasoning transparent and verifiable.
        • **Synthesis**: Across \(max(1, (turn + 1) / 2)) turn(s) in this session, Askenly maintains full conversation context and supports instant regeneration or model switching.
        • **Follow-up**: Ask me to draft code, compare architectural trade-offs, or distil this thread into an executive summary.
        """
    }

    private static func tokenize(_ text: String) -> [String] {
        var tokens: [String] = []
        var current = ""
        for character in text {
            current.append(character)
            if character == " " || character == "\n" {
                tokens.append(current)
                current = ""
            }
        }
        if !current.isEmpty {
            tokens.append(current)
        }
        return tokens
    }
}
