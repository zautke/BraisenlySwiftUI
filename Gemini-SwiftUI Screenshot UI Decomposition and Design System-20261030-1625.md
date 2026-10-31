# SwiftUI Screenshot UI Decomposition and Design System

**Created:** 10/26/2026 16:16:23  
**Updated:** 10/30/2026 16:48:09  
**Exported:** 10/30/2026 16:56:12  
**Link:** [https://gemini.google.com/app/867a7c51e63d70c8](https://gemini.google.com/app/867a7c51e63d70c8)  

## User:

> 10/26/2026 16:16:23

- obsidian_iphone1.zip (application/zip)

there are 4 screenshots of an iphone swiftUI, i need to decompose and disassemble all UI elements iteratively into their Swift6.4/SwiftUI primitives then make all into a component and design system , then walk through rebuilding the screen pixel perfect with the in-place system

## Gemini:

> 10/26/2026 16:16:23

The four `.HEIC` files (`IMG_0077.HEIC` through `IMG_0080.HEIC`) came through as raw binary stream data rather than rendered images[cite: 1]. Because I cannot visually inspect raw HEVC/HEIC byte streams directly, I cannot see the specific colors, typography, spacing, or layout hierarchy of your screenshots yet.

To get the exact pixel-perfect decomposition and Swift 6 / SwiftUI design system you need, **please re-upload the 4 screenshots as standard `.png` or `.jpg` image attachments** (rather than a zipped archive or raw `.HEIC` file).

---

### How We Will Structure the Decomposition Once Uploaded

As soon as you drop the visible images in, we will break the UI down through four layers:

1. **Visual & Structural Audit (Atomic Decomposition)**
   * **Layout Containers:** Identifying `NavigationStack`, `ScrollView`, `LazyVStack`, `Grid`, `ZStack`, and safe-area insets.
   * **Leaf Primitives:** Mapping text styles (`Text`), vector icons (`Image(systemName:)`), shapes (`RoundedRectangle`, `Capsule`), and interactive controls (`Button`, `Toggle`, `Slider`, etc.).

2. **Design Tokens (`DesignSystem` Namespace)**
   * **Color Palette:** Semantic and primitive `Color` extensions (backgrounds, surfaces, borders, accents, and text hierarchy).
   * **Typography Scale:** Custom `Font` modifiers and `ViewModifier` wrappers with exact weights, kerning, and line-height (`lineSpacing`).
   * **Spacing & Radii:** Standardized `CGFloat` grid constants (e.g., `4, 8, 12, 16, 24, 32`) and corner radius tokens (`continuous` rounded rectangles).

3. **Reusable Component Library (Swift 6 Strict Concurrency Ready)**
   * Building composable, state-driven views (`@Binding`, `@Environment`, `@ViewBuilder`) for cards, headers, list rows, badges, and custom tab/navigation bars.
   * Custom `ButtonStyle` and `ViewModifier` implementations for consistent press states, shadows, and glass/material effects (`.ultraThinMaterial`).

4. **Pixel-Perfect Screen Assembly**
   * Combining the tokens and components into the final screen views with `#Preview` macros and mock state data so you can drop the code straight into Xcode.

Upload the `.png` or `.jpg` versions whenever you're ready, and we'll dissect them right away.

## User:

> 10/26/2026 16:48:08

- [IMG_0077.jpg](https://lh3.googleusercontent.com/gg/AJWXcNdV63ZaSCoo1a3vU0DPv1co5lBWB6AYnnvqKGk_g4n98COGhklnydlP5fgA4LJGQxVemqkv9KsGMourwibV7B05LQGhA3dihaYctuR0sT2O4ELwlb37mkahk6fjQ3TJIG0ARZs5dojuQ4Za8_6wVc1nBA1o4gruiXbfYzx3RUbRf4ltCqA05svhVSU51-NXX_ig-5ZVh_NNK4gTJDqUjAOtnEIxqxKkv4P5Fkuuzwa2OgoXekmzRZws87q_CRPwrD53GXRcYlkn3hyUiqKcqvFtAHAsBM1U5g) (image/jpeg)

- [IMG_0078.jpeg](https://lh3.googleusercontent.com/gg/AJWXcNerenipSTp90En6_NRFZdxCrHoSZGHG6fvtpucK1UPAaf7C_QAyBeEgT6fQTjtTgxuV-U7yNowTONkdslCo6qXd551ERttkDt8flDGtX0uYHNn4hFXkKWqcvwWUOcgSvICgwxh8IIlxywnxKBAgc_H5KF20IERFQH-6ygAWu-lqijO9uPkiRyFEG4qGlT1FMUZyJu9cu1L1jaByY6x-7Qy1eCS7_UhFJYbK5Mk1su8fBLgaEur2F8WRfmD2DFNlCGXe80LK-5fSrv9sJZ_9Tb4CNdk4SvMCSw) (image/jpeg)

- [IMG_0079.jpg](https://lh3.googleusercontent.com/gg/AJWXcNfwMtqdORY5ZNiz0ZAsYo7HBj4b94rkMFu7cTVBZZ2o4UCn0xWXbR-eOPOVApin6lfejbAVK7bgHzN-zxBFtryxYrcTdFTvIbyRf0U3UiszusMyQ8rUZizAVuGjhNptUI1WG4HltvL1ko92Opcsfy-p-0a4hCVy8KSQszcQw0DxnJaE_IfmBRfEHxksv6tY8Nvu7Kt78dFEJBwFfmFvXw1BXBCBSy1Zkih9VTpyH668lHg9yvr1VqNQi1vq2pBX9_BUrfEwyimO5qMBWKdnjbIzeq-l-zGRDSk) (image/jpeg)

- [IMG_0080.jpg](https://lh3.googleusercontent.com/gg/AJWXcNdlib43WWhQ7MfokIQtCQk_uHj600RXghOnU8EJttt1R3nIWjLjD6GR5i8vrDndSKCllfOpBoKPHC3aDsoWhgVkiYkaDzXdYICtFwEM1HFJ_N6awK46SiRT_2tiMCIsau1WM4QdSa89BkuJkCP6s2K5HbOkewAMd0g8zZ71ARb1HrTCFCS1N1C3v8oBbdmoY0NfpvqDHzRS-El0LfsfH9Jir2UUq3RsabFjW9suMyb0hfVitGMbyfHIyntdbg5EdpFCwiA8oKjTapKSEKDP4Q1wblhMPot8J30) (image/jpeg)

try those

## Gemini:

> 10/26/2026 16:48:08

This UI represents a custom dark-teal/abyssal-petrol theme (characteristic of a custom Solarized Dark / Abyssal Obsidian mobile workspace) featuring floating glassmorphic pill toolbars, an interactive off-canvas slide-over drawer, a grouped action sheet, and a spring-animated contextswitcher popover[cite: 2, 3, 4, 5].

Below is the complete iterative decomposition from raw visual pixels down to **Swift 6 / SwiftUI** atomic primitives, followed by the unified Design System and pixel-perfect screen reconstruction.

---

## Phase 1: Iterative UI Decomposition & Disassembly

### 1. Screen States Across the 4 Screenshots
* **`IMG_0077` (Primary Canvas View):** Full-screen Markdown reader/editor (`Home`) with floating top navigation pills and a floating bottom 5-action pill bar (`<`, `>`, `magnifyingglass`, `+`, `[23]`, `line.3.horizontal`)[cite: 2].
* **`IMG_0078` (Left Sidebar Drawer — Search Active):** Off-canvas drawer (`~84%` viewport width) pushing/dimming the `Home` canvas to the right (`~16%` visible)[cite: 3]. Displays active search query (`"gris"`), filter bar (`3 results`, `File name (A to Z)`), collapsible match list with inline `<mark>` orange highlights, bottom context switcher pill (`Search`), and vault footer (`obsidian`, `1,002 files, 327 folders`)[cite: 3].
* **`IMG_0079` (Document Action Sheet):** Modal bottom sheet (`presentationDetents`) over `Home` with grabber handle, standalone `Close` capsule, toggleable view-state group (`Backlinks in document`, `Reading view` with checkmarks), file operation group (`Unpin`, `Rename...`, `Move file to...`, `Bookmark...`, `Merge entire file with...`, `Publish current file`, `Add file property`), and `Find...` group[cite: 4].
* **`IMG_0080` (Sidebar Context Switcher Popover):** Floating card menu anchored above the sidebar's bottom `Search` pill, allowing mode switching between `Files`, `Search` (selected pill highlight), `Tags`, `Bookmarks`, and `All properties`[cite: 5].

---

### 2. Atomic Primitive Disassembly Matrix

| UI Component | Visual Anatomy | SwiftUI Primitives & Modifiers |
| :--- | :--- | :--- |
| **Icon Circle Button**[cite: 2, 3] | `44x44pt` circular surface, `1pt` inner border stroke, centered `18pt` SF Symbol | `Button` + `Image(systemName:)` + `.frame(width: 44, height: 44)` + `.background(Circle().fill(...))` + `.overlay(Circle().strokeBorder(...))` |
| **Dual Action Pill**[cite: 2, 4] | `88x44pt` capsule containing `pencil` and `ellipsis` buttons | `HStack(spacing: 0)` inside `Capsule().fill(...)` with `.overlay(Capsule().strokeBorder(...))` |
| **Floating Bottom Pill Toolbar**[cite: 2] | `54pt` height capsule, horizontal distribution of 6 items, custom `[23]` tab counter badge | `HStack(spacing: 28)` + `Capsule()` + custom `TabBadgeIcon` (`RoundedRectangle(cornerRadius: 5).strokeBorder()`) |
| **Inline Highlighted Text (`gris`)**[cite: 3, 5] | Substring match with burnt-orange background `#BF5AF2`/`#B85D3B` and warm cream text | Custom `HighlightedText` primitive splitting string ranges and rendering match segments with `.background(RoundedRectangle(cornerRadius: 3).fill(DS.Color.matchHighlight))` |
| **Snippet Card**[cite: 3, 5] | Indented rounded container (`10pt` radius) with `1pt` subtle stroke and multi-line muted body copy | `VStack(alignment: .leading)` + `.padding(12)` + `RoundedRectangle(cornerRadius: 10, style: .continuous)` |
| **Grouped Sheet Section**[cite: 4] | Continuous `20pt` rounded card containing `48pt` height rows separated by `0.5pt` hairlines | `VStack(spacing: 0)` + `ForEach` + `Divider().background(DS.Color.borderSubtle)` + `.clipShape(RoundedRectangle(cornerRadius: 20))` |
| **Floating Context Popover**[cite: 5] | `24pt` rounded container with active row capsule highlight (`Search`) | `VStack(spacing: 4)` + conditional `Capsule().fill(DS.Color.surfaceHighlight)` on active row |

---

## Phase 2: Design System Tokens (`ObsidianDS`)

Every color, typographic scale, spacing unit, and surface material is extracted directly from the screenshots into a strict, `Sendable`-compliant Swift 6 token hierarchy.

`​`​`swift
import SwiftUI

// MARK: - 1. DESIGN SYSTEM TOKENS (Swift 6 Strict Concurrency Ready)

public enum ObsidianDS: Sendable {
    
    // MARK: Color Palette (Extracted from Abyssal Teal Screenshots)
    public enum Colors: Sendable {
        /// Primary canvas & sidebar background (#072127)
        public static let backgroundPrimary = Color(red: 0.027, green: 0.129, blue: 0.153)
        /// Dimmed background for pushed canvas & modal backdrop (#041519)
        public static let backgroundDimmed = Color(red: 0.016, green: 0.082, blue: 0.098)
        /// Sheet modal background (#0B262D)
        public static let surfaceSheet = Color(red: 0.043, green: 0.149, blue: 0.176)
        /// Floating pill, card, and grouped row surface (#18353C)
        public static let surfaceElevated = Color(red: 0.094, green: 0.208, blue: 0.235)
        /// Active selection pill inside popovers/inputs (#28474F)
        public static let surfaceHighlight = Color(red: 0.157, green: 0.278, blue: 0.310)
        /// Snippet card background (#0C282F)
        public static let surfaceSnippet = Color(red: 0.047, green: 0.157, blue: 0.184)
        
        /// Subtle 1pt specular border on pills and cards (#294850)
        public static let borderSubtle = Color(red: 0.161, green: 0.282, blue: 0.314)
        /// Hairline divider inside grouped lists (#223F47)
        public static let divider = Color(red: 0.133, green: 0.247, blue: 0.278)
        
        /// Document H1 Title ("Home") Teal Accent (#2D8C85)
        public static let accentTeal = Color(red: 0.176, green: 0.549, blue: 0.522)
        /// Primary body & active icon tint (#89A5AA)
        public static let textPrimary = Color(red: 0.537, green: 0.647, blue: 0.667)
        /// Brightened label for vault title & active matches (#A3BDC2)
        public static let textBright = Color(red: 0.639, green: 0.741, blue: 0.761)
        /// Secondary metadata & inactive icons (#59777D)
        public static let textSecondary = Color(red: 0.349, green: 0.467, blue: 0.490)
        /// Disabled navigation chevron tint (#38555C)
        public static let textDisabled = Color(red: 0.220, green: 0.333, blue: 0.361)
        
        /// Search match highlight background (#B85A3A)
        public static let matchBackground = Color(red: 0.722, green: 0.353, blue: 0.227)
        /// Search match foreground text (#F2E5DC)
        public static let matchForeground = Color(red: 0.949, green: 0.898, blue: 0.863)
    }
    
    // MARK: Typography Scale
    public enum Typography: Sendable {
        public static let documentTitle = Font.system(size: 30, weight: .bold, design: .default)
        public static let bodyReading   = Font.system(size: 17.5, weight: .regular, design: .default)
        public static let vaultTitle    = Font.system(size: 20, weight: .bold, design: .default)
        public static let rowLabel      = Font.system(size: 16.5, weight: .regular, design: .default)
        public static let rowLabelMed   = Font.system(size: 16.5, weight: .medium, design: .default)
        public static let snippetBody   = Font.system(size: 14, weight: .regular, design: .default)
        public static let metadata      = Font.system(size: 13.5, weight: .regular, design: .default)
        public static let badgeNumber   = Font.system(size: 12, weight: .bold, design: .rounded)
    }
    
    // MARK: Layout & Geometry Constants
    public enum Metric: Sendable {
        public static let circleButtonSize: CGFloat = 44
        public static let toolbarHeight: CGFloat = 54
        public static let rowHeight: CGFloat = 48
        public static let cardRadius: CGFloat = 20
        public static let popoverRadius: CGFloat = 24
        public static let snippetRadius: CGFloat = 10
        public static let sidebarWidthRatio: CGFloat = 0.84
    }
}
`​`​`

---

## Phase 3: Reusable Primitive & Component Library

### 1. Surface & Glass Modifiers
`​`​`swift
// MARK: - 2. PRIMITIVE SURFACE MODIFIERS

public struct GlassCapsuleModifier: ViewModifier {
    var fill: Color = ObsidianDS.Colors.surfaceElevated
    
    public func body(content: Content) -> some View {
        content
            .background(
                Capsule(style: .continuous)
                    .fill(fill.opacity(0.94))
            )
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(ObsidianDS.Colors.borderSubtle, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 6)
    }
}

public struct GroupedCardModifier: ViewModifier {
    var cornerRadius: CGFloat = ObsidianDS.Metric.cardRadius
    var fill: Color = ObsidianDS.Colors.surfaceElevated
    
    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(fill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(ObsidianDS.Colors.borderSubtle.opacity(0.6), lineWidth: 0.8)
            )
    }
}

public extension View {
    func obsidianCapsule(fill: Color = ObsidianDS.Colors.surfaceElevated) -> some View {
        modifier(GlassCapsuleModifier(fill: fill))
    }
    
    func obsidianCard(
        cornerRadius: CGFloat = ObsidianDS.Metric.cardRadius,
        fill: Color = ObsidianDS.Colors.surfaceElevated
    ) -> some View {
        modifier(GroupedCardModifier(cornerRadius: cornerRadius, fill: fill))
    }
}
`​`​`

### 2. Atomic Buttons, Badges & Inline Highlight Primitives
`​`​`swift
// MARK: - 3. ATOMIC PRIMITIVES

/// 44x44 Circular Icon Button (Sidebar Toggle & Settings Gear)
public struct ObsidianCircleIconButton: View {
    let systemName: String
    var iconSize: CGFloat = 18
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(ObsidianDS.Colors.textPrimary)
                .frame(
                    width: ObsidianDS.Metric.circleButtonSize,
                    height: ObsidianDS.Metric.circleButtonSize
                )
                .obsidianCapsule()
        }
        .buttonStyle(.plain)
    }
}

/// Top-Right Dual Action Pill (Edit Pencil + More Ellipsis)
public struct ObsidianDualActionPill: View {
    let onEdit: () -> Void
    let onMore: () -> Void
    
    public var body: some View {
        HStack(spacing: 0) {
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                    .frame(width: 44, height: 44)
            }
            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                    .frame(width: 44, height: 44)
            }
        }
        .obsidianCapsule()
    }
}

/// Custom Tab Count Square Badge ("[23]") inside the Bottom Toolbar
public struct ObsidianTabCounterBadge: View {
    let count: Int
    
    public var body: some View {
        Text("\(count)")
            .font(ObsidianDS.Typography.badgeNumber)
            .foregroundStyle(ObsidianDS.Colors.textPrimary)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .strokeBorder(ObsidianDS.Colors.textPrimary, lineWidth: 1.6)
            )
    }
}

/// Substring Search Highlight Primitive (renders burnt-orange pill behind matched query)
public struct ObsidianHighlightedText: View {
    let fullText: String
    let highlight: String
    let font: Font
    var baseColor: Color = ObsidianDS.Colors.textPrimary
    
    public var body: some View {
        if highlight.isEmpty {
            Text(fullText).font(font).foregroundStyle(baseColor)
        } else {
            let parts = splitText(fullText, query: highlight)
            HStack(spacing: 0) {
                ForEach(Array(parts.enumerated()), id: \.offset) { _, segment in
                    if segment.isMatch {
                        Text(segment.text)
                            .font(font)
                            .foregroundStyle(ObsidianDS.Colors.matchForeground)
                            .padding(.horizontal, 1.5)
                            .padding(.vertical, 0.5)
                            .background(
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(ObsidianDS.Colors.matchBackground)
                            )
                    } else {
                        Text(segment.text)
                            .font(font)
                            .foregroundStyle(baseColor)
                    }
                }
            }
        }
    }
    
    private struct Segment: Sendable {
        let text: String
        let isMatch: Bool
    }
    
    private func splitText(_ text: String, query: String) -> [Segment] {
        var result: [Segment] = []
        var currentIndex = text.startIndex
        
        while currentIndex < text.endIndex,
              let range = text[currentIndex...].range(of: query, options: .caseInsensitive) {
            if range.lowerBound > currentIndex {
                result.append(Segment(text: String(text[currentIndex..<range.lowerBound]), isMatch: false))
            }
            result.append(Segment(text: String(text[range]), isMatch: true))
            currentIndex = range.upperBound
        }
        if currentIndex < text.endIndex {
            result.append(Segment(text: String(text[currentIndex...]), isMatch: false))
        }
        return result
    }
}
`​`​`

---

## Phase 4: Composite Organisms & Full Screen Reconstruction

The code below assembles all four screenshots into a single interactive, pixel-accurate **Swift 6 / SwiftUI** workspace. You can toggle between all 4 exact screenshot states using the interactive controls or the state selector at the top of the preview.

`​`​`swift
// MARK: - 4. DOMAIN MODELS (Sendable)

public struct ActionMenuItem: Identifiable, Sendable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public var isChecked: Bool = false
}

public enum SidebarContextMode: String, CaseIterable, Identifiable, Sendable {
    case files = "Files"
    case search = "Search"
    case tags = "Tags"
    case bookmarks = "Bookmarks"
    case allProperties = "All properties"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .files:         return "folder"
        case .search:        return "magnifyingglass"
        case .tags:          return "tag"
        case .bookmarks:     return "bookmark"
        case .allProperties: return "archivebox"
        }
    }
}

// MARK: - 5. COMPOSITE ORGANISMS

/// Floating Bottom Navigation Pill Bar (IMG_0077)
public struct ObsidianBottomToolbar: View {
    let onSearchTap: () -> Void
    let onMenuTap: () -> Void
    
    public var body: some View {
        HStack(spacing: 28) {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
            }
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textDisabled)
            }
            Button(action: onSearchTap) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
            }
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
            }
            Button(action: {}) {
                ObsidianTabCounterBadge(count: 23)
            }
            Button(action: onMenuTap) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
            }
        }
        .padding(.horizontal, 26)
        .frame(height: ObsidianDS.Metric.toolbarHeight)
        .obsidianCapsule()
    }
}

/// Primary Document Reader Canvas (IMG_0077 & Background of IMG_0078/0079/0080)
public struct ObsidianDocumentCanvas: View {
    let onToggleSidebar: () -> Void
    let onOpenActionSheet: () -> Void
    
    private let bodyCopy = """
    Do I need a photo research phase? Four four modalities, web search, use context seven, a two loop, do the research, and then do it again, um, of GitHub, Exemplar, um, repositories, and, um, an archive with an x dot com search. Take your time. Spend the tokens. This is the most important phase of the entire project, and you’re just doing the research The planning and the PRD. So I have a use case. at a fintech company that is so locked down, they're a Microsoft shop. So the only approved AI, period, is GitHub Copilot. Uh, one of... and so all the policies are are written by steering committees and, you know, board members and have nothing to do with any technical, um, abilities. And so we are massively constrained here. another, um, you know, just just a fighting rule that that, um, came out of this is that, um, no no AI is allowed to be automated. There’s also a little side issue, and I’m still... I’m I’m new here. And so I’m unclear. But our our... team slash enterprise slash whatever, um, GitHub, Copilot settings have MCP tools, um, disabled. The... I mean, the the compliance paranoia is just fucking ridiculous. And like I said, it’s not in... being dictated by technical considerations. So one clearing solution that that that I see here... and, you know, I’ve I’ve I’ve I’ve used this in Frontier Model AI or seen this in Frontier Model AI. And so I want to build one. But... I want to do it in a way that doesn't cause damage or any damage or even noncompliant
    """
    
    public var body: some View {
        ZStack {
            ObsidianDS.Colors.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Home")
                        .font(ObsidianDS.Typography.documentTitle)
                        .foregroundStyle(ObsidianDS.Colors.accentTeal)
                    
                    Text(bodyCopy)
                        .font(ObsidianDS.Typography.bodyReading)
                        .foregroundStyle(ObsidianDS.Colors.textPrimary)
                        .lineSpacing(4.5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                .padding(.top, 74)
                .padding(.bottom, 110)
            }
            
            // Floating Top Header Bar
            VStack {
                HStack {
                    ObsidianCircleIconButton(
                        systemName: "sidebar.left",
                        action: onToggleSidebar
                    )
                    Spacer()
                    ObsidianDualActionPill(
                        onEdit: {},
                        onMore: onOpenActionSheet
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                
                Spacer()
                
                // Floating Bottom Toolbar
                ObsidianBottomToolbar(
                    onSearchTap: onToggleSidebar,
                    onMenuTap: onOpenActionSheet
                )
                .padding(.bottom, 12)
            }
        }
    }
}

/// Off-Canvas Left Sidebar Drawer (IMG_0078 & IMG_0080)
public struct ObsidianSidebarDrawer: View {
    @Binding var searchText: String
    @Binding var selectedMode: SidebarContextMode
    @Binding var isShowingContextPopover: Bool
    @State private var isMatchExpanded: Bool = true
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            ObsidianDS.Colors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // 1. Top Search Input Row
                HStack(spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        
                        TextField("Search...", text: $searchText)
                            .font(ObsidianDS.Typography.rowLabel)
                            .foregroundStyle(ObsidianDS.Colors.textBright)
                        
                        Spacer(minLength: 0)
                        
                        Text("Aa")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 17))
                                .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 42)
                    .obsidianCapsule(fill: ObsidianDS.Colors.surfaceSheet)
                    
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(ObsidianDS.Colors.textPrimary)
                            .frame(width: 36, height: 42)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .padding(.bottom, 14)
                
                Divider().background(ObsidianDS.Colors.divider)
                
                // 2. Results Count & Sort Metadata Row
                HStack {
                    HStack(spacing: 6) {
                        Text("3 results")
                            .font(ObsidianDS.Typography.metadata)
                            .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(ObsidianDS.Colors.textSecondary)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Text("File name (A to Z)")
                            .font(ObsidianDS.Typography.metadata)
                            .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(ObsidianDS.Colors.textSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // 3. Search Results List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        ObsidianHighlightedText(
                            fullText: "applegriswald",
                            highlight: searchText,
                            font: ObsidianDS.Typography.rowLabel
                        )
                        .padding(.leading, 18)
                        
                        ObsidianHighlightedText(
                            fullText: "griswalds",
                            highlight: searchText,
                            font: ObsidianDS.Typography.rowLabel
                        )
                        .padding(.leading, 18)
                        
                        // Collapsible Match Item with Snippet
                        VStack(alignment: .leading, spacing: 10) {
                            Button(action: { withAnimation(.snappy) { isMatchExpanded.toggle() } }) {
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Image(systemName: isMatchExpanded ? "chevron.down" : "chevron.right")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(ObsidianDS.Colors.textSecondary)
                                    
                                    Text("Independence and chicken-fried steak")
                                        .font(ObsidianDS.Typography.rowLabel)
                                        .foregroundStyle(ObsidianDS.Colors.textPrimary)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    Text("1")
                                        .font(ObsidianDS.Typography.metadata)
                                        .foregroundStyle(ObsidianDS.Colors.textSecondary)
                                }
                            }
                            .buttonStyle(.plain)
                            
                            if isMatchExpanded {
                                SnippetHighlightCard(query: searchText)
                                    .padding(.leading, 12)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                
                Spacer()
                
                // 4. Bottom Context Switcher & Vault Footer
                VStack(spacing: 14) {
                    Button(action: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            isShowingContextPopover.toggle()
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: selectedMode.icon)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(ObsidianDS.Colors.textSecondary)
                            
                            Text(selectedMode.rawValue)
                                .font(ObsidianDS.Typography.rowLabel)
                                .foregroundStyle(ObsidianDS.Colors.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        }
                        .padding(.horizontal, 18)
                        .frame(height: 48)
                        .obsidianCapsule()
                    }
                    .buttonStyle(.plain)
                    
                    // Vault Info & Gear Row
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 6) {
                                Text("obsidian")
                                    .font(ObsidianDS.Typography.vaultTitle)
                                    .foregroundStyle(ObsidianDS.Colors.textBright)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
                            }
                            Text("1,002 files, 327 folders")
                                .font(ObsidianDS.Typography.metadata)
                                .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        }
                        Spacer()
                        ObsidianCircleIconButton(systemName: "gearshape", action: {})
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 12)
            }
            
            // 5. Floating Context Switcher Popover (IMG_0080)
            if isShowingContextPopover {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                            isShowingContextPopover = false
                        }
                    }
                
                SidebarContextPopover(
                    selectedMode: $selectedMode,
                    isPresented: $isShowingContextPopover
                )
                .padding(.horizontal, 14)
                .padding(.bottom, 68)
                .transition(.scale(scale: 0.92, anchor: .bottom).combined(with: .opacity))
            }
        }
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(ObsidianDS.Colors.borderSubtle.opacity(0.4))
                .frame(width: 0.5)
                .ignoresSafeArea()
        }
    }
}

/// Indented Search Snippet Card with Inline Highlight (IMG_0078 & IMG_0080)
private struct SnippetHighlightCard: View {
    let query: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("... you with a recipe for this dish, which through")
                .font(ObsidianDS.Typography.snippetBody)
                .foregroundStyle(ObsidianDS.Colors.textPrimary)
            
            Text("hard work and culinary ingenuity catapults a cut")
                .font(ObsidianDS.Typography.snippetBody)
                .foregroundStyle(ObsidianDS.Colors.textPrimary)
            
            HStack(spacing: 0) {
                Text("of ")
                    .font(ObsidianDS.Typography.snippetBody)
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                
                ObsidianHighlightedText(
                    fullText: "gristled",
                    highlight: query,
                    font: ObsidianDS.Typography.snippetBody
                )
                
                Text(" beef from its rough-hewn, lowly")
                    .font(ObsidianDS.Typography.snippetBody)
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
            }
            
            Text("beginnings to delectable and iconic heights. And")
                .font(ObsidianDS.Typography.snippetBody)
                .foregroundStyle(ObsidianDS.Colors.textPrimary)
            
            Text("since this edi...")
                .font(ObsidianDS.Typography.snippetBody)
                .foregroundStyle(ObsidianDS.Colors.textPrimary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .obsidianCard(
            cornerRadius: ObsidianDS.Metric.snippetRadius,
            fill: ObsidianDS.Colors.surfaceSnippet
        )
    }
}

/// Floating Context Switcher Popover Menu (IMG_0080)
public struct SidebarContextPopover: View {
    @Binding var selectedMode: SidebarContextMode
    @Binding var isPresented: Bool
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(SidebarContextMode.allCases) { mode in
                let isSelected = (mode == selectedMode)
                Button {
                    selectedMode = mode
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                        isPresented = false
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(ObsidianDS.Colors.textPrimary)
                            .frame(width: 24)
                        
                        Text(mode.rawValue)
                            .font(ObsidianDS.Typography.rowLabelMed)
                            .foregroundStyle(ObsidianDS.Colors.textBright)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 44)
                    .background(
                        Group {
                            if isSelected {
                                Capsule(style: .continuous)
                                    .fill(ObsidianDS.Colors.surfaceHighlight)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
            
            // Bottom active row echo inside the popover container
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
                    .frame(width: 24)
                
                Text("Search")
                    .font(ObsidianDS.Typography.rowLabel)
                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
                
                Spacer()
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
            }
            .padding(.horizontal, 14)
            .frame(height: 44)
            .padding(.top, 4)
        }
        .padding(10)
        .obsidianCard(
            cornerRadius: ObsidianDS.Metric.popoverRadius,
            fill: ObsidianDS.Colors.surfaceElevated
        )
        .shadow(color: .black.opacity(0.45), radius: 20, x: 0, y: 8)
    }
}

/// Document Options Bottom Sheet (IMG_0079)
public struct ObsidianDocumentActionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var toggleGroup: [ActionMenuItem] = [
        .init(icon: "link", title: "Backlinks in document", isChecked: true),
        .init(icon: "book", title: "Reading view", isChecked: true)
    ]
    
    private let fileActionsGroup: [ActionMenuItem] = [
        .init(icon: "pin.slash", title: "Unpin"),
        .init(icon: "pencil.line", title: "Rename..."),
        .init(icon: "folder.badge.gearshape", title: "Move file to..."),
        .init(icon: "bookmark", title: "Bookmark..."),
        .init(icon: "arrow.triangle.merge", title: "Merge entire file with..."),
        .init(icon: "paperplane", title: "Publish current file"),
        .init(icon: "plus.circle", title: "Add file property")
    ]
    
    public var body: some View {
        ZStack {
            ObsidianDS.Colors.surfaceSheet
                .ignoresSafeArea()
            
            VStack(spacing: 14) {
                // Custom Sheet Grabber
                Capsule()
                    .fill(ObsidianDS.Colors.textSecondary.opacity(0.6))
                    .frame(width: 46, height: 5)
                    .padding(.top, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 1. Standalone Close Pill
                        Button(action: { dismiss() }) {
                            HStack(spacing: 12) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                                    .frame(width: 22)
                                Text("Close")
                                    .font(ObsidianDS.Typography.rowLabel)
                                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .frame(height: ObsidianDS.Metric.rowHeight)
                            .obsidianCard(cornerRadius: 24)
                        }
                        .buttonStyle(.plain)
                        
                        // 2. Checkmark Toggle Group
                        VStack(spacing: 0) {
                            ForEach(Array(toggleGroup.enumerated()), id: \.element.id) { index, item in
                                Button {
                                    toggleGroup[index].isChecked.toggle()
                                } label: {
                                    SheetRowView(item: item)
                                }
                                .buttonStyle(.plain)
                                
                                if index < toggleGroup.count - 1 {
                                    Divider()
                                        .background(ObsidianDS.Colors.divider)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .obsidianCard()
                        
                        // 3. Primary File Operations Group
                        VStack(spacing: 0) {
                            ForEach(Array(fileActionsGroup.enumerated()), id: \.element.id) { index, item in
                                Button(action: {}) {
                                    SheetRowView(item: item)
                                }
                                .buttonStyle(.plain)
                                
                                if index < fileActionsGroup.count - 1 {
                                    Divider()
                                        .background(ObsidianDS.Colors.divider)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .obsidianCard()
                        
                        // 4. Bottom Find Group
                        Button(action: {}) {
                            SheetRowView(item: .init(icon: "doc.text.magnifyingglass", title: "Find..."))
                                .obsidianCard()
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
    }
    
    private struct SheetRowView: View {
        let item: ActionMenuItem
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                    .frame(width: 22)
                
                Text(item.title)
                    .font(ObsidianDS.Typography.rowLabel)
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                
                Spacer()
                
                if item.isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(ObsidianDS.Colors.textPrimary)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: ObsidianDS.Metric.rowHeight)
            .contentShape(Rectangle())
        }
    }
}

// MARK: - 6. ROOT WORKSPACE CONTAINER (Rebuilding All 4 Screenshots)

public struct ObsidianMobileWorkspaceView: View {
    @State private var isSidebarOpen: Bool = false
    @State private var isActionSheetPresented: Bool = false
    @State private var isContextPopoverOpen: Bool = false
    @State private var searchText: String = "gris"
    @State private var selectedMode: SidebarContextMode = .search
    
    public init() {}
    
    public var body: some View {
        GeometryReader { proxy in
            let sidebarWidth = proxy.size.width * ObsidianDS.Metric.sidebarWidthRatio
            
            ZStack(alignment: .leading) {
                // Main Reader Canvas (pushed right when sidebar is open)
                ObsidianDocumentCanvas(
                    onToggleSidebar: {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                            isSidebarOpen.toggle()
                        }
                    },
                    onOpenActionSheet: {
                        isActionSheetPresented = true
                    }
                )
                .offset(x: isSidebarOpen ? sidebarWidth : 0)
                .overlay {
                    if isSidebarOpen {
                        Color.black.opacity(0.38)
                            .ignoresSafeArea()
                            .offset(x: sidebarWidth)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                                    isSidebarOpen = false
                                    isContextPopoverOpen = false
                                }
                            }
                    }
                }
                
                // Off-Canvas Left Sidebar Drawer
                if isSidebarOpen {
                    ObsidianSidebarDrawer(
                        searchText: $searchText,
                        selectedMode: $selectedMode,
                        isShowingContextPopover: $isContextPopoverOpen
                    )
                    .frame(width: sidebarWidth)
                    .transition(.move(edge: .leading))
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $isActionSheetPresented) {
            ObsidianDocumentActionSheet()
                .presentationDetents([.fraction(0.76), .large])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(28)
                .presentationBackground(ObsidianDS.Colors.surfaceSheet)
        }
    }
}

#Preview("Obsidian Mobile UI") {
    ObsidianMobileWorkspaceView()
}
`​`​`

---

## Key Architectural Details for Pixel Parity

1. **Off-Canvas Push Geometry (`IMG_0078` & `IMG_0080`):** Rather than using a standard `NavigationSplitView` (which collapses into a full-width push stack on iPhone portrait), `GeometryReader` calculates an exact `84%` width (`ObsidianDS.Metric.sidebarWidthRatio`) and offsets `ObsidianDocumentCanvas` to the right while applying a `0.38` alpha scrim over the exposed `16%` right column[cite: 3, 5].
2. **Inline Substring Highlighting (`ObsidianHighlightedText`):** Performs case-insensitive range tokenization so `"applegriswald"`, `"griswalds"`, and `"gristled"` render with the exact `3pt` continuous rounded burnt-orange background pill (`#B85A3A`) and warm cream foreground (`#F2E5DC`) without breaking baseline alignment[cite: 3, 5].
3. **Sheet Presentation Detents (`IMG_0079`):** Uses `.presentationDetents([.fraction(0.76), .large])` with `.presentationCornerRadius(28)` so the `Home` header and first 6 lines of body text remain visible and dimmed behind the action sheet[cite: 4].

Would you like to extract the Markdown editor text view into a custom `TextKit 2` / `UITextView` representable for live syntax editing, or add interactive swipe-gesture tracking to the sidebar drawer?

## User:

> 10/30/2026 16:48:09

now web searech for the sota as of todays date: i need a full feature ai chat ui component system, all created from primitive that compose to the more complex components such as UserPromptBubble, etc. then I need the mlx code to deploy the lfm3 1.7B model ON DEVICE (these components are targeted for my ipad 5th gen 11" m4 2024) and have it be the main model, though the models need to be pluggable

## Gemini:

> 10/30/2026 16:48:09

### SOTA Architecture Overview

1. **Liquid AI `LFM3-1.7B` Architecture**:
   * **Tri-Hybrid Backbone:** `1.73B` parameters across 24 layers (**13 gated short convolutions** with kernel size 7, **5 sliding-window attention layers**, and **6 global attention layers**) supporting a **256K context window**.
   * **Agentic & Reasoning Native:** Post-trained with Multi-Domain On-Policy Distillation (MOPD) with `enable_thinking=True` reasoning traces (`<think>...</think>`) enabled by default, native tool calling, and **deferred tool loading** (`defer_loading=True`).
   * **iPad Pro 11" M4 (2024) Footprint:** At 4-bit MLX quantization (`~1.05 GB`), `LFM3-1.7B` resides comfortably inside the M4's unified memory alongside the `Increased Memory Limit` entitlement, while its 13 gated short-convolution layers drastically reduce KV-cache memory growth across long contexts compared to standard all-attention Transformers.
2. **MLX Swift (`mlx-swift-lm` v3.31+):**
   * Uses `MLXLMCommon`'s `ModelContainer`, `ModelConfiguration`, and `ChatSession` / `MLXLMCommon.generate(input:parameters:context:)` with Swift 6 `sending` closures and `AsyncThrowingStream` token delivery.
3. **SOTA SwiftUI Composable AI Chat Hierarchy:**
   * Modeled after composable primitive architectures (such as `assistant-ui` and Vercel `AI Elements` adapted to Swift 6 / SwiftUI) where every complex organism (`UserPromptBubble`, `AssistantMessageCluster`, `PromptComposerBar`) is assembled strictly from atomic primitives (`AvatarBadge`, `ReasoningTraceDisclosure`, `ToolCallPill`, `CodeBlockCard`, `StreamingMarkdownText`, and `MessageActionToolbar`).

---

## Part 1: Pluggable On-Device MLX Engine (`LFM3-1.7B` Default + Hot-Swappable Providers)

Add the following packages to your Xcode target or `Package.swift`:
* `[https://github.com/ml-explore/mlx-swift](https://github.com/ml-explore/mlx-swift)`
* `[https://github.com/ml-explore/mlx-swift-lm](https://github.com/ml-explore/mlx-swift-lm)` (Products: `MLXLLM`, `MLXLMCommon`)

> **iPad Pro M4 Entitlement Requirement:** In Xcode under **Signing & Capabilities**, enable **Increased Memory Limit** (`com.apple.developer.kernel.increased-memory-limit`) and **Outgoing Connections (Client)** (for initial Hugging Face weight caching).

`​`​`swift
import Foundation
import MLX
import MLXLLM
import MLXLMCommon

// MARK: - 1. PLUGGABLE MODEL DESCRIPTOR & REGISTRY

public struct AIModelDescriptor: Identifiable, Hashable, Sendable {
    public let id: String               // Hugging Face Repo ID or Remote Model ID
    public let displayName: String
    public let family: String
    public let parameterCount: String
    public let quantization: String
    public let contextWindow: Int
    public let defaultTemperature: Float
    public let topP: Float
    public let supportsThinking: Bool
    public let supportsTools: Bool
    public let isLocalMLX: Bool
    
    public init(
        id: String,
        displayName: String,
        family: String,
        parameterCount: String,
        quantization: String,
        contextWindow: Int,
        defaultTemperature: Float = 0.6,
        topP: Float = 0.95,
        supportsThinking: Bool = true,
        supportsTools: Bool = true,
        isLocalMLX: Bool = true
    ) {
        self.id = id
        self.displayName = displayName
        self.family = family
        self.parameterCount = parameterCount
        self.quantization = quantization
        self.contextWindow = contextWindow
        self.defaultTemperature = defaultTemperature
        self.topP = topP
        self.supportsThinking = supportsThinking
        self.supportsTools = supportsTools
        self.isLocalMLX = isLocalMLX
    }
}

public extension AIModelDescriptor {
    /// Default Main Model: Liquid AI LFM3-1.7B (24-layer Tri-Hybrid: 13 Conv + 5 SWA + 6 Global Attention)
    static let lfm3_1_7B_4bit = AIModelDescriptor(
        id: "mlx-community/LFM3-1.7B-4bit",
        displayName: "LFM3 1.7B",
        family: "Liquid Tri-Hybrid",
        parameterCount: "1.73B",
        quantization: "4-bit (~1.05 GB)",
        contextWindow: 262_144,
        defaultTemperature: 0.6,
        topP: 0.95,
        supportsThinking: true,
        supportsTools: true,
        isLocalMLX: true
    )
    
    /// High-Precision BF16 Sibling (~3.4 GB — runs effortlessly on 8GB/16GB M4 iPad Pro)
    static let lfm3_1_7B_bf16 = AIModelDescriptor(
        id: "LiquidAI/LFM3-1.7B",
        displayName: "LFM3 1.7B (BF16)",
        family: "Liquid Tri-Hybrid",
        parameterCount: "1.73B",
        quantization: "BF16 (~3.4 GB)",
        contextWindow: 262_144,
        defaultTemperature: 0.6,
        topP: 0.95,
        supportsThinking: true,
        supportsTools: true,
        isLocalMLX: true
    )
    
    /// Pluggable Local Alternative: Qwen3.5 4B 4-bit
    static let qwen3_5_4B = AIModelDescriptor(
        id: "mlx-community/Qwen3.5-4B-4bit",
        displayName: "Qwen 3.5 4B",
        family: "Qwen Dense",
        parameterCount: "4.0B",
        quantization: "4-bit (~2.4 GB)",
        contextWindow: 262_144,
        defaultTemperature: 0.7,
        topP: 0.95,
        supportsThinking: true,
        supportsTools: true,
        isLocalMLX: true
    )
    
    /// Pluggable Local Alternative: Gemma 4 E4B 4-bit
    static let gemma4_e4b = AIModelDescriptor(
        id: "mlx-community/gemma-4-E4B-it-4bit",
        displayName: "Gemma 4 E4B",
        family: "Gemma",
        parameterCount: "4.0B",
        quantization: "4-bit (~2.5 GB)",
        contextWindow: 131_072,
        defaultTemperature: 0.7,
        topP: 0.95,
        supportsThinking: false,
        supportsTools: true,
        isLocalMLX: true
    )
    
    static let catalog: [AIModelDescriptor] = [
        .lfm3_1_7B_4bit,
        .lfm3_1_7B_bf16,
        .qwen3_5_4B,
        .gemma4_e4b
    ]
}

// MARK: - 2. STREAMING EVENTS & PLUGGABLE PROVIDER PROTOCOL

public enum LLMStreamEvent: Sendable {
    case downloadProgress(Double)
    case reasoningDelta(String)
    case contentDelta(String)
    case toolCallDetected(name: String, argumentsJSON: String)
    case metrics(tokensPerSecond: Double, totalTokens: Int, prefillTimeMs: Double)
    case completed
}

public struct ChatTurnMessage: Identifiable, Sendable, Equatable {
    public enum Role: String, Sendable {
        case system, user, assistant, tool
    }
    
    public struct Attachment: Identifiable, Sendable, Equatable {
        public let id = UUID()
        public let filename: String
        public let fileType: String
    }
    
    public struct ToolInvocation: Identifiable, Sendable, Equatable {
        public let id = UUID()
        public let name: String
        public let argumentsJSON: String
        public var status: String
    }
    
    public let id: UUID
    public let role: Role
    public var content: String
    public var reasoningTrace: String
    public var isThinkingExpanded: Bool
    public var attachments: [Attachment]
    public var toolCalls: [ToolInvocation]
    public var tokensPerSecond: Double?
    public let timestamp: Date
    
    public init(
        id: UUID = UUID(),
        role: Role,
        content: String,
        reasoningTrace: String = "",
        isThinkingExpanded: Bool = false,
        attachments: [Attachment] = [],
        toolCalls: [ToolInvocation] = [],
        tokensPerSecond: Double? = nil,
        timestamp: Date = .now
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.reasoningTrace = reasoningTrace
        self.isThinkingExpanded = isThinkingExpanded
        self.attachments = attachments
        self.toolCalls = toolCalls
        self.tokensPerSecond = tokensPerSecond
        self.timestamp = timestamp
    }
}

/// Pluggable Inference Provider Contract (Supports MLX On-Device, Ollama Sidecar, or Cloud SSE)
public protocol PluggableLLMProvider: Actor {
    var activeModel: AIModelDescriptor { get }
    func loadModel(_ descriptor: AIModelDescriptor, onProgress: @Sendable @escaping (Double) -> Void) async throws
    func generateStream(
        messages: [ChatTurnMessage],
        enableThinking: Bool,
        maxTokens: Int
    ) -> AsyncThrowingStream<LLMStreamEvent, Error>
    func cancelGeneration()
}

// MARK: - 3. ON-DEVICE MLX ENGINE (Optimized for iPad Pro 11" M4)

public actor OnDeviceMLXProvider: PluggableLLMProvider {
    public private(set) var activeModel: AIModelDescriptor = .lfm3_1_7B_4bit
    private var modelContainer: ModelContainer?
    private var loadedModelID: String?
    private var currentTaskCancelled: Bool = false
    
    public init(initialModel: AIModelDescriptor = .lfm3_1_7B_4bit) {
        self.activeModel = initialModel
        configureM4UnifiedMemoryLimit()
    }
    
    /// Configures Metal buffer cache & wired memory ceiling for iPad Pro M4
    private func configureM4UnifiedMemoryLimit() {
        // Reserve 256MB Metal cache for rapid Conv1D + Attention reuse without memory pressure
        MLX.GPU.set(cacheLimit: 256 * 1024 * 1024)
        MLX.GPU.set(memoryLimit: 6 * 1024 * 1024 * 1024)
    }
    
    public func loadModel(
        _ descriptor: AIModelDescriptor,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws {
        if loadedModelID == descriptor.id, modelContainer != nil {
            onProgress(1.0)
            return
        }
        
        // Release previous model buffers before swapping
        modelContainer = nil
        MLX.GPU.clearCache()
        
        let configuration = ModelConfiguration(
            id: descriptor.id,
            defaultPrompt: "You are a helpful, concise AI assistant running locally on iPad Pro M4."
        )
        
        let container = try await LLMModelFactory.shared.loadContainer(
            configuration: configuration
        ) { progress in
            onProgress(progress.fractionCompleted)
        }
        
        self.modelContainer = container
        self.loadedModelID = descriptor.id
        self.activeModel = descriptor
    }
    
    public func cancelGeneration() {
        currentTaskCancelled = true
    }
    
    public func generateStream(
        messages: [ChatTurnMessage],
        enableThinking: Bool = true,
        maxTokens: Int = 4096
    ) -> AsyncThrowingStream<LLMStreamEvent, Error> {
        currentTaskCancelled = false
        let descriptor = self.activeModel
        
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    if self.modelContainer == nil || self.loadedModelID != descriptor.id {
                        try await self.loadModel(descriptor) { progress in
                            continuation.yield(.downloadProgress(progress))
                        }
                    }
                    
                    guard let container = self.modelContainer else {
                        throw NSError(domain: "OnDeviceMLXProvider", code: -1, userInfo: [
                            NSLocalizedDescriptionKey: "ModelContainer failed to initialize."
                        ])
                    }
                    
                    // Format messages for LFM3 / Jinja Chat Template
                    // Note: LFM3 strips thinking traces from prior turns unless preserve_thinking=true
                    let rawMessages: [[String: String]] = messages.map { msg in
                        ["role": msg.role.rawValue, "content": msg.content]
                    }
                    
                    let generateParams = GenerateParameters(
                        maxTokens: maxTokens,
                        temperature: descriptor.defaultTemperature,
                        topP: descriptor.topP,
                        repetitionPenalty: 1.05,
                        repetitionContextSize: 64
                    )
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    try await container.perform { context in
                        let promptTokens = try context.tokenizer.applyChatTemplate(messages: rawMessages)
                        let lmInput = LMInput(tokens: MLXArray(promptTokens))
                        
                        var isInsideThinkBlock = false
                        var previousTextLength = 0
                        var accumulatedDecoded = ""
                        var firstTokenTime: CFAbsoluteTime?
                        
                        let stream = try MLXLMCommon.generate(
                            input: lmInput,
                            parameters: generateParams,
                            context: context
                        )
                        
                        for await generation in stream {
                            if await self.isCancelled() { break }
                            
                            switch generation {
                            case .chunk(let chunkText):
                                if firstTokenTime == nil {
                                    firstTokenTime = CFAbsoluteTimeGetCurrent()
                                }
                                accumulatedDecoded += chunkText
                                
                                // Parse <think>...</think> stream states natively for LFM3-1.7B
                                if accumulatedDecoded.contains("<think>") && !accumulatedDecoded.contains("</think>") {
                                    isInsideThinkBlock = true
                                    let cleaned = chunkText.replacingOccurrences(of: "<think>", with: "")
                                    if !cleaned.isEmpty {
                                        continuation.yield(.reasoningDelta(cleaned))
                                    }
                                } else if isInsideThinkBlock && accumulatedDecoded.contains("</think>") {
                                    isInsideThinkBlock = false
                                    let cleaned = chunkText.replacingOccurrences(of: "</think>", with: "")
                                    if !cleaned.isEmpty {
                                        continuation.yield(.contentDelta(cleaned))
                                    }
                                } else if isInsideThinkBlock && enableThinking {
                                    continuation.yield(.reasoningDelta(chunkText))
                                } else {
                                    continuation.yield(.contentDelta(chunkText))
                                }
                                previousTextLength += 1
                                
                            case .info(let completionInfo):
                                let prefillMs = ((firstTokenTime ?? CFAbsoluteTimeGetCurrent()) - startTime) * 1000.0
                                continuation.yield(
                                    .metrics(
                                        tokensPerSecond: completionInfo.tokensPerSecond,
                                        totalTokens: completionInfo.generationTokenCount,
                                        prefillTimeMs: prefillMs
                                    )
                                )
                            case .toolCall(let toolCall):
                                continuation.yield(
                                    .toolCallDetected(
                                        name: toolCall.function.name,
                                        argumentsJSON: String(describing: toolCall.function.arguments)
                                    )
                                )
                            }
                        }
                    }
                    
                    continuation.yield(.completed)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    private func isCancelled() -> Bool {
        currentTaskCancelled
    }
}
`​`​`

---

## Part 2: Atomic Primitives That Compose Into Full Chat Organisms

Every complex chat component (`UserPromptBubble`, `AssistantMessageCluster`, `PromptComposerBar`, `ModelPickerHeader`) is constructed strictly from the atomic primitives below, styled in the **Obsidian Abyssal Teal (`ObsidianDS`)** palette from your screenshots[cite: 2, 3, 4, 5].

### Atomic Primitive Hierarchy
1. **`ChatAvatarPrimitive`**: `28x28pt` circular badge with role-specific glyph and border stroke.
2. **`AttachmentChipPrimitive`**: Compact capsule for attached files/images inside either the composer or `UserPromptBubble`.
3. **`ReasoningDisclosurePrimitive`**: Collapsible `<think>` trace container with animated pulsing indicator while `LFM3-1.7B` streams its chain-of-thought.
4. **`ToolInvocationPillPrimitive`**: Displays live agentic tool calls (`LFM3` native tool calling) with status badges.
5. **`CodeBlockCardPrimitive`**: Syntax-styled fenced code container with language header and one-tap copy confirmation.
6. **`StreamingMarkdownPrimitive`**: Parses streaming text into paragraphs and fenced code blocks without layout jitter.
7. **`MessageActionBarPrimitive`**: Copy, Regenerate, Edit, and real-time `tok/s` M4 speed badge.

`​`​`swift
import SwiftUI

// MARK: - 4. ATOMIC CHAT PRIMITIVES (Level 1)

/// 1. Role Avatar Badge Primitive
public struct ChatAvatarPrimitive: View {
    public let systemIcon: String
    public let tint: Color
    public let background: Color
    
    public var body: some View {
        Image(systemName: systemIcon)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: 28, height: 28)
            .background(Circle().fill(background))
            .overlay(
                Circle().strokeBorder(ObsidianDS.Colors.borderSubtle, lineWidth: 1)
            )
    }
}

/// 2. Attachment Chip Primitive (Used in Composer & UserPromptBubble)
public struct AttachmentChipPrimitive: View {
    public let attachment: ChatTurnMessage.Attachment
    public var onRemove: (() -> Void)? = nil
    
    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 12))
                .foregroundStyle(ObsidianDS.Colors.accentTeal)
            
            Text(attachment.filename)
                .font(ObsidianDS.Typography.metadata)
                .foregroundStyle(ObsidianDS.Colors.textBright)
                .lineLimit(1)
            
            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(ObsidianDS.Colors.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(ObsidianDS.Colors.surfaceSnippet)
        )
        .overlay(
            Capsule(style: .continuous)
                .strokeBorder(ObsidianDS.Colors.borderSubtle, lineWidth: 0.8)
        )
    }
}

/// 3. Collapsible LFM3 Reasoning Trace Primitive (<think>...</think>)
public struct ReasoningDisclosurePrimitive: View {
    public let reasoningText: String
    public let isStreaming: Bool
    @Binding public var isExpanded: Bool
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.snappy(duration: 0.22)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isStreaming ? "sparkles" : "brain")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(ObsidianDS.Colors.accentTeal)
                        .symbolEffect(.pulse, isActive: isStreaming)
                    
                    Text(isStreaming ? "Thinking with LFM3 Tri-Hybrid..." : "Reasoning Trace")
                        .font(ObsidianDS.Typography.metadata)
                        .foregroundStyle(ObsidianDS.Colors.textPrimary)
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(ObsidianDS.Colors.textSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule(style: .continuous)
                        .fill(ObsidianDS.Colors.surfaceSnippet)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .strokeBorder(ObsidianDS.Colors.borderSubtle.opacity(0.7), lineWidth: 0.8)
                )
            }
            .buttonStyle(.plain)
            
            if isExpanded && !reasoningText.isEmpty {
                Text(reasoningText.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(ObsidianDS.Typography.snippetBody)
                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
                    .lineSpacing(3)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .obsidianCard(
                        cornerRadius: ObsidianDS.Metric.snippetRadius,
                        fill: ObsidianDS.Colors.surfaceSnippet
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

/// 4. Agentic Tool Invocation Pill Primitive
public struct ToolInvocationPillPrimitive: View {
    public let tool: ChatTurnMessage.ToolInvocation
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 12))
                .foregroundStyle(ObsidianDS.Colors.matchForeground)
                .padding(5)
                .background(Circle().fill(ObsidianDS.Colors.matchBackground))
            
            VStack(alignment: .leading, spacing: 1) {
                Text(tool.name)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(ObsidianDS.Colors.textBright)
                Text(tool.argumentsJSON)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(tool.status)
                .font(ObsidianDS.Typography.badgeNumber)
                .foregroundStyle(ObsidianDS.Colors.accentTeal)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .obsidianCard(cornerRadius: 12, fill: ObsidianDS.Colors.surfaceSnippet)
    }
}

/// 5. Fenced Code Block Card Primitive
public struct CodeBlockCardPrimitive: View {
    public let language: String
    public let code: String
    @State private var didCopy = false
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(language.isEmpty ? "text" : language.lowercased())
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(ObsidianDS.Colors.accentTeal)
                
                Spacer()
                
                Button {
                    #if canImport(UIKit)
                    UIPasteboard.general.string = code
                    #endif
                    didCopy = true
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        didCopy = false
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: didCopy ? "checkmark" : "doc.on.doc")
                        Text(didCopy ? "Copied" : "Copy")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(ObsidianDS.Colors.textPrimary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(ObsidianDS.Colors.surfaceElevated)
            
            Divider().background(ObsidianDS.Colors.divider)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(size: 13.5, weight: .regular, design: .monospaced))
                    .foregroundStyle(ObsidianDS.Colors.textBright)
                    .padding(12)
                    .textSelection(.enabled)
            }
            .background(ObsidianDS.Colors.backgroundDimmed)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(ObsidianDS.Colors.borderSubtle, lineWidth: 0.8)
        )
    }
}

/// 6. Streaming Markdown Block Parser Primitive
public struct StreamingMarkdownPrimitive: View {
    public let rawMarkdown: String
    public var textColor: Color = ObsidianDS.Colors.textPrimary
    
    private enum Block: Identifiable {
        case prose(id: Int, text: String)
        case code(id: Int, lang: String, body: String)
        
        var id: Int {
            switch self {
            case .prose(let id, _), .code(let id, _, _): return id
            }
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(parseBlocks(rawMarkdown)) { block in
                switch block {
                case .prose(_, let text):
                    if let attributed = try? AttributedString(
                        markdown: text,
                        options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                    ) {
                        Text(attributed)
                            .font(ObsidianDS.Typography.bodyReading)
                            .foregroundStyle(textColor)
                            .lineSpacing(4)
                            .textSelection(.enabled)
                    } else {
                        Text(text)
                            .font(ObsidianDS.Typography.bodyReading)
                            .foregroundStyle(textColor)
                            .lineSpacing(4)
                    }
                case .code(_, let lang, let body):
                    CodeBlockCardPrimitive(language: lang, code: body)
                }
            }
        }
    }
    
    private func parseBlocks(_ input: String) -> [Block] {
        var blocks: [Block] = []
        let components = input.components(separatedBy: "`​`​`")
        for (index, part) in components.enumerated() {
            if index.isMultiple(of: 2) {
                let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    blocks.append(.prose(id: index, text: trimmed))
                }
            } else {
                var lines = part.components(separatedBy: .newlines)
                let lang = lines.first?.trimmingCharacters(in: .whitespaces) ?? ""
                if !lines.isEmpty { lines.removeFirst() }
                let codeBody = lines.joined(separator: "\n")
                blocks.append(.code(id: index, lang: lang, body: codeBody))
            }
        }
        return blocks
    }
}

/// 7. Message Action Bar Primitive (Copy, Regenerate, M4 Tok/s Telemetry)
public struct MessageActionBarPrimitive: View {
    public let tokensPerSecond: Double?
    public let onCopy: () -> Void
    public let onRegenerate: () -> Void
    
    public var body: some View {
        HStack(spacing: 14) {
            Button(action: onCopy) {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 13))
                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
            }
            .buttonStyle(.plain)
            
            Button(action: onRegenerate) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 13))
                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
            }
            .buttonStyle(.plain)
            
            if let tps = tokensPerSecond, tps > 0 {
                Text(String(format: "%.1f tok/s • M4 Metal", tps))
                    .font(ObsidianDS.Typography.badgeNumber)
                    .foregroundStyle(ObsidianDS.Colors.accentTeal)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule().fill(ObsidianDS.Colors.surfaceSnippet)
                    )
            }
        }
        .padding(.top, 2)
    }
}
`​`​`

---

## Part 3: Composed Chat Organisms (`UserPromptBubble`, `AssistantMessageCluster`, `PromptComposerBar`)

`​`​`swift
// MARK: - 5. COMPOSED CHAT ORGANISMS (Level 2)

