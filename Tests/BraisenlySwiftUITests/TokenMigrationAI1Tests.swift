import Testing

private let files = [
    "Sources/AI/UI/AIChatErrorBanner.swift",
    "Sources/AI/UI/AICitationChip.swift",
    "Sources/AI/UI/AIComposer.swift",
    "Sources/AI/UI/AIEmptyState.swift",
    "Sources/AI/UI/AIMessageBubble.swift",
    "Sources/AI/UI/AIMessageList.swift",
    "Sources/AI/UI/AIStreamingIndicator.swift",
    "Sources/AI/UI/AIToolCallCard.swift",
]

@Test func ai1FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    let v = try SourceScan.violations(in: files)
    #expect(v == [], "\(v)")
}
