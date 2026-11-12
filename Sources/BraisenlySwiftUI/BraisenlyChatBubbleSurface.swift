import SwiftUI

public struct BraisenlyChatBubbleSurface: View {
    @Environment(\.braisenlyTheme) private var theme

    public let text: String
    public let fill: Color?
    public let foregroundColor: Color?
    public let cornerRadius: CGFloat?

    public init(
        text: String,
        fill: Color? = nil,
        foregroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil
    ) {
        self.text = text
        self.fill = fill
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Text(attributedText)
            .font(theme.typography.bodyReading)
            .foregroundStyle(foregroundColor ?? theme.colors.textPrimary)
            .lineSpacing(3.5)
            .textSelection(.enabled)
            .padding(theme.metrics.spacing[.m])
            .braisenlyCard(cornerRadius: cornerRadius, fill: fill, role: .content)
    }

    private var attributedText: AttributedString {
        if let parsed = try? AttributedString(
            markdown: text,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        ) {
            return parsed
        }
        return AttributedString(text)
    }
}
