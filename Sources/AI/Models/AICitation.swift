import Foundation

public struct AICitation: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let url: URL?
    public let source: String?

    public init(id: UUID = UUID(), title: String, url: URL? = nil, source: String? = nil) {
        self.id = id
        self.title = title
        self.url = url
        self.source = source
    }
}
