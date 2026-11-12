import SwiftUI

/// `Divider` tinted with `theme.colors.divider`.
public struct BraisenlyDivider: View {
    @Environment(\.braisenlyTheme) private var theme

    public init() {}

    public var body: some View {
        Divider().overlay(theme.colors.divider)
    }
}
