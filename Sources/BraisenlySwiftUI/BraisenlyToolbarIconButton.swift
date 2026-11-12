import SwiftUI

public struct BraisenlyToolbarIconButton: View {
    @Environment(\.braisenlyTheme) private var theme

    public let systemName: String
    public let label: LocalizedStringResource
    public let isEnabled: Bool
    public let action: () -> Void

    public init(
        systemName: String,
        label: LocalizedStringResource,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.label = label
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(theme.typography.controlIcon)
                .foregroundStyle(isEnabled ? theme.colors.textPrimary : theme.colors.textDisabled)
        }
        .disabled(!isEnabled)
        .accessibilityLabel(Text(label))
    }
}
