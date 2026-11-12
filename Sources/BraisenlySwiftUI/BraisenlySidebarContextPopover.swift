import SwiftUI

public struct BraisenlySidebarContextPopover: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding private var selectedMode: BraisenlySidebarMode
    @Binding private var isPresented: Bool

    public let platform: BraisenlyPlatform

    public init(
        selectedMode: Binding<BraisenlySidebarMode>,
        isPresented: Binding<Bool>,
        platform: BraisenlyPlatform = .automatic
    ) {
        _selectedMode = selectedMode
        _isPresented = isPresented
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
            ForEach(BraisenlySidebarMode.allCases) { mode in
                Button {
                    selectedMode = mode
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) { isPresented = false }
                } label: {
                    HStack(spacing: theme.metrics.spacing[.m]) {
                        Image(systemName: mode.icon).frame(width: 24)
                        Text(mode.rawValue).font(theme.typography.rowLabelMedium)
                        Spacer()
                    }
                    .foregroundStyle(theme.colors.textBright)
                    .padding(.horizontal, theme.metrics.spacing[.m])
                    .frame(height: resolvedPlatform.rowHeight)
                    .background {
                        if mode == selectedMode {
                            Capsule(style: .continuous).fill(theme.colors.surfaceHighlight)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(theme.metrics.spacing[.s])
        .braisenlyCard(cornerRadius: theme.metrics.radius[.xl], role: .chrome)
        .shadow(color: theme.surface == .solid ? theme.colors.shadow : .clear, radius: 20, x: 0, y: 8)
    }
}
