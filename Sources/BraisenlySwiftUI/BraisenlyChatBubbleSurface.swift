import SwiftUI

public struct BraisenlyChatBubbleSurface: View {
    public let text: String
    public let fill: Color
    public let foregroundColor: Color
    public let cornerRadius: CGFloat

    public init(
        text: String,
        fill: Color = BraisenlyDS.Colors.surfaceElevated,
        foregroundColor: Color = BraisenlyDS.Colors.textPrimary,
        cornerRadius: CGFloat = 18
    ) {
        self.text = text
        self.fill = fill
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Text(attributedText)
            .font(BraisenlyDS.Typography.bodyReading)
            .foregroundStyle(foregroundColor)
            .lineSpacing(3.5)
            .textSelection(.enabled)
            .padding(14)
            .braisenlyCard(cornerRadius: cornerRadius, fill: fill)
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
