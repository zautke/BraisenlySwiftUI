import SwiftUI

public struct BraisenlyCodeBlockCard: View {
    @Environment(\.braisenlyTheme) private var theme

    public let language: String?
    public let code: String
    public let onCopy: (() -> Void)?

    public init(
        language: String? = nil,
        code: String,
        onCopy: (() -> Void)? = nil
    ) {
        self.language = language
        self.code = code
        self.onCopy = onCopy
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(language?.isEmpty == false ? language! : "code")
                    .font(theme.typography.metadata)
                    .foregroundStyle(theme.colors.accentTeal)
                Spacer()
                if let onCopy {
                    Button(action: onCopy) {
                        Label("Copy", systemImage: "doc.on.doc")
                            .font(theme.typography.metadata)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, theme.metrics.spacing[.m])
            .padding(.vertical, theme.metrics.spacing[.s])
            .background(theme.colors.surfaceElevated.opacity(0.75))

            Divider().overlay(theme.colors.divider)

            ScrollView(.horizontal) {
                Text(code)
                    .font(theme.typography.code)
                    .foregroundStyle(theme.colors.textBright)
                    .textSelection(.enabled)
                    .padding(theme.metrics.spacing[.m])
            }
            // `.never`, not `.hidden`: macOS keeps legacy scrollers visible for `.hidden` when
            // "Show scroll bars" is Always or a mouse is attached. Lines still scroll horizontally.
            .scrollIndicators(.never, axes: .horizontal)
        }
        .braisenlyCard(
            cornerRadius: theme.metrics.radius[.s],
            fill: theme.colors.surfaceSnippet,
            role: .content
        )
    }
}
