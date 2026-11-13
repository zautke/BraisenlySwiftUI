# Catalog visual audit and fix brief (2026-11-13)

Source: screenshots from the BraisenlySwiftDemo 0.1.0 UI walk (macOS on largo, iPad Pro 11-inch "presto").
Contact sheets of the "before" state: `/Volumes/MACDEV/BraisenlySwiftDemo-scaffold/build/shots/audit/`
(`L-aa.png` … `L-al.png` = all 71 entries in Solarized Light on macOS, six per sheet, alphabetical by file name;
`X-liquidGlass.png`, `X-solarizedDark.png` = six entries each; `P-1.png` = four iPad shots;
`full-light.png`, `full-dark.png`, `full-glass.png` = whole-window shots).

Two repos, two worktrees, one branch name:

| Repo | Worktree | Branch |
|---|---|---|
| `zautke/BraisenlySwiftUI` (package) | `/Volumes/MACDEV/BraisenlySwiftUI-visual-audit` | `fix/catalog-visual-audit` |
| `zautke/BraisenlySwiftDemo` (catalog app) | `/Volumes/MACDEV/BraisenlySwiftDemo-scaffold` | `fix/catalog-visual-audit` |

The demo's `.env` points `BRAISENLY_PACKAGE_PATH` at the package worktree, so a demo build compiles the package edits.

## Findings

Each finding has an id, the owning lane, and an acceptance check. "Light", "Dark", "Glass" are the themes
`solarizedLight`, `solarizedDark`, `liquidGlass`.

### Shell and backgrounds

| ID | Lane | Finding | Accept when |
|---|---|---|---|
| F1 | shell | Toolbar band behind "Braisenly Catalog" is a different tone from the detail background, with a gradient between (Light `FBF6E3` vs `FAF6E5`; Dark `172938` vs `192935`). | In Light and Dark a pixel sampled in the toolbar band equals a pixel sampled in the empty detail background (within 1 per channel). Glass keeps system behaviour. |
| F2 | shell | Sidebar header (theme switcher + search field) sits on a darker patch (`D3D1C1` vs `EBE8D7`) caused by heavy shadows. | Sidebar background is one flat colour in Light and Dark except where a control actually is. |
| F3 | shell | `layout.splitView` stage: the nested split view paints its detail background only in a middle band; sidebar and detail backgrounds do not fill the stage height. | Nested sidebar and detail each fill the full stage height with one colour in all three themes. |
| F4 | content | `BraisenlyMobileWorkspaceView` ignores the environment theme: white inside Light, neutral grey inside Dark. | With `initialTheme` unset or equal to the app theme it matches the surrounding theme; the entry's `initialTheme` knob still overrides. Decide from the component's API; do not remove the knob. |
| F5 | demo | Detail content starts at different x positions per entry (title x = 14, 36, 42 pt-equivalents) and never aligns with the toolbar title. | Entry title's left edge is at the same x for every entry (inline and canvas, with and without scrollbar) and aligns with the "Braisenly Catalog" toolbar title. |
| F6 | shell | iPad: navigation title "Braisenly Catalog" renders on the status-bar clock line. | On iPad the title is not drawn in the status bar row (inline title in the navigation bar, or hidden on iPad). Reviewer verifies on presto. |
| F7 | demo | iPad: detail content uses about half the detail pane, with large dead margins both sides. | On iPad landscape inline entries fill the detail pane up to the reading width with symmetric page padding; no margin wider than the page padding unless the reading-width cap is hit. Reviewer verifies on presto. |
| F8 | shell | iPad: a stray sidebar-toggle button floats above the search field inside the `workspaces.regular` stage (nested `NavigationSplitView` toolbar). | No extra toggle button above the embedded sidebar's search header; the document chrome's own toggle still works. Reviewer verifies on presto. |

### Containers not sized to content

