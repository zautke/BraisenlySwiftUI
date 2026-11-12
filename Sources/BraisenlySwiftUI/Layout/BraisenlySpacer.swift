import SwiftUI

/// `Spacer` whose minimum length is a theme step (nil = `Spacer()`).
public struct BraisenlySpacer: View {
    @Environment(\.braisenlyTheme) private var theme
    public let minLength: BraisenlyStep?

    public init(minLength: BraisenlyStep? = nil) {
        self.minLength = minLength
    }

    public var body: some View {
        Spacer(minLength: minLength.map { theme.metrics.spacing[$0] })
    }
}
