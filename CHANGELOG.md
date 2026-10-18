## 0.4.0

- Added direct adaptive navigation padding, margin, size, color, blur, and label
  controls, plus an integrated `appBar` to simplify page setup.
- Kept native rail positioning and bottom-only scroll collapse intact.

## 0.3.0

- Added iOS Swift Package Manager support while retaining CocoaPods compatibility,
  resolving Flutter's missing SwiftPM support warning for this plugin.

- Added opt-in bottom navigation scroll collapse to `FloatingAdaptiveNavScaffold`
  with `collapseOnScroll` and configurable `collapseDistance`. Side rails stay
  expanded, and collapse resets when navigation placement or selection changes.

## 0.2.1

- Added actual folded and unfolded iPhone Duo simulator screenshots to the
  pub.dev gallery and both READMEs.
- Clearly separated simulator captures from rendered style previews.
- No runtime API or behavior changes from 0.2.0.

## 0.2.0

- Refined the glass preset with a single translucent tint, softer shadows,
  stronger backdrop blur, and rounded selection styling.
- Added automatic iPhone Duo sidebar support through `FloatingAdaptiveNavScaffold`, native iOS vertical-bar trait detection,
  explicit side placements, and vertical `FloatingModernNavBar` layout.
- Preserved page state across adaptive transitions and added accessible labels
  for icon-only navigation and reduced-motion support.
- Added light/dark and side previews, a redesigned example, and regression tests.
- Migrated the example to the current Flutter iOS scene lifecycle and CocoaPods
  integration. Duo detection requires building with iOS SDK 27.1 or newer;
  older SDKs and unsupported platforms retain bottom navigation.

- Fixed duplicate Duo side safe-area spacing and positioned the rail using the native bar layout region.
- Added a complete usage guide, API reference, and runnable documentation examples.

## 0.1.1+5

- Removed Unsupported Platforms