| ID | Lane | Finding | Accept when |
|---|---|---|---|
| F9 | demo | "Item N" capsules in `layout.vStack`, `layout.hStack`, `layout.scroll`, `layout.grid`, `layout.zStack` and the "A"/"B" chips in `tokens.metrics` have no padding; text touches or crosses the capsule edge. | Every such capsule has horizontal and vertical theme-step padding and the glyphs sit fully inside it. The entry's snippet shows the same padding call. |
| F10 | content | `BraisenlyColorSwatch` names break mid-word over 3–4 lines ("back-groun-dPri-mary") in `tokens.colors` and `tokens.solarizedPalette`. | Names never hyphenate mid-word. They stay on one line and truncate in the middle, or wrap only at camel-case boundaries, at the default 96 pt column. |
| F11 | content | Highlighted text is broken in `cards.searchSnippetCard`, `rowsGroups.expandableSearchResult` (expanded) and inside the workspaces' sidebar: highlight chips sit off the baseline, overlap neighbouring words, and the sentence splits into detached fragments. | Highlighted runs flow inline in one wrapped paragraph, share the baseline, never overlap other glyphs, and the text reads in order. |
| F12 | demo | Colour knob grids in `KnobsPane` leave a large empty gap under the label and ~150 pt between the two swatch rows; swatches have no names. | Swatch grid rows are spaced by one theme step, the grid starts directly under its label, and the selected token's name is visible (caption or accessibility value plus visible text). |
| F13 | demo | `document.chrome` stage: top chrome and bottom toolbar nearly collide in a canvas that is too short. | The stage is tall enough that the two bars are clearly separated (at least 120 pt of free space between). |
| F14 | demo | `document.actionSheet` stage is clipped at the top and the sheet is a narrow column in a wide empty card. | The first row is fully visible, nothing is clipped, and the sheet is centred at a sheet-like width with the card hugging it or a deliberate margin. |
| F15 | demo | `workspaces.compact` says "phone-width" but renders full width. | The stage constrains the workspace to a phone width (about 390 pt) centred in the card. |
| F16 | demo | `layout.scroll` stage: items clip at the card edge and the scroller is a thick dark bar. | Items are inset from the card edge by padding; the scroll container has an explicit frame inside the card. |

### Controls, contrast and consistency

| ID | Lane | Finding | Accept when |
|---|---|---|---|
| F17 | surfaces | Selected segment unreadable in Light: teal text on a dark grey pill. Affects `BraisenlySegmentedControl`, selected `BraisenlyNavRow`, selected chip in `BraisenlyChipGroup`. | Selected label vs selected fill has a WCAG contrast ratio of at least 4.5:1 in Light and Dark, proven by a unit test that computes it from the theme tokens. Glass unchanged unless it also fails. |
| F18 | surfaces | Heavy grey drop shadows on solid themes: segments, chips, capsules, search field, theme-switcher pills. | On solid themes control-role capsules use a hairline stroke with at most a subtle shadow (opacity ≤ 0.08, radius ≤ 4). No visible grey halo in Light. |
| F19 | surfaces | `BraisenlyToggleRow` differs by platform: macOS shows a small checkbox in a hugging capsule, iPad a full-width switch row. | On macOS the row is full width with the title leading and a switch-style control trailing, matching iPad. |
| F20 | surfaces + content | Unthemed system controls: stepper arrows in `BraisenlyStepperRow` (surfaces); the horizontal scroller in `BraisenlyCodeBlockCard` (content). | Stepper uses themed minus/plus buttons on both platforms. Code block scroll indicators hidden or themed; long lines still scroll. |
| F21 | demo | Four Fields entries are titled with raw type names ("BraisenlyKeyEntryField", "BraisenlyParameterSliderRow", "BraisenlyPromptField", "BraisenlyTextFieldRow"). | Titles follow the other groups: "Key Entry Field", "Parameter Slider Row", "Prompt Field", "Text Field Row". `typeName` is unchanged. Fix any test that pins the old titles. |
| F22 | demo | Stages too faint to read: `layout.icon`, `indicators.pulseIndicator`, `indicators.avatarBadge`, `buttonsPills.toolbarIconButton`; theme-switcher pills nearly vanish in Dark. | Each of those stages shows its component at a clearly visible default size (e.g. icon default `large`, badge/button ≥ 44 pt). Report the Dark switcher-pill contrast to the surfaces lane if it is a package colour problem. |
| F23 | content | Knob captions and the property-table "Type" row are very small beside the values. | `BraisenlyTextFieldRow` caption and `BraisenlyPropertyTable` key/value text are at least the theme's `metadata` size and never smaller than 11 pt. |
| F24 | surfaces | `BraisenlyParameterSliderRow` track shows a row of tick dots that reads as noise. | No tick marks for steps finer than 10 stops; the track is a clean line. |

## Lanes and file ownership

Only the owning lane edits a file. If a fix needs a file you do not own, write the request into your final report; do not edit it.

| Lane | Model | Package files (under `Sources/BraisenlySwiftUI/`) | Demo files |
|---|---|---|---|
| shell | opus | `Layout/BraisenlySplitView.swift`, `BraisenlySidebarSearchHeader.swift`, `BraisenlyThemeSwitcher.swift`, `BraisenlyRegularWorkspace.swift`, `BraisenlySidebarDrawer.swift` | `Sources/DemoApp.swift`, `Sources/Shell/CatalogSidebar.swift` |
| surfaces | sonnet | `BraisenlyCapsuleModifier.swift`, `BraisenlyCardModifier.swift`, `BraisenlyGlassGroup.swift`, `Controls/BraisenlySegmentedControl.swift`, `Controls/BraisenlyChipGroup.swift`, `Controls/BraisenlyNavRow.swift`, `Controls/BraisenlyToggleRow.swift`, `Controls/BraisenlyStepperRow.swift`, `BraisenlyParameterSliderRow.swift`, `Theme/BraisenlyTokens.swift` | none |
| content | opus | `BraisenlyHighlightedText.swift`, `BraisenlyHighlightedTextSegment.swift`, `BraisenlySearchSnippetCard.swift`, `BraisenlyExpandableSearchResult.swift`, `Controls/BraisenlyColorSwatch.swift`, `BraisenlyMobileWorkspaceView.swift`, `BraisenlyCodeBlockCard.swift`, `Controls/BraisenlyPropertyTable.swift`, `Controls/BraisenlyTextFieldRow.swift` | none |
| demo | sonnet | none | `Sources/Shell/CatalogDetail.swift`, `Sources/Shell/KnobsPane.swift`, `Sources/Shell/SnippetPane.swift`, everything under `Sources/Catalog/` |

