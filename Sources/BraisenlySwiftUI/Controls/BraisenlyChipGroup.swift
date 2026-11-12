import SwiftUI

/// Wrapping group of single-select capsule chips.
public struct BraisenlyChipGroup<Value: Hashable>: View {
    @Environment(\.braisenlyTheme) private var theme

    private let selection: Binding<Value>
    private let options: [Value]
    private let title: (Value) -> String

    public init(selection: Binding<Value>, options: [Value], title: @escaping (Value) -> String) {
        self.selection = selection
        self.options = options
        self.title = title
    }

    public var body: some View {
        BraisenlyGlassGroup {
            BraisenlyFlowLayout(spacing: theme.metrics.spacing[.s]) {
                ForEach(options, id: \.self) { option in
                    chip(option)
                }
            }
        }
    }

    private func chip(_ option: Value) -> some View {
        let isSelected = selection.wrappedValue == option
        return Button { selection.wrappedValue = option } label: {
            Text(title(option))
                .font(theme.typography.chipLabel)
                .foregroundStyle(isSelected ? theme.colors.accentTeal : theme.colors.textPrimary)
                .padding(.horizontal, theme.metrics.spacing[.m])
                .padding(.vertical, theme.metrics.spacing[.s])
                .braisenlyCapsule(role: .control)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
