public enum AIMessageStatus: String, Codable, Sendable {
    case sending
    case streaming
    case complete
    case failed
}
