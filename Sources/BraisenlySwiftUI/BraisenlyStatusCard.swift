import SwiftUI

public struct BraisenlyStatusCard: View {
    public let title: String
    public let subtitle: String
    public let systemImage: String
    public let iconColor: Color

    public init(
        title: String,
        subtitle: String = "",
        systemImage: String,
        iconColor: Color = BraisenlyDS.Colors.accentTeal
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.iconColor = iconColor
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(iconColor)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(BraisenlyDS.Typography.rowLabelMedium)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(BraisenlyDS.Typography.metadata)
                        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                }
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
        .padding(12)
        .braisenlyCard(
            cornerRadius: BraisenlyDS.Metrics.snippetRadius,
            fill: BraisenlyDS.Colors.surfaceSnippet
        )
        .accessibilityElement(children: .combine)
    }
}
