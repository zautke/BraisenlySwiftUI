import SwiftUI

/// Native stepper with title and monospaced current value; clamps to `range`.
public struct BraisenlyStepperRow: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    @Binding private var value: Int
    public let range: ClosedRange<Int>
    public let step: Int

    public init(_ title: String, value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
    }

    static func clamped(_ v: Int, to range: ClosedRange<Int>) -> Int {
        min(max(v, range.lowerBound), range.upperBound)
    }

    public var body: some View {
        let clampedValue = Binding(
            get: { Self.clamped(value, to: range) },
            set: { value = Self.clamped($0, to: range) }
        )
        Stepper(value: clampedValue, in: range, step: step) {
            HStack(spacing: theme.metrics.spacing[.s]) {
                Text(title)
                    .font(theme.typography.rowLabel)
                    .foregroundStyle(theme.colors.textPrimary)
                Spacer(minLength: theme.metrics.spacing[.s])
                Text("\(clampedValue.wrappedValue)")
                    .font(theme.typography.rowLabelMedium.monospacedDigit())
                    .foregroundStyle(theme.colors.textBright)
            }
        }
        .padding(.horizontal, theme.metrics.spacing[.m])
        .padding(.vertical, theme.metrics.spacing[.s])
        .braisenlyCard(role: .content)
    }
}
