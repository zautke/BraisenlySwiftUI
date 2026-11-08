import Foundation

public struct BraisenlyActionItem: Identifiable, Sendable, Equatable {
    public let id: String
    public let icon: String
    public let title: LocalizedStringResource
    public var isChecked: Bool

    public init(
        id: String,
        icon: String,
        title: LocalizedStringResource,
        isChecked: Bool = false
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.isChecked = isChecked
    }
}
