import Testing
@testable import BraisenlySwiftUI

@Test func sidebarModesExposeStableSymbols() {
    #expect(BraisenlySidebarMode.allCases.count == 5)
    #expect(BraisenlySidebarMode.search.icon == "magnifyingglass")
}

@Test func actionItemsPreserveIdentityAndSelection() {
    let item = BraisenlyActionItem(id: "reading", icon: "book", title: "Reading view", isChecked: true)
    #expect(item.id == "reading")
    #expect(item.isChecked)
}
