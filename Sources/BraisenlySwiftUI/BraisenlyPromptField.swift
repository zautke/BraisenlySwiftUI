import SwiftUI

public struct BraisenlyPromptField: View {
    @Binding private var text: String

    public let placeholder: LocalizedStringResource
    public let cornerRadius: CGFloat
    public let fill: Color
    public let onSubmit: () -> Void

    public init(
        _ placeholder: LocalizedStringResource = "Message Braisenly…",
        text: Binding<String>,
        cornerRadius: CGFloat = 18,
        fill: Color = BraisenlyDS.Colors.surfaceElevated,
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
            .font(BraisenlyDS.Typography.rowLabel)
            .foregroundStyle(BraisenlyDS.Colors.textPrimary)
            .lineLimit(1...6)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .braisenlyCard(cornerRadius: cornerRadius, fill: fill)
            .onSubmit(onSubmit)
    }
}
