import SwiftUI

/// Color circle with name and optional detail; a button when `action` is provided.
public struct BraisenlyColorSwatch: View {
    @Environment(\.braisenlyTheme) private var theme

    public let name: String
    public let detail: String?
    public let isSelected: Bool
    private let color: Color
    private let action: (() -> Void)?

    public var isInteractive: Bool { action != nil }

    /// Smallest shrink applied to the name/detail before middle truncation.
    static let minimumNameScale: CGFloat = 0.8

    public init(color: Color, name: String, detail: String? = nil, isSelected: Bool = false, action: (() -> Void)? = nil) {
        self.color = color
        self.name = name
        self.detail = detail
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        if let action {
            Button(action: action) { content.contentShape(Rectangle()) }.buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
        // Name sits under the circle so it gets the full column width; one line, middle-truncated,
        // never hyphenated mid-word.
        VStack(spacing: theme.metrics.spacing[.xs]) {
            Circle()
                .fill(color)
                .overlay(Circle().strokeBorder(theme.colors.borderSubtle, lineWidth: theme.metrics.hairline))
                .frame(width: theme.metrics.circleButtonSize, height: theme.metrics.circleButtonSize)
                .padding(theme.metrics.spacing[.xs])
                .overlay(
                    Circle().strokeBorder(theme.colors.accentTeal, lineWidth: isSelected ? theme.metrics.hairline * 2 : 0)
                )
            if !name.isEmpty {
                Text(name)
                    .font(theme.typography.metadata)
                    .foregroundStyle(theme.colors.textPrimary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .minimumScaleFactor(Self.minimumNameScale)
            }
            if let detail, !detail.isEmpty {
                Text(detail)
                    .font(theme.typography.code)
                    .foregroundStyle(theme.colors.textSecondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .minimumScaleFactor(Self.minimumNameScale)
            }
        }
        .multilineTextAlignment(.center)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(name)
        .accessibilityValue(detail ?? "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
