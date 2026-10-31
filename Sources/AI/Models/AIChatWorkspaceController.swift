import Foundation
import Observation

@MainActor
@Observable
public final class AIChatWorkspaceController {
    public private(set) var conversations: [AIConversation]
    public var selectedConversationID: UUID {
        didSet {
            if oldValue != selectedConversationID,
               let target = conversations.first(where: { $0.id == selectedConversationID }) {
                session.loadConversation(target)
            }
        }
    }
    public var searchQuery: String = ""
    public var configuration: AIInferenceConfiguration {
        didSet {
            syncConfigurationToSession()
            saveConfiguration()
        }
    }
    public let session: AIChatSession

    @ObservationIgnored private let store: AIConversationStore
    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private static let configDefaultsKey = "com.zautke.Askenly.inferenceConfig"

    public init(
        store: AIConversationStore = AIConversationStore(),
        defaults: UserDefaults = .standard,
        initialConfiguration: AIInferenceConfiguration? = nil
    ) {
        self.store = store
        self.defaults = defaults

        let loadedConfig: AIInferenceConfiguration
        if let initialConfiguration {
            loadedConfig = initialConfiguration
        } else if let data = defaults.data(forKey: Self.configDefaultsKey),
                  let decoded = try? JSONDecoder().decode(AIInferenceConfiguration.self, from: data) {
            loadedConfig = decoded
        } else {
            loadedConfig = AIInferenceConfiguration()
        }
        self.configuration = loadedConfig

        let loadedConversations = store.loadConversations()
        self.conversations = loadedConversations
        let firstConversation = loadedConversations[0]
        self.selectedConversationID = firstConversation.id

        let initialClient = AIMultiProviderChatClient(configuration: loadedConfig)
        let chatSession = AIChatSession(
            conversation: firstConversation,
            modelID: loadedConfig.activeProfile.modelIdentifier,
            systemPrompt: loadedConfig.systemPrompt,
            temperature: loadedConfig.temperature,
            client: initialClient
        )
        self.session = chatSession

        self.session.updateClient(
            AIMultiProviderChatClient { [weak self] in
                MainActor.assumeIsolated {
                    self?.configuration ?? loadedConfig
                }
            }
        )
    }

    public var filteredConversations: [AIConversation] {
        let sorted = conversations.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned {
                return lhs.isPinned && !rhs.isPinned
            }
            return lhs.updatedAt > rhs.updatedAt
        }
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return sorted }
        return sorted.filter { conversation in
            conversation.title.localizedCaseInsensitiveContains(query)
                || conversation.messages.contains { $0.text.localizedCaseInsensitiveContains(query) }
        }
    }

    public func syncSessionChanges() {
        let current = session.conversation
        if let index = conversations.firstIndex(where: { $0.id == current.id }) {
            conversations[index] = current
        } else {
            conversations.insert(current, at: 0)
        }
        try? store.saveConversations(conversations)
    }

    public func createNewConversation() {
        syncSessionChanges()
        let fresh = AIConversation(title: "New conversation")
        conversations.insert(fresh, at: 0)
        selectedConversationID = fresh.id
        session.loadConversation(fresh)
        try? store.saveConversations(conversations)
    }

    public func selectConversation(_ id: UUID) {
        syncSessionChanges()
        guard let target = conversations.first(where: { $0.id == id }) else { return }
        selectedConversationID = id
        session.loadConversation(target)
    }

    public func deleteConversation(_ id: UUID) {
        conversations.removeAll { $0.id == id }
        if conversations.isEmpty {
            let fresh = AIConversation(title: "New conversation")
            conversations = [fresh]
        }
        if selectedConversationID == id {
            let next = conversations[0]
            selectedConversationID = next.id
            session.loadConversation(next)
        }
        try? store.saveConversations(conversations)
    }

    public func togglePinCurrentConversation() {
        session.togglePinned()
        syncSessionChanges()
    }

    public func clearCurrentConversation() {
        session.clearMessages()
        syncSessionChanges()
    }

    public func selectProfile(_ profile: AIModelProfile) {
        configuration.activeProfile = profile
    }

    public func exportCurrentConversationMarkdown() -> String {
        let current = session.conversation
        var lines: [String] = ["# \(current.title)", ""]
        for message in current.messages where !message.text.isEmpty {
            let speaker = message.role == .user ? "### User" : "### Assistant (\(configuration.activeProfile.name))"
            lines.append(speaker)
            lines.append(message.text)
            lines.append("")
        }
        return lines.joined(separator: "\n")
    }

    private func syncConfigurationToSession() {
        session.modelID = configuration.activeProfile.modelIdentifier
        session.systemPrompt = configuration.systemPrompt
        session.temperature = configuration.temperature
    }

    private func saveConfiguration() {
        if let data = try? JSONEncoder().encode(configuration) {
            defaults.set(data, forKey: Self.configDefaultsKey)
        }
    }
}
