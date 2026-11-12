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
        HStack(spacing: theme.metrics.spacing[.m]) {
            Circle()
                .fill(color)
                .overlay(Circle().strokeBorder(theme.colors.borderSubtle, lineWidth: theme.metrics.hairline))
                .frame(width: theme.metrics.circleButtonSize, height: theme.metrics.circleButtonSize)
                .padding(theme.metrics.spacing[.xs])
                .overlay(
                    Circle().strokeBorder(theme.colors.accentTeal, lineWidth: isSelected ? theme.metrics.hairline * 2 : 0)
                )
            VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                Text(name)
                    .font(theme.typography.metadata)
                    .foregroundStyle(theme.colors.textPrimary)
                if let detail {
                    Text(detail)
                        .font(theme.typography.code)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(name)
        .accessibilityValue(detail ?? "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
