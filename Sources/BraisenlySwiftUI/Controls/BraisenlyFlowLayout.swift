import SwiftUI

/// Wrapping row layout: places subviews left to right, starting a new row when the next one would overflow.
struct BraisenlyFlowLayout: Layout {
    var spacing: CGFloat

    /// Greedy row packing of subview indices; an oversized item gets a row of its own.
    static func rows(for sizes: [CGSize], maxWidth: CGFloat, spacing: CGFloat) -> [[Int]] {
        var rows: [[Int]] = []
        var current: [Int] = []
        var used: CGFloat = 0
        for (index, size) in sizes.enumerated() {
            let needed = current.isEmpty ? size.width : used + spacing + size.width
            if !current.isEmpty && needed > maxWidth {
                rows.append(current)
                current = [index]
                used = size.width
            } else {
                current.append(index)
                used = needed
            }
        }
        if !current.isEmpty { rows.append(current) }
        return rows
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let maxWidth = proposal.width ?? .infinity
        let rows = Self.rows(for: sizes, maxWidth: maxWidth, spacing: spacing)
        let heights = rows.map { row in row.map { sizes[$0].height }.max() ?? 0 }
        var width: CGFloat = 0
        for row in rows {
            let rowWidth = row.reduce(CGFloat(0)) { $0 + sizes[$1].width } + spacing * CGFloat(max(row.count - 1, 0))
            width = max(width, rowWidth)
        }
        let height = heights.reduce(0, +) + spacing * CGFloat(max(rows.count - 1, 0))
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        var y = bounds.minY
        for row in Self.rows(for: sizes, maxWidth: bounds.width, spacing: spacing) {
            var x = bounds.minX
            let rowHeight = row.map { sizes[$0].height }.max() ?? 0
            for index in row {
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(sizes[index]))
                x += sizes[index].width + spacing
            }
            y += rowHeight + spacing
        }
    }
}
