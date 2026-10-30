# BraisenlySwiftUI

BraisenlySwiftUI is a reusable SwiftUI design system for building dark, focused note and research interfaces. It provides design tokens, surface treatments, atomic controls, sidebar and search components, grouped action sheets, and a complete mobile workspace composition.

The package is written in Swift 6.4 and supports iOS 17 and macOS 14 or later.

## Installation

Add BraisenlySwiftUI to your project with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/zautke/BraisenlySwiftUI.git", branch: "main")
]
```

Then add the product to your target:

```swift
.product(name: "BraisenlySwiftUI", package: "BraisenlySwiftUI")
```

In Xcode, you can instead choose **File → Add Package Dependencies** and enter the repository URL.

## Quick start

Import the package and use the complete workspace:

```swift
import BraisenlySwiftUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        BraisenlyMobileWorkspaceView(
            documentTitle: "Research Notes",
            documentText: "Ideas, sources, and connected notes live here."
        )
    }
}
```

Every component is public and can also be used independently:

```swift
import BraisenlySwiftUI
import SwiftUI

struct ToolbarExample: View {
    var body: some View {
        BraisenlyBottomToolbar(
            tabCount: 4,
            onSearch: { /* Open search */ },
            onAdd: { /* Create a note */ },
            onMenu: { /* Show actions */ }
        )
        .padding()
        .background(BraisenlyDS.Colors.backgroundPrimary)
    }
}
```

## Components

### Foundations

- `BraisenlyDesignSystem` and `BraisenlyDS` expose semantic colors, typography, and layout metrics.
- `BraisenlyCapsuleModifier` creates elevated floating controls.
- `BraisenlyCardModifier` creates bordered grouped surfaces.
- `.braisenlyCapsule()` and `.braisenlyCard()` apply those surfaces to any view.

### Primitives

- `BraisenlyCircleIconButton`
- `BraisenlyDualActionPill`
- `BraisenlyTabCounterBadge`
- `BraisenlyHighlightedText`

### Navigation and search

- `BraisenlyBottomToolbar`
- `BraisenlySidebarDrawer`
- `BraisenlySidebarContextPopover`
- `BraisenlySearchSnippetCard`
- `BraisenlySidebarMode`

### Actions and composition

- `BraisenlyActionItem`
- `BraisenlyActionRow`
- `BraisenlyActionGroup`
- `BraisenlyDocumentActionSheet`
- `BraisenlyDocumentCanvas`
- `BraisenlyMobileWorkspaceView`

## Custom surfaces

Use the design-system modifiers to style your own content consistently:

```swift
Text("Connected notes")
    .font(BraisenlyDS.Typography.rowLabelMedium)
    .foregroundStyle(BraisenlyDS.Colors.textBright)
    .padding(.horizontal, 18)
    .frame(height: BraisenlyDS.Metrics.rowHeight)
    .braisenlyCapsule()
```

## Development

Build and test the package in Xcode, or from the command line:

```sh
swift build
swift test
```

Tests use Apple's Swift Testing framework.