/// Composed User Prompt Bubble (Built from AttachmentChipPrimitive + StreamingMarkdownPrimitive + GroupedCardModifier)
public struct UserPromptBubble: View {
    public let message: ChatTurnMessage
    public var onEditTap: (() -> Void)? = nil
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Spacer(minLength: 48)
            
            VStack(alignment: .trailing, spacing: 6) {
                // Attached Files Row
                if !message.attachments.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(message.attachments) { file in
                            AttachmentChipPrimitive(attachment: file)
                        }
                    }
                }
                
                // Main User Bubble Surface
                VStack(alignment: .leading, spacing: 6) {
                    StreamingMarkdownPrimitive(
                        rawMarkdown: message.content,
                        textColor: ObsidianDS.Colors.textBright
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 6,
                        topTrailingRadius: 20,
                        style: .continuous
                    )
                    .fill(ObsidianDS.Colors.surfaceHighlight)
                )
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 6,
                        topTrailingRadius: 20,
                        style: .continuous
                    )
                    .strokeBorder(ObsidianDS.Colors.borderSubtle, lineWidth: 1)
                )
            }
        }
    }
}

/// Composed Assistant Message Cluster (Avatar + LFM3 Reasoning Disclosure + Tool Pills + Markdown + Action Bar)
public struct AssistantMessageCluster: View {
    @Binding public var message: ChatTurnMessage
    public let modelName: String
    public let isStreaming: Bool
    public let onRegenerate: () -> Void
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ChatAvatarPrimitive(
                systemIcon: "waveform.path.ecg",
                tint: ObsidianDS.Colors.accentTeal,
                background: ObsidianDS.Colors.surfaceElevated
            )
            
