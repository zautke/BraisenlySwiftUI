import SwiftUI

/// `Text` styled from the environment theme's typography and color tokens.
public struct BraisenlyText: View {
    @Environment(\.braisenlyTheme) private var theme
    private let text: Text
    public let style: BraisenlyTextStyle
    public let tone: BraisenlyTone

    public init(_ key: LocalizedStringKey, style: BraisenlyTextStyle = .rowLabel, tone: BraisenlyTone = .primary) {
        self.text = Text(key)
        self.style = style
        self.tone = tone
    }

    @_disfavoredOverload
    public init<S: StringProtocol>(_ content: S, style: BraisenlyTextStyle = .rowLabel, tone: BraisenlyTone = .primary) {
        self.text = Text(content)
        self.style = style
        self.tone = tone
    }

    public var body: some View {
        text
            .font(style.font(in: theme.typography))
            .foregroundStyle(tone.color(in: theme.colors))
    }
}
