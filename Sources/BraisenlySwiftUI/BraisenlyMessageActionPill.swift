import SwiftUI

public struct BraisenlyMessageActionPill: View {
    @Environment(\.braisenlyTheme) private var theme

    public let isCopied: Bool
    public let canRegenerate: Bool
    public let onCopy: () -> Void
    public let onRegenerate: (() -> Void)?

    public init(
        isCopied: Bool = false,
        canRegenerate: Bool = false,
        onCopy: @escaping () -> Void,
        onRegenerate: (() -> Void)? = nil
    ) {
        self.isCopied = isCopied
        self.canRegenerate = canRegenerate
        self.onCopy = onCopy
        self.onRegenerate = onRegenerate
    }

    public var body: some View {
        HStack(spacing: theme.metrics.spacing[.m]) {
            Button(action: onCopy) {
                Label(
                    isCopied ? "Copied" : "Copy",
                    systemImage: isCopied ? "checkmark" : "doc.on.doc"
                )
                .font(theme.typography.metadata)
            }
            .buttonStyle(.plain)

            if canRegenerate, let onRegenerate {
                Button(action: onRegenerate) {
                    Label("Regenerate", systemImage: "arrow.clockwise")
                        .font(theme.typography.metadata)
                }
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(theme.colors.textSecondary)
        .padding(.horizontal, theme.metrics.spacing[.s])
        .padding(.vertical, theme.metrics.spacing[.xs])
        .braisenlyCapsule(fill: theme.colors.surfaceSnippet)
    }
}
