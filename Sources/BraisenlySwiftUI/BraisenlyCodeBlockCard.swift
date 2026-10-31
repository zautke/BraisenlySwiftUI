import SwiftUI

public struct BraisenlyCodeBlockCard: View {
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
                    .font(BraisenlyDS.Typography.metadata)
                    .foregroundStyle(BraisenlyDS.Colors.accentTeal)
                Spacer()
                if let onCopy {
                    Button(action: onCopy) {
                        Label("Copy", systemImage: "doc.on.doc")
                            .font(BraisenlyDS.Typography.metadata)
                            .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(BraisenlyDS.Colors.surfaceElevated.opacity(0.75))

            Divider().overlay(BraisenlyDS.Colors.divider)

            ScrollView(.horizontal) {
                Text(code)
                    .font(.system(size: 13.5, design: .monospaced))
                    .foregroundStyle(BraisenlyDS.Colors.textBright)
                    .textSelection(.enabled)
                    .padding(12)
            }
            .scrollIndicators(.hidden)
        }
        .braisenlyCard(
            cornerRadius: BraisenlyDS.Metrics.snippetRadius,
            fill: BraisenlyDS.Colors.surfaceSnippet
        )
    }
}
