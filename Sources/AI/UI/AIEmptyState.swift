import BraisenlySwiftUI
import SwiftUI

public struct AIEmptyState: View {
    public let suggestions: [String]
    public let onSelectSuggestion: (String) -> Void

    public init(
        suggestions: [String] = [
            "Summarize my research",
            "Help me explore an idea",
            "Draft a structured outline"
        ],
        onSelectSuggestion: @escaping (String) -> Void
    ) {
        self.suggestions = suggestions
        self.onSelectSuggestion = onSelectSuggestion
    }

    public var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "sparkles")
                .font(.system(size: 34, weight: .medium))
                .foregroundStyle(BraisenlyDS.Colors.accentTeal)
            VStack(spacing: 6) {
                Text("How can Braisenly help?")
                    .font(BraisenlyDS.Typography.documentTitle)
                    .foregroundStyle(BraisenlyDS.Colors.textBright)
                Text("Ask a question, develop an idea, or work with your notes.")
                    .font(BraisenlyDS.Typography.rowLabel)
                    .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: 10) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(suggestion) { onSelectSuggestion(suggestion) }
                        .buttonStyle(.plain)
                        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: 420, minHeight: 44, alignment: .leading)
                        .braisenlyCard(cornerRadius: 14)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
