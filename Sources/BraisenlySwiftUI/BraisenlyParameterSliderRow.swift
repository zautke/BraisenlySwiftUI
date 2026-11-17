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

    /// Continuous thumb position. The slider is unstepped (the system draws tick dots for `step`)
    /// and `value` receives the snapped position, so small keyboard increments accumulate here
    /// instead of being rounded away.
    @State private var position: Double?

    private func snap(_ raw: Double) -> Double {
        guard step > 0 else { return raw }
        let n = ((raw - range.lowerBound) / step).rounded()
        return min(max(range.lowerBound + n * step, range.lowerBound), range.upperBound)
    }

    private var thumb: Binding<Double> {
        Binding(
            get: { position ?? value },
            set: { raw in
                position = raw
                value = snap(raw)
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
            Slider(value: thumb, in: range)
                .tint(theme.colors.accentTeal)
                .onChange(of: value) { _, new in
                    // Follow changes made outside the slider.
                    if let position, snap(position) != new { self.position = nil }
                }
        }
        .padding(.horizontal, theme.metrics.spacing[.l])
        .padding(.vertical, theme.metrics.spacing[.m])
        .braisenlyCard(cornerRadius: theme.metrics.radius[.m])
    }
}
