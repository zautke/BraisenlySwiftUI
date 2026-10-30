import SwiftUI

public struct BraisenlyTabCounterBadge: View {
    public let count: Int

    public init(count: Int) {
        self.count = count
    }

    public var body: some View {
        Text(count, format: .number)
            .font(BraisenlyDS.Typography.badgeNumber)
            .foregroundStyle(BraisenlyDS.Colors.textPrimary)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .strokeBorder(BraisenlyDS.Colors.textPrimary, lineWidth: 1.6)
            )
            .accessibilityLabel("\(count) tabs")
    }
}
