import SwiftUI

/// Capsule segmented picker; glass themes group the segments in one container.
public struct BraisenlySegmentedControl<Value: Hashable>: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Binding private var selection: Value
    public let options: [Value]
    private let title: (Value) -> String
    public let platform: BraisenlyPlatform

    public init(
        selection: Binding<Value>,
        options: [Value],
        title: @escaping (Value) -> String,
        platform: BraisenlyPlatform = .automatic
    ) {
        self._selection = selection
        self.options = options
        self.title = title
        self.platform = platform
    }

    public var body: some View {
        let resolved = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        BraisenlyGlassGroup(spacing: .xs) {
            HStack(spacing: theme.metrics.spacing[.xs]) {
                ForEach(options, id: \.self) { option in
                    let isSelected = option == selection
                    Button {
                        selection = option
                    } label: {
                        Text(title(option))
                            .font(theme.typography.rowLabelMedium)
                            .foregroundStyle(isSelected ? theme.colors.textBright : theme.colors.textSecondary)
                            .padding(.horizontal, theme.metrics.spacing[.m])
                            .frame(minHeight: resolved.controlSize)
                            .frame(maxWidth: .infinity)
                            .braisenlyCapsule(
                                fill: isSelected ? theme.colors.surfaceHighlight : nil,
                                role: .control
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
        .animation(reduceMotion ? nil : .snappy, value: selection)
    }
}
