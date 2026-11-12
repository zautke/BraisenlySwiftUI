import SwiftUI

public struct BraisenlyPromptField: View {
    @Environment(\.braisenlyTheme) private var theme
    @Binding private var text: String

    public let placeholder: LocalizedStringResource
    /// nil = `theme.metrics.radius[.l]`.
    public let cornerRadius: CGFloat?
    /// nil = `theme.colors.surfaceElevated`.
    public let fill: Color?
    public let onSubmit: () -> Void

    public init(
        _ placeholder: LocalizedStringResource = "Message Braisenly…",
        text: Binding<String>,
        cornerRadius: CGFloat? = nil,
        fill: Color? = nil,
        onSubmit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        _text = text
        self.cornerRadius = cornerRadius
        self.fill = fill
        self.onSubmit = onSubmit
    }

    public var body: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .textFieldStyle(.plain)
            .font(theme.typography.rowLabel)
            .foregroundStyle(theme.colors.textPrimary)
            .lineLimit(1...6)
            .padding(.horizontal, theme.metrics.spacing[.m])
            .padding(.vertical, theme.metrics.spacing[.m])
            .braisenlyCard(cornerRadius: cornerRadius, fill: fill, role: .chrome)
            .onSubmit(onSubmit)
    }
}
