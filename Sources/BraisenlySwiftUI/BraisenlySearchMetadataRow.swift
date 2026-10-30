import SwiftUI

public struct BraisenlySearchMetadataRow: View {
    public init() {}

    public var body: some View {
        HStack {
            Text("3 results")
            Spacer()
            Label("File name (A to Z)", systemImage: "chevron.up.chevron.down")
        }
        .font(BraisenlyDS.Typography.metadata)
        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
