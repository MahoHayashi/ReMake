# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

ReMake is a SwiftUI iOS app (iOS 18.5+, Swift 5) for recording makeup looks ("メイク")
and the cosmetics ("コスメ") used in them. Users register cosmetics by category, build
makeup records that reference those cosmetics, attach camera photos (face/eye), and
compare two saved looks side by side. The codebase and commit history are in Japanese.

## Commands

Build, test, and run all go through `xcodebuild` (single scheme: `ReMake`). The camera
features require a physical device, but most logic and SwiftData tests run on a simulator.

```bash
# Build
xcodebuild -project ReMake.xcodeproj -scheme ReMake -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run all tests (unit + UI)
xcodebuild -project ReMake.xcodeproj -scheme ReMake -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test (unit example shown; swap target/name for UI tests)
xcodebuild -project ReMake.xcodeproj -scheme ReMake -destination 'platform=iOS Simulator,name=iPhone 16' \
  test -only-testing:ReMakeTests/ReMakeTests/saveMakeupPersistsRecordOnDisk
```

Unit tests use the **swift-testing** framework (`import Testing`, `@Test`, `#expect`).
UI tests use **XCTest** (`import XCTest`, `XCUIApplication`).

## Architecture

MVVM over SwiftData. The migration to MVVM is recent (see commits #19/#20), so expect
some Views still holding logic.

- **Models** (`ReMake/Model/`) — SwiftData `@Model` classes: `Cosmetic` and
  `MakeupRecord`. Both are registered in `ReMakeApp.swift` via
  `.modelContainer(for: [Cosmetic.self, MakeupRecord.self])`. Any new `@Model` type
  must be added to that array or it won't persist.
- **ViewModels** (`ReMake/ViewModel/`) — `@MainActor final class ... : ObservableObject`
  with `@Published` state. ViewModels receive the `ModelContext` as a method parameter
  (e.g. `saveMakeup(to: context)`); they do **not** own/inject the context themselves.
- **Views** (`ReMake/View/`) — own their ViewModel via `@StateObject`, read SwiftData
  with `@Query`, and get the context from `@Environment(\.modelContext)`. The View
  passes `@Query` results into the ViewModel (e.g. `pickerOptions(from: cosmetics)`,
  `updateSections(from:)`) — the ViewModel never queries SwiftData directly.

### Key data-flow conventions

- **Category strings are the join key, not relationships.** `Cosmetic.category` is a
  free-form `String` (e.g. "化粧下地", "リップ", "アイシャドウ"). Makeup input filters
  cosmetics by matching these category strings. The canonical category list lives in
  `InputCosmeViewModel.sections`. The `base` selection type intentionally spans three
  categories: `["化粧下地", "ファンデーション", "コンシーラー"]`.
- **`SelectionType` enum is duplicated** in both `InputMakeupViewModel` and
  `MakeupDetailViewModel`, with **slightly different Japanese display titles** per
  context. Its `rawValue`s are the persisted keys in `MakeupRecord.selectedItems`
  (`[String: String]`), so changing a case's raw value breaks saved records.
- **Multi-value items are stored as `", "`-joined strings.** On save, each selection's
  list is `joined(separator: ", ")`; on read, `components(separatedBy: ", ")`. Keep this
  separator consistent across save/load paths.
- **`Cosmetic.listProduct`** (`"\(brand) \(product) \(color)"`) is the display string
  used everywhere and also as the lookup identity when deleting cosmetics — there is no
  ID-based delete for cosmetics, so the composed string must stay unique enough.

### Camera

`Camera.swift` wraps `UIImagePickerController` via `UIViewControllerRepresentable`,
fixes EXIF orientation, and emits JPEG `Data`. Captured images flow through
`CameraLaunchViewModel` (holds `imageData` and a `capturedType` of `"face"`/`"eye"`)
into the makeup record as `faceImageData` / `eyeImageData`.

## Gotchas

- `SavedMakeListViewModel` mirrors `@Query` results into its own `@Published cards`
  array (via `updateCards(from:)`) so it can mutate the list optimistically on delete.
  Keep this mirror in sync when changing the list flow.
- Comparison mode caps selection at **2** records (`toggleSelection` shows an alert past
  2); `CompareMakeupView` expects exactly the two selected cards.
- Error handling is inconsistent: some saves `try? context.save()` (silent), others
  `print` on failure. When fixing save-reliability issues (the current branch theme),
  surface errors via the existing `showAlert` published flags rather than swallowing.
