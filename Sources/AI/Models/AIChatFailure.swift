public enum AIChatFailure: Error, Equatable, Sendable {
    case emptyPrompt
    case responseUnavailable
    case provider(String)

    public var message: String {
        switch self {
        case .emptyPrompt: "Enter a message before sending."
        case .responseUnavailable: "The assistant did not return a response."
        case .provider(let message): message
        }
    }
}
