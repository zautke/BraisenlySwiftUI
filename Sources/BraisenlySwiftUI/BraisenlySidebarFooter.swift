import SwiftUI

public struct BraisenlySidebarFooter: View {
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
        VStack(spacing: 14) {
            Button(action: onModePickerTap) {
                HStack {
                    Image(systemName: selectedMode.icon)
                    Text(selectedMode.rawValue)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                }
                .padding(.horizontal, 18)
                .frame(height: platform.rowHeight)
                .braisenlyCapsule()
            }
            .buttonStyle(.plain)
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Braisenly").font(BraisenlyDS.Typography.vaultTitle)
                    Text("1,002 files, 327 folders").font(BraisenlyDS.Typography.metadata)
                }
                Spacer()
                BraisenlyCircleIconButton(
                    systemName: "gearshape",
                    accessibilityLabel: "Settings",
                    platform: platform
                ) {}
            }
        }
        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
        .padding(.horizontal, 14)
        .padding(.bottom, 12)
    }
}
