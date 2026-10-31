import Foundation

public struct AIConversationStore: Sendable {
    public let fileURL: URL

    public init(fileURL: URL? = nil) {
        if let fileURL {
            self.fileURL = fileURL
        } else {
            let directory = URL.documentsDirectory.appending(path: "AskenlyConversations", directoryHint: .isDirectory)
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            self.fileURL = directory.appending(path: "conversations.json")
        }
    }

    public func loadConversations() -> [AIConversation] {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([AIConversation].self, from: data),
              !decoded.isEmpty else {
            return [AIConversation(title: "New conversation")]
        }
        return decoded
    }

    public func saveConversations(_ conversations: [AIConversation]) throws {
        let parent = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(conversations)
        try data.write(to: fileURL, options: .atomic)
    }
}
