import Foundation

public enum BraisenlySidebarMode: String, CaseIterable, Identifiable, Sendable {
    case files = "Files"
    case search = "Search"
    case tags = "Tags"
    case bookmarks = "Bookmarks"
    case allProperties = "All properties"

    public var id: Self { self }

    public var icon: String {
        switch self {
        case .files: "folder"
        case .search: "magnifyingglass"
        case .tags: "tag"
        case .bookmarks: "bookmark"
        case .allProperties: "archivebox"
        }
    }
}
