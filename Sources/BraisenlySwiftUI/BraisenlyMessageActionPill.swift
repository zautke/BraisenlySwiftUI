import SwiftUI

public struct BraisenlyMessageActionPill: View {
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
        HStack(spacing: 12) {
            Button(action: onCopy) {
                Label(
                    isCopied ? "Copied" : "Copy",
                    systemImage: isCopied ? "checkmark" : "doc.on.doc"
                )
                .font(BraisenlyDS.Typography.metadata)
            }
            .buttonStyle(.plain)

            if canRegenerate, let onRegenerate {
                Button(action: onRegenerate) {
                    Label("Regenerate", systemImage: "arrow.clockwise")
                        .font(BraisenlyDS.Typography.metadata)
                }
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .braisenlyCapsule(fill: BraisenlyDS.Colors.surfaceSnippet)
    }
}
