import Foundation

public struct AIMessage: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public let role: AIMessageRole
    public var text: String
    public let createdAt: Date
    public var status: AIMessageStatus
    public var citations: [AICitation]
    public var toolCalls: [AIToolCall]

    public init(
        id: UUID = UUID(),
        role: AIMessageRole,
        text: String,
        createdAt: Date = .now,
        status: AIMessageStatus = .complete,
        citations: [AICitation] = [],
        toolCalls: [AIToolCall] = []
    ) {
        self.id = id
        self.role = role
        self.text = text
        self.createdAt = createdAt
        self.status = status
        self.citations = citations
        self.toolCalls = toolCalls
    }
}
