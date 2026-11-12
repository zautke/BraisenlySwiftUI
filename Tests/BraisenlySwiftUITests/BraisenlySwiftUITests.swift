import SwiftUI
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

@Test func explicitPlatformsRemainStable() {
    #expect(BraisenlyPlatform.iPhone.resolved(horizontalSizeClass: .regular) == .iPhone)
    #expect(BraisenlyPlatform.iPad.resolved(horizontalSizeClass: .compact) == .iPad)
    #expect(BraisenlyPlatform.mac.resolved(horizontalSizeClass: .compact) == .mac)
}

@Test func platformsUseDistinctControlDensity() {
    #expect(BraisenlyPlatform.iPad.controlSize > BraisenlyPlatform.iPhone.controlSize)
    #expect(BraisenlyPlatform.mac.controlSize < BraisenlyPlatform.iPhone.controlSize)
    #expect(BraisenlyPlatform.iPad.contentMaxWidth < .infinity)
}

@Test func themesToggleBidirectionally() {
    #expect(BraisenlyTheme.dark.next == .light)
    #expect(BraisenlyTheme.light.next == .dark)
    #expect(BraisenlyTheme.dark.symbolName == "moon.stars.fill")
    #expect(BraisenlyTheme.light.symbolName == "sun.max.fill")
}

@Test func chatPrimitivesStoreConfigurationProperties() {
    let avatar = BraisenlyAvatarBadge(systemName: "sparkles", size: 40, iconSize: 18)
    #expect(avatar.systemName == "sparkles")
    #expect(avatar.size == 40)

    let bubble = BraisenlyChatBubbleSurface(text: "Hello **world**", cornerRadius: 22)
    #expect(bubble.text == "Hello **world**")
    #expect(bubble.cornerRadius == 22)

    let pill = BraisenlyCitationPill(title: "Design Doc", source: "Vault")
    #expect(pill.title == "Design Doc")
    #expect(pill.source == "Vault")

    let modelPill = BraisenlyModelPill(title: "Apple Foundation Model", action: {})
    #expect(modelPill.isInteractive)
}
