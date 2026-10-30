import Foundation

struct BraisenlyHighlightedTextSegment: Identifiable {
    let index: Int
    let text: String
    let isMatch: Bool
    var id: Int { index }

    static func make(text: String, highlight: String) -> [Self] {
        guard !highlight.isEmpty else { return [Self(index: 0, text: text, isMatch: false)] }
        var result: [Self] = []
        var currentIndex = text.startIndex
        var index = 0
        while currentIndex < text.endIndex,
              let range = text[currentIndex...].range(of: highlight, options: .caseInsensitive) {
            if range.lowerBound > currentIndex {
                result.append(Self(index: index, text: String(text[currentIndex..<range.lowerBound]), isMatch: false))
                index += 1
            }
            result.append(Self(index: index, text: String(text[range]), isMatch: true))
            index += 1
            currentIndex = range.upperBound
        }
        if currentIndex < text.endIndex {
            result.append(Self(index: index, text: String(text[currentIndex...]), isMatch: false))
        }
        return result
    }
}