            VStack(alignment: .leading, spacing: 10) {
                // Header Label
                HStack(spacing: 6) {
                    Text(modelName)
                        .font(ObsidianDS.Typography.rowLabelMed)
                        .foregroundStyle(ObsidianDS.Colors.textBright)
                    
                    Text("On-Device")
                        .font(ObsidianDS.Typography.badgeNumber)
                        .foregroundStyle(ObsidianDS.Colors.textSecondary)
                }
                
                // 1. LFM3 Thinking Trace Disclosure
                if !message.reasoningTrace.isEmpty || (isStreaming && message.content.isEmpty) {
                    ReasoningDisclosurePrimitive(
                        reasoningText: message.reasoningTrace,
                        isStreaming: isStreaming && message.content.isEmpty,
                        isExpanded: $message.isThinkingExpanded
                    )
                }
                
                // 2. Native Tool Call Pills
                ForEach(message.toolCalls) { tool in
                    ToolInvocationPillPrimitive(tool: tool)
                }
                
                // 3. Streaming Markdown Body
                if !message.content.isEmpty {
                    StreamingMarkdownPrimitive(
                        rawMarkdown: message.content,
                        textColor: ObsidianDS.Colors.textPrimary
                    )
                }
                
                // 4. Bottom Action Bar
                if !isStreaming {
                    MessageActionBarPrimitive(
                        tokensPerSecond: message.tokensPerSecond,
                        onCopy: {
                            #if canImport(UIKit)
                            UIPasteboard.general.string = message.content
                            #endif
                        },
                        onRegenerate: onRegenerate
                    )
                }
            }
            Spacer(minLength: 20)
        }
    }
}

