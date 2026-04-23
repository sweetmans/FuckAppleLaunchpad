# Agent Guidelines for FuckAppleLaunchpad Project

## Quick Facts
- **Type**: macOS app (SwiftUI, Swift 6.2+)
- **Target**: macOS 16.0+ (expanded from 26.0 for broader compatibility)
- **Requires**: Xcode 26+ (currently 26.4.1)
- **Structure**: View/, ViewModel/, Models.swift, FuckAppleLaunchpadApp.swift

## Critical Commands

```bash
# Debug build (fastest)
xcodebuild -scheme FuckAppleLaunchpad -configuration Debug build

# Run tests (uses Testing framework, async syntax)
xcodebuild -scheme FuckAppleLaunchpad -destination 'platform=macOS' test

# Single test
xcodebuild -scheme FuckAppleLaunchpadTests -destination 'platform=macOS' \
  -only-testing:FuckAppleLaunchpadTests/FuckAppleLaunchpadTests/example test

# Release build
xcodebuild -scheme FuckAppleLaunchpad -configuration Release build
```

## No CI/CD Workflows
No GitHub Actions or pre-commit hooks configured. Manual testing is expected before PR.

## Code Style Guidelines

### File Organization
- Group related functionality in View, ViewModel, and Model folders
- Keep files focused on a single responsibility (< 200 lines when possible)

### Import Statements
- Group imports: System frameworks (SwiftUI, AppKit, Combine) first, then local imports
- Each import on its own line; no unused imports

### Specific Patterns Used in This Project
- ViewModels use `@Published` properties with `ObservableObject`
- Views observe ViewModels with `@StateObject` or `@ObservedObject`
- Data models are simple structs conforming to `Identifiable` (defined in Models.swift)
- Image loading uses `NSImage` with fallback placeholders
- App termination: `NSApplication.shared.terminate(nil)`
- Groups: Click folder (with >2 apps) opens modal grid like real macOS Launchpad (GroupDetailView)

### Testing Guidelines
- Unit tests in `FuckAppleLaunchpadTests` target
- UI tests in `FuckAppleLaunchpadUITests` target (present but minimal)
- Use `Testing` framework with `@Test` and `#expect()`
- Tests are async-first (`async throws`)