Tests: each lane may add or edit test files that test its own source files. Nobody edits `CHANGELOG.md`, `Package.swift`,
`project.yml`, `scripts/`, version numbers or tags; the reviewer does that.

## Procedure (every lane)

1. Read this file, then look at the "before" contact sheets that show your findings (Read tool on the PNG paths above).
2. Read each source file you own before editing it. Trace how the component reads the theme
   (`@Environment(\.braisenlyTheme)`, `theme.surface`, `theme.colors`, `theme.metrics`, `theme.typography`).
3. Fix the root cause in the shared code, not per call site. Smallest change that meets the acceptance check.
   No new public API unless a finding cannot be met without it; if you add one, say so in the report.
4. Hard rules:
   - Colours, fonts, spacing and radii come from theme tokens. No hard-coded colours or sizes in components.
   - The demo's `Sources/` must use only `Braisenly*` views and modifiers (dog-food lint). Run
     `scripts/dogfood-lint.sh` in the demo worktree after any demo edit; it must print `0 hit(s)`.
   - Swift 6 strict concurrency; demo app targets default to `@MainActor`, registry types are `nonisolated`.
   - Do not change accessibility identifiers (`catalog.*`, `knob.*`) or entry ids; UI tests depend on them.
   - Physical devices only. Never start a simulator.
5. Build and look. One build at a time on this machine, enforced by a lock. Use only these commands:
   - Screenshot (builds first, takes the lock itself):
     `cd /Volumes/MACDEV/BraisenlySwiftDemo-scaffold && scripts/shot.sh -e <entryId> -t <theme> -o build/shots/fix/<lane>/<name>.png`
     Add `-n` to skip the build when you only need another entry or theme from the same build.
     Then Read the PNG and judge it against the acceptance check. Entry ids: `UITests/Fixtures/catalog-entry-ids.txt`.
   - Package unit tests (wrap in the lock yourself):
     `cd /Volumes/MACDEV/BraisenlySwiftUI-visual-audit && /usr/bin/lockf /Volumes/MACDEV/.braisenly-build.lock swift test --scratch-path /Volumes/MACDEV/BraisenlySwiftUI/.build --filter <SuiteName>`
   - Demo unit tests: `cd /Volumes/MACDEV/BraisenlySwiftDemo-scaffold && /usr/bin/lockf /Volumes/MACDEV/.braisenly-build.lock scripts/test-unit.sh`
   - Never call `xcodebuild` or `swift build` outside the lock, never run UI tests, never run two builds at once.
   - If a build fails with an error in a file you do not own, another lane is mid-edit: wait 60–90 s and retry, up to 5 times.
     Do not touch that file. If it still fails, record the exact error in your report and continue with other findings.
6. For every finding: screenshot in `solarizedLight` and `solarizedDark` at minimum, plus `liquidGlass` when you touched
   anything that branches on `theme.surface`. Keep the final "after" PNGs under `build/shots/fix/<lane>/` named `<findingId>-<theme>.png`.
7. Commit per finding, in the repo the file lives in, staging only your own files by path:
   `git add <paths> && git commit -m "fix(<scope>): <what> (F<n>)"` then `git push`. If `git` reports an index lock, wait 5 s and retry.
   End each commit message with the two trailer lines given in your task prompt.
8. Final report (your last message), exactly this JSON shape:
   `{"lane": "...", "findings": [{"id": "F1", "status": "fixed|partial|blocked", "commits": ["<sha>"], "files": ["..."], "evidence": ["<png path>"], "notes": "..."}], "tests": [{"cmd": "...", "result": "..."}], "requests_for_other_lanes": ["..."], "open_issues": ["..."]}`
   Report what you saw in the screenshots, not what you intended. "partial" and "blocked" with reasons are acceptable; a false "fixed" is not.

## Review (reviewer, after all lanes)

Full package `swift test`, demo `scripts/check.sh`, a fresh macOS UI walk and a presto UI walk, new contact sheets compared
against the "before" sheets, pixel samples for F1/F2, then CHANGELOG, version bump and the release records.
