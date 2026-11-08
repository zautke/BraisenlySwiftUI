import Foundation

public struct AIConversation: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var messages: [AIMessage]
    public var isPinned: Bool
    public let createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        title: String = "New conversation",
        messages: [AIMessage] = [],
        isPinned: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.messages = messages
        self.isPinned = isPinned
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public var lastMessagePreview: String {
        guard let last = messages.last(where: { !$0.text.isEmpty }) else {
            return "No messages yet"
        }
        return last.text.replacingOccurrences(of: "\n", with: " ")
    }
}