/// Floating Glassmorphic Multi-Modal Prompt Composer Bar
public struct PromptComposerBar: View {
    @Binding public var promptText: String
    @Binding public var enableThinking: Bool
    public let isGenerating: Bool
    public let activeModel: AIModelDescriptor
    public let onSend: () -> Void
    public let onStop: () -> Void
    public let onModelPickerTap: () -> Void
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Growing Text Input Field
            TextField(
                "Ask \(activeModel.displayName) locally on M4...",
                text: $promptText,
                axis: .vertical
            )
            .lineLimit(1...6)
            .font(ObsidianDS.Typography.rowLabel)
            .foregroundStyle(ObsidianDS.Colors.textBright)
            .padding(.horizontal, 6)
            
            // Bottom Control Strip inside Composer
            HStack(spacing: 10) {
                // Attach Button
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(ObsidianDS.Colors.textPrimary)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(ObsidianDS.Colors.surfaceSnippet))
                }
                .buttonStyle(.plain)
                
                // Pluggable Model Switcher Pill
                Button(action: onModelPickerTap) {
                    HStack(spacing: 6) {
                        Image(systemName: "cpu")
                            .font(.system(size: 12))
                            .foregroundStyle(ObsidianDS.Colors.accentTeal)
                        Text(activeModel.displayName)
                            .font(ObsidianDS.Typography.metadata)
                            .foregroundStyle(ObsidianDS.Colors.textBright)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(ObsidianDS.Colors.textSecondary)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 32)
                    .background(Capsule().fill(ObsidianDS.Colors.surfaceSnippet))
                    .overlay(
                        Capsule().strokeBorder(ObsidianDS.Colors.borderSubtle, lineWidth: 0.8)
                    )
                }
                .buttonStyle(.plain)
                
                // LFM3 Reasoning Toggle Pill
                if activeModel.supportsThinking {
                    Button {
                        withAnimation(.snappy) { enableThinking.toggle() }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "brain")
                                .font(.system(size: 12))
                            Text("Think")
                                .font(ObsidianDS.Typography.metadata)
                        }
                        .foregroundStyle(enableThinking ? ObsidianDS.Colors.matchForeground : ObsidianDS.Colors.textSecondary)
                        .padding(.horizontal, 10)
                        .frame(height: 32)
                        .background(
                            Capsule().fill(
                                enableThinking ? ObsidianDS.Colors.accentTeal : ObsidianDS.Colors.surfaceSnippet
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                // Send or Stop Streaming Button
                Button(action: isGenerating ? onStop : onSend) {
                    Image(systemName: isGenerating ? "stop.fill" : "arrow.up")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(ObsidianDS.Colors.surfaceSheet)
                        .frame(width: 34, height: 34)
                        .background(
                            Circle().fill(
                                promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isGenerating
                                ? ObsidianDS.Colors.textDisabled
                                : ObsidianDS.Colors.accentTeal
                            )
                        )
                }
                .buttonStyle(.plain)
                .disabled(promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isGenerating)
            }
        }
        .padding(14)
        .obsidianCard(cornerRadius: 24, fill: ObsidianDS.Colors.surfaceElevated)
        .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}
