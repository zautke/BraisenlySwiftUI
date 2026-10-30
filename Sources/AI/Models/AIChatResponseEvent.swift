public enum AIChatResponseEvent: Sendable, Equatable {
    case textDelta(String)
    case toolCall(AIToolCall)
    case citation(AICitation)
    case finished
}
