import SwiftUI

public struct BraisenlySidebarFooter: View {
    @Environment(\.braisenlyTheme) private var theme

    public let selectedMode: BraisenlySidebarMode
    public let platform: BraisenlyPlatform
    public let onModePickerTap: () -> Void

    public init(
        selectedMode: BraisenlySidebarMode,
        platform: BraisenlyPlatform = .automatic,
        onModePickerTap: @escaping () -> Void
    ) {
        self.selectedMode = selectedMode
        self.platform = platform
        self.onModePickerTap = onModePickerTap
    }

    public var body: some View {
        VStack(spacing: theme.metrics.spacing[.m]) {
            Button(action: onModePickerTap) {
                HStack {
                    Image(systemName: selectedMode.icon)
                    Text(selectedMode.rawValue)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                }
                .padding(.horizontal, theme.metrics.spacing[.l])
                .frame(height: platform.rowHeight)
                .braisenlyCapsule()
            }
            .buttonStyle(.plain)
            HStack {
                VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                    Text("Braisenly").font(theme.typography.vaultTitle)
                    Text("1,002 files, 327 folders").font(theme.typography.metadata)
                }
                Spacer()
                BraisenlyCircleIconButton(
                    systemName: "gearshape",
                    accessibilityLabel: "Settings",
                    platform: platform
                ) {}
            }
        }
        .foregroundStyle(theme.colors.textPrimary)
        .padding(.horizontal, theme.metrics.spacing[.m])
        .padding(.bottom, theme.metrics.spacing[.m])
    }
}