`​`​`

---

## Part 4: `@Observable` ViewModel & Full Screen Assembly (iPad Pro 11" M4 Ready)

`​`​`swift
import Observation

// MARK: - 6. VIEW MODEL ORCHESTRATOR (@MainActor @Observable)

@MainActor
@Observable
public final class ObsidianAIChatViewModel {
    public var messages: [ChatTurnMessage] = [
        ChatTurnMessage(
            role: .user,
            content: "We need a photo research phase with 4 modalities and local agent tool calling. How does LFM3-1.7B handle this on my M4 iPad Pro?",
            attachments: [.init(filename: "PRD_Architecture.md", fileType: "markdown")]
        ),
        ChatTurnMessage(
            role: .assistant,
            content: """
            `LFM3-1.7B` uses a **24-layer tri-hybrid backbone** (13 gated short convolutions with kernel size 7, 5 sliding-window attention layers, and 6 global attention layers) across a **256K context window**.

            `​`​`swift
            // Deferred Tool Loading in LFM3-1.7B
            let config = ModelConfiguration(id: "mlx-community/LFM3-1.7B-4bit")
            `​`​`

            At 4-bit MLX quantization (`~1.05 GB`), it runs entirely inside your M4 iPad Pro's unified memory with native tool calling and `<think>` reasoning traces.
            """,
            reasoningTrace: "Analyzing user hardware (iPad Pro 11-inch M4) and LFM3-1.7B architecture specs: 1.73B parameters, 13 gated short-convolution layers, 5 sliding-window attention, 6 global attention, 256K token context.",
            toolCalls: [
                .init(name: "vault_vector_search", argumentsJSON: "{\"query\": \"PRD modalities\", \"limit\": 4}", status: "24ms")
            ],
            tokensPerSecond: 68.4
        )
    ]
    
