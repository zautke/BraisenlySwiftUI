import Testing

private let files = [
    "Sources/AI/UI/AIChatHeader.swift",
    "Sources/AI/UI/AIChatView.swift",
    "Sources/AI/UI/AIChatWorkspaceView.swift",
    "Sources/AI/UI/AIConversationActionSheet.swift",
    "Sources/AI/UI/AIConversationSidebar.swift",
    "Sources/AI/UI/AIModelSettingsSheet.swift",
]

@Test func ai2FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    #expect(try SourceScan.violations(in: files) == [])
}
