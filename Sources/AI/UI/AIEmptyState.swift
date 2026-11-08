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
            BraisenlyAvatarBadge(
                systemName: "sparkles",
                foregroundColor: BraisenlyDS.Colors.accentTeal,
                size: 56,
                iconSize: 26
            )
            VStack(spacing: 6) {
                Text("How can Askenly help?")
                    .font(BraisenlyDS.Typography.documentTitle)
                    .foregroundStyle(BraisenlyDS.Colors.textBright)
                Text("Ask a question, develop an idea, or work with your notes.")
                    .font(BraisenlyDS.Typography.rowLabel)
                    .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: 10) {
                ForEach(suggestions, id: \.self) { suggestion in
                    BraisenlySuggestionCard(title: suggestion) {
                        onSelectSuggestion(suggestion)
                    }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
