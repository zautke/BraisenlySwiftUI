import SwiftUI

public struct BraisenlyCircleIconButton: View {
    public let systemName: String
    public let accessibilityLabel: LocalizedStringResource
    public let iconSize: CGFloat
    public let action: () -> Void

    public init(
        systemName: String,
        accessibilityLabel: LocalizedStringResource,
        iconSize: CGFloat = 18,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.accessibilityLabel = accessibilityLabel
        self.iconSize = iconSize
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                .frame(width: BraisenlyDS.Metrics.circleButtonSize, height: BraisenlyDS.Metrics.circleButtonSize)
                .braisenlyCapsule()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(accessibilityLabel))
    }
}

public struct BraisenlyDualActionPill: View {
    public let onEdit: () -> Void
    public let onMore: () -> Void

    public init(onEdit: @escaping () -> Void, onMore: @escaping () -> Void) {
        self.onEdit = onEdit
        self.onMore = onMore
    }

    public var body: some View {
        HStack(spacing: 0) {
            Button(action: onEdit) {
                Image(systemName: "pencil").frame(width: 44, height: 44)
            }
            .accessibilityLabel("Edit")
            Button(action: onMore) {
                Image(systemName: "ellipsis").frame(width: 44, height: 44)
            }
            .accessibilityLabel("More actions")
        }
        .font(.system(size: 18, weight: .medium))
        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
        .buttonStyle(.plain)
        .braisenlyCapsule()
    }
}

public struct BraisenlyTabCounterBadge: View {
    public let count: Int

    public init(count: Int) {
        self.count = count
    }

    public var body: some View {
        Text(count, format: .number)
            .font(BraisenlyDS.Typography.badgeNumber)
            .foregroundStyle(BraisenlyDS.Colors.textPrimary)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .strokeBorder(BraisenlyDS.Colors.textPrimary, lineWidth: 1.6)
            )
            .accessibilityLabel("\(count) tabs")
    }
}

public struct BraisenlyHighlightedText: View {
    public let text: String
    public let highlight: String
    public let font: Font
    public let baseColor: Color

    public init(
        _ text: String,
        highlight: String,
        font: Font = BraisenlyDS.Typography.rowLabel,
        baseColor: Color = BraisenlyDS.Colors.textPrimary
    ) {
        self.text = text
        self.highlight = highlight
        self.font = font
        self.baseColor = baseColor
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(segments) { segment in
                Text(segment.text)
                    .font(font)
                    .foregroundStyle(segment.isMatch ? BraisenlyDS.Colors.matchForeground : baseColor)
                    .padding(.horizontal, segment.isMatch ? 1.5 : 0)
                    .padding(.vertical, segment.isMatch ? 0.5 : 0)
                    .background {
                        if segment.isMatch {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(BraisenlyDS.Colors.matchBackground)
                        }
                    }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
    }

    private var segments: [Segment] {
        guard !highlight.isEmpty else { return [Segment(index: 0, text: text, isMatch: false)] }
        var result: [Segment] = []
        var currentIndex = text.startIndex
        var index = 0
        while currentIndex < text.endIndex,
              let range = text[currentIndex...].range(of: highlight, options: .caseInsensitive) {
            if range.lowerBound > currentIndex {
                result.append(Segment(index: index, text: String(text[currentIndex..<range.lowerBound]), isMatch: false))
                index += 1
            }
            result.append(Segment(index: index, text: String(text[range]), isMatch: true))
            index += 1
            currentIndex = range.upperBound
        }
        if currentIndex < text.endIndex {
            result.append(Segment(index: index, text: String(text[currentIndex...]), isMatch: false))
        }
        return result
    }
}

private struct Segment: Identifiable {
    let index: Int
    let text: String
    let isMatch: Bool
    var id: Int { index }
}
