import Foundation
import Observation

@MainActor
@Observable
public final class AIChatSession {
    public private(set) var conversation: AIConversation
    public var draft: String
    public private(set) var isResponding: Bool
    public private(set) var failure: AIChatFailure?

    public var messages: [AIMessage] { conversation.messages }

    @ObservationIgnored private let client: any AIChatClient
    @ObservationIgnored private let modelID: String?
    @ObservationIgnored private let systemPrompt: String?
    @ObservationIgnored private var responseTask: Task<Void, Never>?

    public init(
        conversation: AIConversation = AIConversation(),
        draft: String = "",
        modelID: String? = nil,
        systemPrompt: String? = nil,
        client: any AIChatClient
    ) {
        self.conversation = conversation
        self.draft = draft
        self.modelID = modelID
        self.systemPrompt = systemPrompt
        self.client = client
        isResponding = false
    }

    deinit {
        responseTask?.cancel()
    }

    public func send() {
        let prompt = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty, !isResponding else {
            if prompt.isEmpty { failure = .emptyPrompt }
            return
        }

        draft = ""
        failure = nil
        let userMessage = AIMessage(role: .user, text: prompt)
        conversation.messages.append(userMessage)
        conversation.updatedAt = .now
        isResponding = true

        responseTask = Task { [weak self] in
            await self?.receiveResponse()
        }
    }

    public func cancel() {
        responseTask?.cancel()
        responseTask = nil
        isResponding = false
        markStreamingMessageComplete()
    }

    public func regenerateLastResponse() {
        guard !isResponding,
              let assistantIndex = conversation.messages.lastIndex(where: { $0.role == .assistant }) else {
            return
        }
        conversation.messages.remove(at: assistantIndex)
        isResponding = true
        responseTask = Task { [weak self] in
            await self?.receiveResponse()
        }
    }

    public func clearFailure() {
        failure = nil
    }

    private func receiveResponse() async {
        let assistantID = UUID()
        conversation.messages.append(
            AIMessage(id: assistantID, role: .assistant, text: "", status: .streaming)
        )

        do {
            let request = AIChatRequest(
                messages: conversation.messages.filter { $0.id != assistantID },
                modelID: modelID,
                systemPrompt: systemPrompt
            )
            let stream = try await client.streamResponse(to: request)
            for try await event in stream {
                try Task.checkCancellation()
                apply(event, to: assistantID)
            }
            completeMessage(assistantID)
        } catch is CancellationError {
            completeMessage(assistantID)
        } catch {
            failMessage(assistantID)
            failure = .provider(error.localizedDescription)
        }

        responseTask = nil
        isResponding = false
        conversation.updatedAt = .now
    }

    private func apply(_ event: AIChatResponseEvent, to id: UUID) {
        guard let index = conversation.messages.firstIndex(where: { $0.id == id }) else { return }
        switch event {
        case .textDelta(let delta):
            conversation.messages[index].text.append(delta)
        case .toolCall(let toolCall):
            conversation.messages[index].toolCalls.append(toolCall)
        case .citation(let citation):
            conversation.messages[index].citations.append(citation)
        case .finished:
            conversation.messages[index].status = .complete
        }
    }

    private func completeMessage(_ id: UUID) {
        guard let index = conversation.messages.firstIndex(where: { $0.id == id }) else { return }
        conversation.messages[index].status = .complete
    }

    private func failMessage(_ id: UUID) {
        guard let index = conversation.messages.firstIndex(where: { $0.id == id }) else { return }
        conversation.messages[index].status = .failed
    }

    private func markStreamingMessageComplete() {
        guard let index = conversation.messages.lastIndex(where: { $0.status == .streaming }) else { return }
        conversation.messages[index].status = .complete
    }
}
