import SwiftUI

public struct BraisenlySearchMetadataRow: View {
    @Environment(\.braisenlyTheme) private var theme

    public init() {}

    public var body: some View {
        HStack {
            Text("3 results")
            Spacer()
            Label("File name (A to Z)", systemImage: "chevron.up.chevron.down")
        }
        .font(theme.typography.metadata)
        .foregroundStyle(theme.colors.textSecondary)
        .padding(.horizontal, theme.metrics.spacing[.l])
        .padding(.vertical, theme.metrics.spacing[.m])
    }
}
