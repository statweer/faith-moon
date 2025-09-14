# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Faith Moon (formerly Qadha Tracker) is an iOS/watchOS/visionOS app that helps Muslim users track their Qadha (missed) prayers and fasts. Built with SwiftUI and SwiftData using Swift 6.

## Build and Development Commands

### Building the Project
```bash
# Build for iOS
xcodebuild -scheme FaithMoon -configuration Debug build

# Build for watchOS
xcodebuild -scheme "FaithMoon Watch" -configuration Debug build

# Clean build
xcodebuild -scheme FaithMoon clean
```

### Running SwiftLint
```bash
# Run linting (SwiftLint is configured via .swiftlint.yml)
swiftlint

# Auto-fix correctable violations
swiftlint --fix
```

### Opening in Xcode
```bash
open FaithMoon.xcodeproj
```

## Architecture

### Core Data Model
- **SwiftData**: Uses `@Model` for persistence with `Prayer` as the main entity
- **ModelContainer**: Configured in `DataController.swift` with CloudKit sync support
- **App Group**: Shared data between iOS and watchOS apps via `group.com.statweer.faithmoon`

### Key Components

1. **Prayer Model** (`Models/Prayer.swift`):
   - Core data model with properties: id, localizationKey, intrinsicOrder, count, lastModified
   - Includes default prayer types: Fajr, Dhuhr, Asr, Maghrib, Isha, Ayat, Ramadan Fast

2. **KeyValueStore** (`Models/KeyValueStore.swift`):
   - Observable store for app preferences using `@Observable` macro
   - Syncs between UserDefaults and iCloud (NSUbiquitousKeyValueStore)
   - Manages sort preferences across devices

3. **DataController** (`Models/DataController.swift`):
   - Manages SwiftData ModelContainer setup
   - Handles initial data insertion and duplicate cleanup
   - Configures CloudKit container for sync

### Platform Support
- iOS 16.4+
- watchOS support via companion app
- visionOS support with adaptive UI
- Uses platform checks via utility functions in `Utils.swift`

## Code Style

- **SwiftLint**: Strict configuration with custom rules
- **Indentation**: 2 spaces
- **Line length**: Flexible for URLs, function declarations, and comments
- **Naming**: Allows short names like `i`, `id`, `x`, `y`, `z`
- **Font Design**: Uses SF Rounded system font throughout

## Important Notes

- Bundle ID: `com.statweer.faithmoon`
- CloudKit container: `iCloud.com.statweer.faithmoon`
- Localization: Multi-language support via `.xcstrings` files
- Dynamic Type: Limited to accessibility1 size
- Navigation bar appearance customized with rounded fonts