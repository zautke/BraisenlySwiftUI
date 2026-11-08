public enum AIMessageRole: String, Codable, CaseIterable, Sendable {
    case system
    case user
    case assistant
    case tool
}
