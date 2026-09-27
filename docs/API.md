# API reference

[← Getting started](../README.md) · [Usage guide](USAGE.md)

Import every public component from one library:

```dart
import 'package:floating_modern_navbar/floating_modern_navbar.dart';
```

All dimensions below are Flutter logical pixels. All widgets also accept the
standard optional `key`. A default of `null` means the package resolves a value
from the theme or preset; it does not necessarily mean the effect is disabled.

## FloatingNavBarItem

One navigation destination. Supply an `IconData`, not an `Icon` widget.

| Property | Default | What it does |
| --- | --- | --- |
| `icon` | Required | Icon displayed when unselected; also selected if `activeIcon` is absent. |
| `activeIcon` | `null` | Alternative selected icon, such as a filled heart. |
| `label` | Required | Visible label and accessible name. Keep it meaningful even with labels hidden. |
| `tooltip` | `null` | Tooltip text; falls back to `label`. |
| `badgeCount` | `null` | Positive numbers display a badge; values above 99 display `99+`. Zero, negative values, and `null` hide it. |

Create a new item with an updated `badgeCount` when your unread count changes
and rebuild the parent. Item fields are immutable. Custom icon widgets,
per-item colors, and disabled items are not currently exposed.

## FloatingAdaptiveNavScaffold

A page host that chooses bottom or side navigation. Use it in a full-page
layout, normally as `MaterialApp.home` or a route's root widget. It creates its
own `Scaffold`; it is not a widget for `Scaffold.bottomNavigationBar`.

| Property | Default | What it does |
| --- | --- | --- |
| `body` | Required | Your page content. It may contain an `IndexedStack`, navigator, or scrollable. |
| `items` | Required | Navigation destinations. |
| `currentIndex` | Required | Zero-based selected destination. Keep it within the items list. |
| `onTap` | Required | Receives the tapped index. Update your state or router here. |
| `variant` | `FloatingNavBarVariant.glassmorphism` | Appearance of the navigation bar. |
| `placement` | `FloatingNavBarPlacement.automatic` | Automatic native placement or a manual override. |
| `backgroundColor` | `null` | **Page/scaffold background**, not the glass tint. Falls back to the Scaffold theme. |

### Placement values

| Value | Behavior |
| --- | --- |
| `automatic` | On supported iOS builds, reads the native vertical-bar edge and bar layout region. Falls back to bottom navigation on other devices/platforms or when native support is unavailable. |
| `bottom` | Forces a horizontal bottom bar. |
| `left` | Forces a rail on the physical left, including in RTL. |
| `right` | Forces a rail on the physical right, including in RTL. |

The scaffold enables `extendBody` for bottom glass. Its side layout reserves
content space once, consumes the corresponding side safe-area padding, hides
visual item labels, and permits long rails to scroll. Your content can still
use `SafeArea` for the remaining edges. Body state survives placement changes;
keeping separate tab pages alive is your responsibility (for example, with
`IndexedStack`).

This wrapper currently exposes only the properties in the table. It does not
forward the standalone bar's color, blur, margin, animation, or scroll-progress
options, and it does not expose `appBar`, drawers, or a floating action button.
Use `FloatingModernNavBar` in your own layout when you need those controls.

## FloatingModernNavBar

The standalone bar. It draws destinations and reports taps; it does not choose
pages, manage routes, detect Duo, or listen to scrolling by itself.

### Selection and preset

| Property | Default | What it does |
| --- | --- | --- |
| `items` | Required | Destination list; use a nonempty list. |
| `currentIndex` | Required | Selected index, from `0` to `items.length - 1`. |
| `onTap` | Required | `ValueChanged<int>` callback for taps. |
| `variant` | `FloatingNavBarVariant.modern` | Modern, Glass, or Compact preset. |

### Size and shape

