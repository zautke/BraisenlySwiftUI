import SwiftUI

public struct BraisenlyParameterSliderRow: View {
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

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(BraisenlyDS.Typography.rowLabel)
                    .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                Spacer()
                Text(String(format: formatString, value))
                    .font(BraisenlyDS.Typography.metadata)
                    .foregroundStyle(BraisenlyDS.Colors.accentTeal)
            }
            Slider(value: $value, in: range, step: step)
                .tint(BraisenlyDS.Colors.accentTeal)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .braisenlyCard(cornerRadius: 16)
    }
}
