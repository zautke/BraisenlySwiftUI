import Foundation
import Observation

@MainActor
@Observable
public final class AIChatSession {
    public private(set) var conversation: AIConversation
    public var draft: String
    public var modelID: String?
    public var systemPrompt: String?
    public var temperature: Double
    public private(set) var isResponding: Bool
    public private(set) var failure: AIChatFailure?

    public var messages: [AIMessage] { conversation.messages }

    @ObservationIgnored private var client: any AIChatClient
    @ObservationIgnored private var onConversationUpdated: ((AIConversation) -> Void)?
    @ObservationIgnored private var responseTask: Task<Void, Never>?

    public init(
        conversation: AIConversation = AIConversation(),
        draft: String = "",
        modelID: String? = nil,
        systemPrompt: String? = nil,
        temperature: Double = 0.7,
        client: any AIChatClient,
        onConversationUpdated: ((AIConversation) -> Void)? = nil
    ) {
        self.conversation = conversation
        self.draft = draft
        self.modelID = modelID
        self.systemPrompt = systemPrompt
        self.temperature = temperature
        self.client = client
        self.onConversationUpdated = onConversationUpdated
        isResponding = false
    }

    deinit {
        responseTask?.cancel()
    }

    public func updateClient(_ newClient: any AIChatClient) {
        client = newClient
    }

    public func loadConversation(_ newConversation: AIConversation) {
        cancel()
        conversation = newConversation
        failure = nil
    }

    public func renameConversation(_ newTitle: String) {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        conversation.title = trimmed
        conversation.updatedAt = .now
        onConversationUpdated?(conversation)
    }

    public func togglePinned() {
        conversation.isPinned.toggle()
        conversation.updatedAt = .now
        onConversationUpdated?(conversation)
    }

    public func clearMessages() {
        cancel()
        conversation.messages.removeAll()
        conversation.updatedAt = .now
        onConversationUpdated?(conversation)
    }

    public func send() {
        let prompt = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty, !isResponding else {
            if prompt.isEmpty { failure = .emptyPrompt }
            return
        }

        draft = ""
        failure = nil
        if conversation.messages.isEmpty && conversation.title == "New conversation" {
            conversation.title = Self.deriveTitle(from: prompt)
        }
        let userMessage = AIMessage(role: .user, text: prompt)
        conversation.messages.append(userMessage)
        conversation.updatedAt = .now
        onConversationUpdated?(conversation)
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
        onConversationUpdated?(conversation)
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
                systemPrompt: systemPrompt,
                temperature: temperature
            )
            let stream = try await client.streamResponse(to: request)
            for try await event in stream {
                try Task.checkCancellation()
                apply(event, to: assistantID)
            }
            completeMessage(assistantID)
        } catch is CancellationError {
            completeMessage(assistantID)
        } catch let chatFailure as AIChatFailure {
            failMessage(assistantID)
            failure = chatFailure
        } catch {
            failMessage(assistantID)
            failure = .provider(error.localizedDescription)
        }

        responseTask = nil
        isResponding = false
        conversation.updatedAt = .now
        onConversationUpdated?(conversation)
    }

    private func apply(_ event: AIChatResponseEvent, to id: UUID) {
        guard let index = conversation.messages.firstIndex(where: { $0.id == id }) else { return }
        switch event {
        case .textDelta(let delta):
            conversation.messages[index].text.append(delta)
        case .toolCall(let toolCall):
            if let existing = conversation.messages[index].toolCalls.firstIndex(where: { $0.id == toolCall.id }) {
                conversation.messages[index].toolCalls[existing] = toolCall
            } else {
                conversation.messages[index].toolCalls.append(toolCall)
            }
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

    private static func deriveTitle(from prompt: String) -> String {
        let firstLine = prompt.split(whereSeparator: \.isNewline).first.map(String.init) ?? prompt
        if firstLine.count <= 38 {
            return firstLine
        }
        return String(firstLine.prefix(35)) + "…"
    }
}
