import SwiftUI

public struct BraisenlyParameterSliderRow: View {
    @Environment(\.braisenlyTheme) private var theme
    @Binding private var value: Double

    public let title: String
    public let range: ClosedRange<Double>
    public let step: Double
    public let formatString: String

    public init(
        title: String,
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0.0...1.5,
        step: Double = 0.1,
        formatString: String = "%.1f"
    ) {
        self.title = title
        _value = value
        self.range = range
        self.step = step
        self.formatString = formatString
    }

    /// An unstepped slider (the system draws tick dots for `step`) whose setter snaps to `step`.
    private var snapped: Binding<Double> {
        Binding(
            get: { value },
            set: { raw in
                guard step > 0 else { value = raw; return }
                let n = ((raw - range.lowerBound) / step).rounded()
                value = min(max(range.lowerBound + n * step, range.lowerBound), range.upperBound)
            }
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.metrics.spacing[.s]) {
            HStack {
                Text(title)
                    .font(theme.typography.rowLabel)
                    .foregroundStyle(theme.colors.textPrimary)
                Spacer()
                Text(String(format: formatString, value))
                    .font(theme.typography.metadata)
                    .foregroundStyle(theme.colors.accentTeal)
            }
            Slider(value: snapped, in: range)
                .tint(theme.colors.accentTeal)
        }
        .padding(.horizontal, theme.metrics.spacing[.l])
        .padding(.vertical, theme.metrics.spacing[.m])
        .braisenlyCard(cornerRadius: theme.metrics.radius[.m])
    }
}
