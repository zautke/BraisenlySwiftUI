# BraisenlySwiftUI

BraisenlySwiftUI is a reusable SwiftUI design system for building dark, focused note and research interfaces. It provides design tokens, surface treatments, atomic controls, sidebar and search components, grouped action sheets, and a complete mobile workspace composition.

The package also ships `BraisenlyAI`, an additive, separately importable AI chat component library and provider-agnostic streaming model layer built on the same design system.

The package is written in Swift 6.4 and supports iOS 17, iPadOS 17, and macOS 14 or later.

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

For AI chat components, add the separate product:

```swift
.product(name: "BraisenlyAI", package: "BraisenlySwiftUI")
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

## Adaptive platforms

Every visual component supports iPhone, iPad, and Mac layouts. Components default to `BraisenlyPlatform.automatic`, which selects compact phone presentation on iPhone, regular presentation on iPad, and desktop density on macOS.

- iPhone uses floating controls and an animated overlay drawer.
- iPad uses larger touch targets, wider spacing, constrained reading width, and a balanced two-column split view.
- Mac uses desktop control density, a resizable sidebar, constrained reading width, and a desktop-sized action sheet.

You can force a platform variant for previews, embedded layouts, or testing:

```swift
BraisenlyDocumentCanvas(
    title: "Project Notes",
    bodyText: "A platform-specific preview.",
    platform: .iPad
)
```

The complete workspace adapts in the same way:

```swift
BraisenlyMobileWorkspaceView(platform: .mac)
```

## Solarized themes

Braisenly includes the canonical Solarized palette and semantic Solarized Light and Dark themes. `BraisenlyDS.Solarized` exposes all 16 original colors, while `BraisenlyDS.Colors` automatically resolves each semantic role for the active appearance.

- Solarized Dark uses `base03` and `base02` backgrounds with `base0` and `base1` text.
- Solarized Light uses `base3` and `base2` backgrounds with `base00` and `base01` text.
- Accent colors remain consistent between appearances.

The complete workspace starts in Solarized Dark and includes an animated theme control. Set a different initial appearance when needed:

```swift
BraisenlyMobileWorkspaceView(initialTheme: .light)
```

Use the morphing toggle independently with any Braisenly surface:

```swift
struct ThemeControl: View {
    @State private var theme = BraisenlyTheme.dark

    var body: some View {
        BraisenlyThemeToggle(theme: $theme)
            .braisenlyTheme(theme)
    }
}
```

The toggle uses the SF Symbols Replace content transition to morph between sun and moon symbols and automatically disables motion when Reduce Motion is enabled.

## Components

### Foundations

- `BraisenlyDesignSystem` and `BraisenlyDS` expose semantic colors, typography, and layout metrics.
- `BraisenlyPlatform` selects automatic, iPhone, iPad, or Mac presentation.
- `BraisenlyTheme` selects Solarized Light or Dark presentation.
- `BraisenlyCapsuleModifier` creates elevated floating controls.
- `BraisenlyCardModifier` creates bordered grouped surfaces.
- `.braisenlyCapsule()` and `.braisenlyCard()` apply those surfaces to any view.

### Primitives

- `BraisenlyCircleIconButton`
- `BraisenlyDualActionPill`
- `BraisenlyTabCounterBadge`
- `BraisenlyHighlightedText`
- `BraisenlyThemeToggle`

### Navigation and search

- `BraisenlyBottomToolbar`
- `BraisenlyToolbarIconButton`
- `BraisenlySidebarDrawer`
- `BraisenlySidebarSearchHeader`
- `BraisenlySearchMetadataRow`
- `BraisenlyExpandableSearchResult`
- `BraisenlySidebarFooter`
- `BraisenlySidebarContextPopover`
- `BraisenlySearchSnippetCard`
- `BraisenlySidebarMode`

### Actions and composition

- `BraisenlyActionItem`
- `BraisenlyActionRow`
- `BraisenlyActionGroup`
- `BraisenlyDocumentActionSheet`
- `BraisenlyDocumentCanvas`
- `BraisenlyDocumentChrome`
- `BraisenlyCompactWorkspace`
- `BraisenlyRegularWorkspace`
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

## BraisenlyAI

Import the AI module independently from the base design system:

```swift
import BraisenlyAI
```

Create an `AIChatClient` adapter for the provider or on-device model you use. The library deliberately does not depend on a specific AI SDK:

```swift
struct MyAIClient: AIChatClient {
    func streamResponse(
        to request: AIChatRequest
    ) async throws -> AsyncThrowingStream<AIChatResponseEvent, any Error> {
        AsyncThrowingStream { continuation in
            // Connect your provider and yield text, tool, and citation events.
            continuation.yield(.textDelta("Hello from Braisenly"))
            continuation.yield(.finished)
            continuation.finish()
        }
    }
}
```

Own the session and present the complete chat surface:

```swift
import BraisenlyAI
import SwiftUI

struct AssistantView: View {
    @State private var session = AIChatSession(client: MyAIClient())

    var body: some View {
        AIChatView(
            session: session,
            modelName: "My model"
        )
    }
}
```

### AI UI components

- `AIChatView`
- `AIChatHeader`
- `AIMessageList`
- `AIMessageBubble`
- `AIComposer`
- `AIEmptyState`
- `AIStreamingIndicator`
- `AIToolCallCard`
- `AICitationChip`
- `AIChatErrorBanner`

### AI models and business logic

- `AIChatSession`
- `AIChatClient`
- `AIChatRequest`
- `AIChatResponseEvent`
- `AIConversation`
- `AIMessage`, `AIMessageRole`, and `AIMessageStatus`
- `AIToolCall`
- `AICitation`
- `AIChatFailure`

All business types live under `Sources/AI/Models`, while reusable SwiftUI components live under `Sources/AI/UI`.
