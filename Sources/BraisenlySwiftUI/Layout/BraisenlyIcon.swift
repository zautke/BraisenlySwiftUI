import SwiftUI

/// SF Symbol styled from the environment theme's typography and color tokens.
public struct BraisenlyIcon: View {
    @Environment(\.braisenlyTheme) private var theme
    public let systemName: String
    public let size: BraisenlyIconSize
    public let tone: BraisenlyTone

    public init(systemName: String, size: BraisenlyIconSize = .medium, tone: BraisenlyTone = .primary) {
        self.systemName = systemName
        self.size = size
        self.tone = tone
    }

    public var body: some View {
        Image(systemName: systemName)
            .font(size.font(in: theme.typography))
            .foregroundStyle(tone.color(in: theme.colors))
    }
}
