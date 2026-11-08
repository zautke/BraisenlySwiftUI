import SwiftUI

public struct BraisenlyHighlightedText: View {
    public let text: String
    public let highlight: String
    public let font: Font
    public let baseColor: Color

    public init(
        _ text: String,
        highlight: String,
        font: Font = BraisenlyDS.Typography.rowLabel,
        baseColor: Color = BraisenlyDS.Colors.textPrimary
    ) {
        self.text = text
        self.highlight = highlight
        self.font = font
        self.baseColor = baseColor
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(BraisenlyHighlightedTextSegment.make(text: text, highlight: highlight)) { segment in
                Text(segment.text)
                    .font(font)
                    .foregroundStyle(segment.isMatch ? BraisenlyDS.Colors.matchForeground : baseColor)
                    .padding(.horizontal, segment.isMatch ? 1.5 : 0)
                    .padding(.vertical, segment.isMatch ? 0.5 : 0)
                    .background {
                        if segment.isMatch {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(BraisenlyDS.Colors.matchBackground)
                        }
                    }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
    }
}
