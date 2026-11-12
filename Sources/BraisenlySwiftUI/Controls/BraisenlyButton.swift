import SwiftUI

public enum BraisenlyButtonProminence: Sendable { case standard, prominent }

/// Themed button: system glass button styles under a glass theme, solid capsule otherwise.
public struct BraisenlyButton: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let systemImage: String?
    public let prominence: BraisenlyButtonProminence
    private let action: () -> Void

    public init(
        _ title: String,
        systemImage: String? = nil,
        prominence: BraisenlyButtonProminence = .standard,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.prominence = prominence
        self.action = action
    }

    public var body: some View {
        if theme.surface == .solid {
            solidButton
        } else {
            glassButton
        }
    }

    private var label: some View {
        HStack(spacing: theme.metrics.spacing[.xs]) {
            if let systemImage { Image(systemName: systemImage) }
            Text(title)
        }
        .font(theme.typography.rowLabelMedium)
        .frame(minHeight: theme.metrics.circleButtonSize)
        .padding(.horizontal, theme.metrics.spacing[.l])
    }

    @ViewBuilder
    private var glassButton: some View {
        if prominence == .prominent {
            Button(action: action) { label }.buttonStyle(.glassProminent)
        } else {
            Button(action: action) { label }.buttonStyle(.glass)
        }
    }

    private var solidButton: some View {
        let prominent = prominence == .prominent
        return Button(action: action) {
            label
                .foregroundStyle(prominent ? theme.colors.matchForeground : theme.colors.textBright)
                .braisenlyCapsule(fill: prominent ? theme.colors.accentTeal : theme.colors.surfaceElevated)
        }
        .buttonStyle(.plain)
    }
}
