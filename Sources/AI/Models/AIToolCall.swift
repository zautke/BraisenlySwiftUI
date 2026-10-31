import Foundation

public struct AIToolCall: Identifiable, Codable, Hashable, Sendable {
    public enum State: String, Codable, Sendable {
        case pending
        case running
        case complete
        case failed
    }

    public let id: UUID
    public let name: String
    public var summary: String
    public var state: State

    public init(
        id: UUID = UUID(),
        name: String,
        summary: String = "",
        state: State = .pending
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.state = state
    }
}
