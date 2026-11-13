import SwiftUI

/// One wrapped paragraph whose case-insensitive matches of `highlight` carry an inline,
/// baseline-aligned rounded highlight (drawn by a `TextRenderer`, so the run never leaves the text flow).
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
        let base = baseColor ?? theme.colors.textPrimary
        BraisenlyHighlightedTextSegment.make(text: text, highlight: highlight)
            .reduce(Text(verbatim: "")) { paragraph, segment in
                let run = Text(verbatim: segment.text)
                    .foregroundStyle(segment.isMatch ? theme.colors.matchForeground : base)
                let styled = segment.isMatch ? run.customAttribute(BraisenlyHighlightMatchAttribute()) : run
                return Text("\(paragraph)\(styled)")
            }
            .font(font ?? theme.typography.rowLabel)
            .textRenderer(BraisenlyHighlightRenderer(
                fill: theme.colors.matchBackground,
                cornerRadius: theme.metrics.radius[.xs],
                outset: theme.metrics.hairline
            ))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(text)
    }
}

/// Marks a matched run inside the paragraph.
struct BraisenlyHighlightMatchAttribute: TextAttribute {}

/// Paints a rounded fill behind every matched run, then draws the text on top.
struct BraisenlyHighlightRenderer: TextRenderer {
    let fill: Color
    let cornerRadius: CGFloat
    let outset: CGFloat

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            for run in line where run[BraisenlyHighlightMatchAttribute.self] != nil {
                let rect = run.typographicBounds.rect.insetBy(dx: -outset, dy: 0)
                context.fill(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).path(in: rect),
                    with: .color(fill)
                )
            }
        }
        for line in layout {
            context.draw(line)
        }
    }
}