    public var promptText: String = ""
    public var enableThinking: Bool = true
    public var isGenerating: Bool = false
    public var downloadProgress: Double? = nil
    public var activeModel: AIModelDescriptor = .lfm3_1_7B_4bit
    public var isShowingModelSheet: Bool = false
    
    private var provider: any PluggableLLMProvider
    
    public init(provider: any PluggableLLMProvider = OnDeviceMLXProvider()) {
        self.provider = provider
    }
    
    /// Hot-swaps the active model (e.g., LFM3-1.7B 4-bit -> BF16 or Qwen3.5-4B)
    public func selectModel(_ descriptor: AIModelDescriptor) {
        activeModel = descriptor
        isShowingModelSheet = false
        Task {
            try? await provider.loadModel(descriptor) { [weak self] progress in
                Task { @MainActor in
                    self?.downloadProgress = progress < 1.0 ? progress : nil
                }
            }
        }
    }
    
    public func sendMessage() {
        let trimmed = promptText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isGenerating else { return }
        
        let userMsg = ChatTurnMessage(role: .user, content: trimmed)
        messages.append(userMsg)
        promptText = ""
        isGenerating = true
        
        let assistantMsg = ChatTurnMessage(
            role: .assistant,
            content: "",
            reasoningTrace: "",
            isThinkingExpanded: true
        )
        messages.append(assistantMsg)
        let targetIndex = messages.count - 1
        let historySnapshot = Array(messages.dropLast())
        
        Task {
            do {
                let stream = await provider.generateStream(
                    messages: historySnapshot,
                    enableThinking: enableThinking,
                    maxTokens: 4096
                )
                
                for try await event in stream {
                    switch event {
                    case .downloadProgress(let progress):
                        downloadProgress = progress < 1.0 ? progress : nil
                    case .reasoningDelta(let delta):
                        messages[targetIndex].reasoningTrace += delta
                    case .contentDelta(let delta):
                        messages[targetIndex].content += delta
                    case .toolCallDetected(let name, let args):
                        messages[targetIndex].toolCalls.append(
                            .init(name: name, argumentsJSON: args, status: "Executed")
                        )
                    case .metrics(let tps, _, _):
                        messages[targetIndex].tokensPerSecond = tps
                    case .completed:
                        messages[targetIndex].isThinkingExpanded = false
                    }
                }
            } catch {
                messages[targetIndex].content += "\n\n*[Inference Error: \(error.localizedDescription)]*"
            }
            isGenerating = false
            downloadProgress = nil
        }
    }
    
