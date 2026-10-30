import SwiftUI

public struct BraisenlySidebarContextPopover: View {
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
        VStack(alignment: .leading, spacing: 2) {
            ForEach(BraisenlySidebarMode.allCases) { mode in
                Button {
                    selectedMode = mode
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) { isPresented = false }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: mode.icon).frame(width: 24)
                        Text(mode.rawValue).font(BraisenlyDS.Typography.rowLabelMedium)
                        Spacer()
                    }
                    .foregroundStyle(BraisenlyDS.Colors.textBright)
                    .padding(.horizontal, 14)
                    .frame(height: resolvedPlatform.rowHeight)
                    .background {
                        if mode == selectedMode {
                            Capsule(style: .continuous).fill(BraisenlyDS.Colors.surfaceHighlight)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(resolvedPlatform == .mac ? 8 : 10)
        .braisenlyCard(cornerRadius: BraisenlyDS.Metrics.popoverRadius)
        .shadow(color: .black.opacity(0.45), radius: 20, x: 0, y: 8)
    }
}
