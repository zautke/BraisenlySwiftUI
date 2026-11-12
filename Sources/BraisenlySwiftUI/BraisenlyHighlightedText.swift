import SwiftUI

public struct BraisenlyHighlightedText: View {
    @Environment(\.braisenlyTheme) private var theme

    public let text: String
    public let highlight: String
    /// nil = `theme.typography.rowLabel`.
    public let font: Font?
    /// nil = `theme.colors.textPrimary`.
    public let baseColor: Color?

    public init(
        _ text: String,
        highlight: String,
        font: Font? = nil,
        baseColor: Color? = nil
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
                    .font(font ?? theme.typography.rowLabel)
                    .foregroundStyle(segment.isMatch ? theme.colors.matchForeground : (baseColor ?? theme.colors.textPrimary))
                    .padding(.horizontal, segment.isMatch ? theme.metrics.hairline * 3 : 0)
                    .padding(.vertical, segment.isMatch ? theme.metrics.hairline : 0)
                    .background {
                        if segment.isMatch {
                            RoundedRectangle(cornerRadius: theme.metrics.radius[.xs], style: .continuous)
                                .fill(theme.colors.matchBackground)
                        }
                    }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
    }
}