    public func stopGeneration() {
        Task {
            await provider.cancelGeneration()
            isGenerating = false
        }
    }
}

// MARK: - 7. FULL AI CHAT SCREEN & PLUGGABLE MODEL SWITCHER SHEET

public struct ObsidianAIChatScreen: View {
    @State private var viewModel = ObsidianAIChatViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ObsidianDS.Colors.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Floating Navigation Bar
                HStack {
                    ObsidianCircleIconButton(systemName: "sidebar.left", action: {})
                    
                    Spacer()
                    
                    // Center Model Status Pill
                    Button {
                        viewModel.isShowingModelSheet = true
                    } label: {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(ObsidianDS.Colors.accentTeal)
                                .frame(width: 8, height: 8)
                            Text(viewModel.activeModel.displayName)
                                .font(ObsidianDS.Typography.rowLabelMed)
                                .foregroundStyle(ObsidianDS.Colors.textBright)
                            Text(viewModel.activeModel.quantization)
                                .font(ObsidianDS.Typography.metadata)
                                .foregroundStyle(ObsidianDS.Colors.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .obsidianCapsule()
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    ObsidianDualActionPill(onEdit: {}, onMore: {
                        viewModel.isShowingModelSheet = true
                    })
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // Optional Weight Download Progress Banner
                if let progress = viewModel.downloadProgress {
                    ProgressView(value: progress)
                        .tint(ObsidianDS.Colors.accentTeal)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 6)
                }
                
                // Scrollable Message Stream
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 22) {
                            ForEach($viewModel.messages) { $message in
                                if message.role == .user {
                                    UserPromptBubble(message: message)
                                        .id(message.id)
                                } else if message.role == .assistant {
                                    AssistantMessageCluster(
                                        message: $message,
                                        modelName: viewModel.activeModel.displayName,
                                        isStreaming: viewModel.isGenerating && message.id == viewModel.messages.last?.id,
                                        onRegenerate: {}
                                    )
                                    .id(message.id)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    }
                    .onChange(of: viewModel.messages.last?.content) { _, _ in
                        if let lastID = viewModel.messages.last?.id {
                            withAnimation(.easeOut(duration: 0.15)) {
                                proxy.scrollTo(lastID, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Bottom Prompt Composer Bar
                PromptComposerBar(
                    promptText: $viewModel.promptText,
                    enableThinking: $viewModel.enableThinking,
                    isGenerating: viewModel.isGenerating,
                    activeModel: viewModel.activeModel,
                    onSend: { viewModel.sendMessage() },
                    onStop: { viewModel.stopGeneration() },
                    onModelPickerTap: { viewModel.isShowingModelSheet = true }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $viewModel.isShowingModelSheet) {
            PluggableModelSelectorSheet(
                selectedModel: viewModel.activeModel,
                onSelect: { viewModel.selectModel($0) }
            )
            .presentationDetents([.medium])
            .presentationCornerRadius(28)
            .presentationBackground(ObsidianDS.Colors.surfaceSheet)
        }
    }
}

/// Pluggable Model Selector Sheet (Styled identically to IMG_0079 Action Sheet)
public struct PluggableModelSelectorSheet: View {
    public let selectedModel: AIModelDescriptor
    public let onSelect: (AIModelDescriptor) -> Void
    
    public var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(ObsidianDS.Colors.textSecondary.opacity(0.6))
                .frame(width: 46, height: 5)
                .padding(.top, 10)
            
            Text("Pluggable On-Device Models (iPad Pro M4)")
                .font(ObsidianDS.Typography.rowLabelMed)
                .foregroundStyle(ObsidianDS.Colors.textBright)
            
            VStack(spacing: 0) {
                ForEach(Array(AIModelDescriptor.catalog.enumerated()), id: \.element.id) { index, model in
                    Button {
                        onSelect(model)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "cpu.fill")
                                .foregroundStyle(
                                    model.id == selectedModel.id
                                    ? ObsidianDS.Colors.accentTeal
                                    : ObsidianDS.Colors.textSecondary
                                )
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(model.displayName)
                                    .font(ObsidianDS.Typography.rowLabelMed)
                                    .foregroundStyle(ObsidianDS.Colors.textBright)
                                Text("\(model.family) • \(model.quantization) • \(model.contextWindow / 1024)K ctx")
                                    .font(ObsidianDS.Typography.metadata)
                                    .foregroundStyle(ObsidianDS.Colors.textSecondary)
                            }
                            
                            Spacer()
                            
                            if model.id == selectedModel.id {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(ObsidianDS.Colors.accentTeal)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 58)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    if index < AIModelDescriptor.catalog.count - 1 {
                        Divider()
                            .background(ObsidianDS.Colors.divider)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .obsidianCard()
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}

#Preview("Obsidian LFM3-1.7B Chat") {
    ObsidianAIChatScreen()
}
`​`​`

Would you like me to add a deferred tool-calling dispatcher (`defer_loading=True`) so `LFM3-1.7B` can query and mutate your local Markdown vault files directly from the chat stream?

Powered by Gemini Exporter (https://www.ai-chat-exporter.com)
