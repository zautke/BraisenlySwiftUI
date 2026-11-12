# BraisenlySwiftUI

BraisenlySwiftUI is a reusable SwiftUI design system for building dark, focused note and research interfaces. It provides design tokens, surface treatments, atomic controls, sidebar and search components, grouped action sheets, and a complete mobile workspace composition.

The package also ships `BraisenlyAI`, an additive, separately importable AI chat component library and provider-agnostic streaming model layer built on the same design system.

The package is written in Swift 6.4 and supports iOS 26, iPadOS 26, and macOS 26 or later. Liquid Glass is the default theme; Solarized Light and Dark are built-in alternatives.

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
        .braisenlyPadding(.all, .l)
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

## Themes

Every component reads its colors, typography and metrics from the environment theme, a `BraisenlyThemeDefinition`. Three themes ship in `BraisenlyThemes`:

- `liquidGlass` (default): system colors, Dynamic Type, Liquid Glass on control and navigation surfaces.
- `solarizedLight` and `solarizedDark`: the canonical Solarized palette on solid surfaces. `BraisenlyDS.Solarized` still exposes the 16 source colors.

The complete workspace starts in Liquid Glass and includes a theme switcher. Set a different initial theme when needed:

```swift
BraisenlyMobileWorkspaceView(initialTheme: BraisenlyThemes.solarizedDark.id)
```

Apply a theme to any subtree and switch it with `BraisenlyThemeSwitcher`:

```swift
struct ThemeControl: View {
    @State private var themeID = BraisenlyThemes.liquidGlass.id

    var body: some View {
        BraisenlyThemeSwitcher(selection: $themeID, style: .cycle)
            .braisenlyTheme(BraisenlyThemes.theme(withID: themeID))
    }
}
```

The `.cycle` style uses the SF Symbols Replace content transition and disables motion when Reduce Motion is enabled; the `.row` style lists every theme.

## Components

### Foundations

- `BraisenlyThemeDefinition`, `BraisenlyThemes` and `.braisenlyTheme(_:)` deliver colors, typography, and metrics through the environment.
- `BraisenlyPlatform` selects automatic, iPhone, iPad, or Mac presentation.
- `BraisenlyCapsuleModifier` and `BraisenlyCardModifier` draw glass or solid surfaces by `BraisenlySurfaceRole`; `.braisenlyCapsule()`, `.braisenlyCard()` and `.braisenlySheetBackground()` apply them.

### Layout wrappers

- `BraisenlyVStack`, `BraisenlyHStack`, `BraisenlyZStack`, `BraisenlyScroll`, `BraisenlyGrid`, `BraisenlySplitView`
- `BraisenlySpacer`, `BraisenlyDivider`, `.braisenlyPadding(_:_:)`
- `BraisenlyText`, `BraisenlyIcon`

### Controls

- `BraisenlyThemeSwitcher`, `BraisenlyButton`, `BraisenlySegmentedControl`, `BraisenlyToggleRow`, `BraisenlyStepperRow`, `BraisenlyTextFieldRow`
- `BraisenlySectionHeader`, `BraisenlyNavRow`, `BraisenlyChipGroup`, `BraisenlyColorSwatch`, `BraisenlyPropertyTable`, `BraisenlyEmptyState`

### Primitives

- `BraisenlyCircleIconButton`
- `BraisenlyDualActionPill`
- `BraisenlyTabCounterBadge`
- `BraisenlyHighlightedText`

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
BraisenlyText("Connected notes", style: .rowLabelMedium, tone: .bright)
    .braisenlyPadding(.horizontal, .l)
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