| Property | Default | What it does |
| --- | --- | --- |
| `axis` | `Axis.horizontal` | `Axis.vertical` stacks destinations into a rail. You must place it beside the page yourself. |
| `height` | `74` | Expanded horizontal surface height, excluding outer safe-area/margin space. Not the total rail height. |
| `margin` | `EdgeInsets.fromLTRB(16, 0, 16, 16)` | Minimum outer spacing through `SafeArea`; system insets can be larger. |
| `padding` | Horizontal `6`, vertical `6` | Space between the container and items. |
| `itemPadding` | Horizontal `4`, vertical `8` | Padding inside each destination. |
| `borderRadius` | `36` | Container corner radius. |
| `itemBorderRadius` | `28` | Selected/unselected item background corner radius. |
| `itemMainAxisAlignment` | `MainAxisAlignment.center` | Alignment within each item's icon/label column. Since the column is shrink-wrapped, changing it may have little visible effect. |

Horizontal destinations share available width equally. The current vertical
layout uses a 72-pixel surface width and 56-pixel item slots; these dimensions
are not separately configurable. The standalone vertical bar does not provide
its own scrolling container.

### Surface, glass, and shadows

| Property | Default | What it does |
| --- | --- | --- |
| `backgroundColor` | `null` | Base surface tint used by the default gradient. Modern/Compact use `colorScheme.surface`; Glass uses a translucent light/dark tint. |
| `backgroundGradient` | `null` | Replaces the generated surface gradient, including its base tint. Use translucent colors for glass. |
| `backdropBlur` | `24` | Blur sigma in both directions, used only by Glass. `0` removes blur but retains the tint. Use a nonnegative value. |
| `borderColor` | `null` | Glass uses a white highlight border; other presets use the theme's outline variant at 40% alpha. Use `Colors.transparent` to hide it. |
| `borderWidth` | `1` | Border thickness. A zero-width Flutter border can render as a hairline; use a transparent color to remove it. |
| `boxShadow` | `null` | Replaces the preset's two outer shadows. Use `const []` to remove those shadows. |
| `shadowColor` | `null` | Base color for the main outer shadow and Material shadow; defaults to `colorScheme.shadow`. The preset applies its own alpha; the secondary outer shadow uses the primary color. |
| `elevation` | `0` | Material elevation, separate from `boxShadow`. Leave at `0` when removing all shadows. |

The default surface gradient adds a subtle primary-color tint. Glass also adds
a light highlight and uses different light/dark base colors. To control the
exact surface fill, supply your own `backgroundGradient`.

### Colors, icons, and labels

| Property | Default | What it does |
| --- | --- | --- |
| `selectedItemColor` | Primary color at 14% alpha | Selected pill **background**. |
| `unselectedItemColor` | `Colors.transparent` | Unselected item background. |
| `selectedLabelColor` | Primary color | Selected **icon and label** color. |
| `unselectedLabelColor` | On-surface color at 70% alpha | Unselected **icon and label** color. |
| `indicatorColor` | Primary color | Badge background color. Despite its name, it does not draw an underline or selection indicator. |
| `iconSize` | `22` | Base icon size before selected scaling and Compact adjustments. |
| `selectedIconScale` | `1.08` | Selected icon size multiplier. Use `1` to disable the size change. |
| `showLabels` | `true` | Shows text below icons. Compact always hides text. |
| `selectedLabelStyle` | Theme `labelMedium` | Selected label font styling. The implementation overrides its color with `selectedLabelColor` and weight with `w700`. |
| `unselectedLabelStyle` | Theme `labelMedium` | Unselected label font styling. Color comes from `unselectedLabelColor`; weight is `w500`. |

Labels stay on one line. Item content can scale down to fit, so generous sizes
and short labels are helpful for readability. Badge text is white and is not
currently customizable independently of the badge background.

### Interaction and animation

| Property | Default | What it does |
| --- | --- | --- |
| `enableFeedback` | `true` | Enables platform-dependent tap feedback from `InkWell`; a haptic response is not guaranteed on every device. |
| `splashColor` | Primary color at 10% alpha | Ink splash color. |
| `highlightColor` | Primary color at 6% alpha | Press highlight color. |
| `animationDuration` | `240ms` | Item background, selected-icon scale, and label-style transition duration. |
| `animationCurve` | `Curves.easeOutCubic` | Curve for those item transitions. |
| `containerAnimationDuration` | `220ms` | Whole-bar opacity and scale transition duration. |
| `containerAnimationCurve` | `Curves.easeOutCubic` | Whole-bar opacity and scale curve. |

