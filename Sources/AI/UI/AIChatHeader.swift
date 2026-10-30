import BraisenlySwiftUI
import SwiftUI

public struct AIChatHeader: View {
    @Binding private var theme: BraisenlyTheme

    public let title: String
    public let modelName: String?
    public let platform: BraisenlyPlatform

    public init(
        title: String,
        modelName: String? = nil,
        theme: Binding<BraisenlyTheme>,
        platform: BraisenlyPlatform = .automatic
    ) {
        self.title = title
        self.modelName = modelName
        _theme = theme
        self.platform = platform
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .foregroundStyle(BraisenlyDS.Colors.accentTeal)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(BraisenlyDS.Typography.rowLabelMedium)
                    .foregroundStyle(BraisenlyDS.Colors.textBright)
                if let modelName {
                    Text(modelName)
                        .font(BraisenlyDS.Typography.metadata)
                        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                }
            }
            Spacer()
            BraisenlyThemeToggle(theme: $theme, platform: platform)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(BraisenlyDS.Colors.backgroundPrimary.opacity(0.96))
        .overlay(alignment: .bottom) { Divider().overlay(BraisenlyDS.Colors.divider) }
    }
}
