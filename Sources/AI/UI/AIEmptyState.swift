import BraisenlySwiftUI
import SwiftUI

public struct AIEmptyState: View {
    @Environment(\.braisenlyTheme) private var theme
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
        VStack(spacing: theme.metrics.spacing[.l]) {
            BraisenlyAvatarBadge(
                systemName: "sparkles",
                size: 56,
                iconSize: 26
            )
            VStack(spacing: theme.metrics.spacing[.s]) {
                Text("How can Askenly help?")
                    .font(theme.typography.documentTitle)
                    .foregroundStyle(theme.colors.textBright)
                Text("Ask a question, develop an idea, or work with your notes.")
                    .font(theme.typography.rowLabel)
                    .foregroundStyle(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: theme.metrics.spacing[.s]) {
                ForEach(suggestions, id: \.self) { suggestion in
                    BraisenlySuggestionCard(title: suggestion) {
                        onSelectSuggestion(suggestion)
                    }
                }
            }
        }
        .padding(theme.metrics.spacing[.xl])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