`MediaQuery.disableAnimations` makes these animated transitions immediate.
It does not turn off scroll tracking or prevent the final collapsed state.
Container height and bottom inset are calculated directly from progress;
`containerAnimationDuration` does not independently animate those dimensions.

### Collapse and transparency

| Property | Default | What it does |
| --- | --- | --- |
| `collapseProgress` | `0` | Expanded at `0`, fully collapsed at `1`. Values are clamped to that range. |
| `transparencyProgress` | `0` | Normal material appearance at `0`, invisible at `1`; clamped to that range. This is whole-bar opacity, not glass tint. |
| `collapseScaleFactor` | `0.2` | Scale reduction at full collapse: the default yields 80% scale. Scaling is anchored at bottom center. |
| `collapseHeightFactor` | `12` | Horizontal surface height reduction at full collapse. Default Modern/Glass height becomes 62 before scaling. |
| `collapseBottomInsetFactor` | `4` | Reduces the requested bottom margin at full collapse, never below zero. A larger system safe-area inset may still determine the spacing. |

A fully transparent bar ignores pointer input. Collapse and transparency are
independent: you can shrink without fading or fade without shrinking. Use
sensible nonnegative sizes/factors. The collapse behavior is designed for
bottom bars; vertical rails retain fixed item-slot heights.

## FloatingNavBarVariant

| Value | Appearance and behavior |
| --- | --- |
| `modern` | Theme-based surface, soft shadows, selected background pill. Standalone default. |
| `glassmorphism` | Blurred backdrop, translucent tint, highlight border, theme-aware light/dark treatment. Adaptive scaffold default. |
| `compact` | Dense, icon-only layout with constrained dimensions. |

Compact deliberately overrides these settings:

- Height is clamped to 56–70 (default result: 70).
- Container radius is clamped to 16–24 (default result: 24).
- Item radius is clamped to 12–16 (default result: 16).
- Container padding becomes horizontal 5 / vertical 4.
- Item padding becomes horizontal 3 / vertical 6.
- Icon size is `iconSize - 2`, clamped to 16–22 (default result: 20).
- Labels remain hidden even if `showLabels` is `true`.

## FloatingNavBarScrollContainer

Place this full-size overlay wrapper in `Scaffold.body`. It listens to vertical
scroll notifications and supplies progress to your bar builder.

| Property | Default | What it does |
| --- | --- | --- |
| `child` | Required | Scrollable page content beneath the overlay. |
| `navBarBuilder` | Required | Builds your bar with the latest collapse and transparency progress. |
| `collapseDistance` | `140` | Accumulated downward scroll distance for full collapse. Must be greater than zero. Scrolling upward reduces progress. |
| `transparentAtScrollEnd` | `true` | Fades out at the maximum scroll extent; restores visibility when scrolling away from it. Use `false` to keep the bar visible. |

The listener ignores horizontal notifications and nested notifications with
`depth > 0`. Progress follows scroll deltas, not an absolute scroll offset, so
it can expand as soon as you reverse direction. End transparency updates on
scroll activity; merely displaying a short, non-scrollable list does not hide
the bar. For reverse lists, “end” means maximum scroll extent, not necessarily
the visual bottom. Programmatic changes are handled only when they produce
scroll-update notifications with a nonzero delta.

Keep the wrapper bounded (for example, in `Scaffold.body` or `Expanded`) and
leave bottom padding in the child so the overlay cannot block the final item.
The wrapper always positions its bar at the bottom. It does not automatically
combine scroll behavior with the adaptive scaffold's side navigation.

### FloatingNavBarBuilder

```dart
typedef FloatingNavBarBuilder = Widget Function(
  BuildContext context,
  double collapseProgress,
  double transparencyProgress,
);
```

Pass the two progress values to the matching `FloatingModernNavBar` properties.
The wrapper manages its listeners and progress notifiers internally; no scroll
controller is required for normal use.
