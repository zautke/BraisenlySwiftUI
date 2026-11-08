import SwiftUI

public struct BraisenlyExpandableSearchResult: View {
    public let query: String
    public let platform: BraisenlyPlatform
    @Binding private var isExpanded: Bool

    public init(
        query: String,
        platform: BraisenlyPlatform = .automatic,
        isExpanded: Binding<Bool>
    ) {
        self.query = query
        self.platform = platform
        _isExpanded = isExpanded
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button { withAnimation(.snappy) { isExpanded.toggle() } } label: {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    Text("Independence and chicken-fried steak").lineLimit(1)
                    Spacer()
                    Text("1")
                }
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
            }
            .buttonStyle(.plain)
            if isExpanded {
                BraisenlySearchSnippetCard(
                    text: "…you with a recipe for this dish, which through hard work and culinary ingenuity catapults a cut of gristled beef from its rough-hewn, lowly beginnings to delectable and iconic heights…",
                    query: query,
                    platform: platform
                )
                .padding(.leading, 12)
            }
        }
    }
}
