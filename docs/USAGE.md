# Usage guide

[← Getting started](../README.md) · [Every property and default](API.md)

## 1. Choose how navigation is hosted

| Your goal | Use | Where it goes |
| --- | --- | --- |
| Automatic bottom/side navigation, including Duo | `FloatingAdaptiveNavScaffold` | Root of the page or route |
| A custom bottom bar with full styling control | `FloatingModernNavBar` | Your `Scaffold.bottomNavigationBar` |
| A bottom bar that shrinks or fades on scroll | `FloatingNavBarScrollContainer` | Your `Scaffold.body` |
| A manually composed side rail | `FloatingModernNavBar(axis: Axis.vertical)` | Beside your content in a bounded layout |

These are alternative ways to host navigation. Do not stack them together and
accidentally display two bars. The adaptive scaffold uses a standalone bar
internally, but does not currently expose all its styling properties.

## 2. Connect tabs to pages

All hosts follow the same state flow:

1. Create `FloatingNavBarItem` entries in page order.
2. Store a zero-based `selectedIndex` in your app's state.
3. Pass it as `currentIndex`.
4. In `onTap`, update the index and the displayed page.

The package reports selection; it does not perform routing. You can use
`setState`, your existing state manager, or your router's navigation method.
When routes can change elsewhere, derive `currentIndex` from that route state
so the selected tab stays in sync.

The [complete adaptive example](examples/adaptive.dart) uses `IndexedStack` to
keep tab pages mounted when switching. For pages that can be recreated, you
can instead use `body: pages[selectedIndex]`. Keep `items`, pages, and index in
sync when adding or removing tabs.

## 3. Enable automatic iPhone Duo placement

Use `FloatingAdaptiveNavScaffold` with `placement: FloatingNavBarPlacement.automatic`
(the default). The included iOS plugin reads the system's preferred bar edge
and bar layout region. This follows the current display and pose rather than
identifying the device from its screen width.

On a supported Duo configuration, navigation moves into the side region. When
iOS requests a horizontal bar, it returns to the bottom. Ordinary iPhones and
Android use bottom navigation automatically. The manual `.left` and `.right`
settings work without Duo hardware, and `.bottom` forces bottom placement.

For automatic native placement:

1. Use the updated package checkout or a release containing the adaptive API.
2. Build the app with Xcode's iOS 27.1 SDK or newer.
3. Run on an iOS 27.1+ device/simulator that supplies the vertical-bar trait.
4. Stop and rebuild the app after adding or changing the native plugin. Hot
   reload cannot install native code.

Older SDKs, older runtimes, and an unavailable native plugin fall back to the
bottom bar. `flutter doctor -v` shows the active Xcode installation. If several
Xcode versions are installed, you can select one for a single command:

```sh
# Change this path to your Xcode 27.1+ installation.
DEVELOPER_DIR=/Applications/Xcode-27.1.app/Contents/Developer flutter run
```

### Safe areas and page width

Use the adaptive scaffold as a full-page host. Place `SafeArea` **inside its
body** to protect page content. Avoid wrapping the entire adaptive scaffold
in `SafeArea` or adding another sidebar-width padding around it: the host
already positions the bar using the native region and consumes that side's
padding once. Native coordinates refer to the full Flutter host view, so an
inset or nested adaptive scaffold is not a substitute for a full-page host.

The rail uses physical left/right edges and does not flip with RTL text. Its
icons retain labels for accessibility and tooltips. Long rails can scroll in
short windows. Body state is preserved as placement changes.

This is a Flutter-rendered bar positioned with native layout information; it
does not install tabs into a `UITabBarController` or merge them with other
native toolbars. The corrected Duo placement has been confirmed by the project
maintainer in the simulator.

## 4. Choose a visual style

Set `variant` on either the adaptive host or the standalone bar:

| Preset | Choose it for |
| --- | --- |
| `FloatingNavBarVariant.modern` | A solid, theme-based floating surface. |
| `FloatingNavBarVariant.glassmorphism` | Translucent, Apple-inspired glass over visible content. |
| `FloatingNavBarVariant.compact` | An icon-only bar with a smaller horizontal height. |

The standalone default is Modern; the adaptive default is Glass. Compact
intentionally overrides labels, padding, and some size ranges. See the
[Compact rules](API.md#floatingnavbarvariant) before customizing those values.

### Make glass look like glass

Glass uses a clipped backdrop blur, a translucent gradient, a highlight border,
and shadows. The effect needs something behind the bar to blur. A flat page
background will naturally produce a subtler result than artwork or scrolling
content. The effect approximates Apple's visual style in Flutter; it does not
use native Liquid Glass refraction.

For your own bottom-bar Scaffold, set `extendBody: true`. The adaptive host
already does this. Keep important foreground controls clear of the bar with
`SafeArea` or appropriate content padding while allowing backgrounds to extend
beneath it.

Start with the preset defaults. On the standalone bar, you can then:

- Increase/decrease `backdropBlur` (default 24) to adjust blur strength.
- Set a translucent `backgroundColor` to change the base tint.
- Supply `backgroundGradient` to replace the generated tint and highlight.
- Set `borderColor` and `borderWidth` for the edge treatment.
- Supply `boxShadow` to replace the outer shadows.

An opaque custom gradient covers the blurred content. `transparencyProgress`
fades the entire bar, including icons; it is not the control for glass tint.
For a low-cost solid treatment, choose Modern or Compact instead of Glass.

[Run the styled bottom-bar example](examples/styled_bottom.dart) for a visible
glass backdrop, badge, custom colors, sizes, and selection animation.

## 5. Customize icons, labels, and badges

Use an outlined `icon` and filled `activeIcon` to make selection clearer. Icons
can come from Material, Cupertino, or another `IconData` font available to your
app. Keep each `label` short and descriptive.

```dart
const FloatingNavBarItem(
  icon: Icons.mail_outline,
  activeIcon: Icons.mail,
  label: 'Inbox',
  tooltip: 'Open your inbox',
  badgeCount: 12,
)
```

This snippet also needs `package:flutter/material.dart`. Rebuild with a new
`badgeCount` when data changes. Positive counts display a badge; more than 99
displays `99+`; zero or `null` removes it.

On the standalone bar:

- `selectedItemColor` changes the selected pill's background.
- `selectedLabelColor` changes both the selected icon and its text.
- The matching `unselected…` properties style inactive items.
- `indicatorColor` changes badge backgrounds.
- `showLabels: false` hides visual text but retains the accessible item label.
- `iconSize` and `selectedIconScale` control icon size and selection emphasis.
- Label styles let you change font size, family, and spacing. Their color and
  weight are resolved separately by the widget; see the reference.

## 6. Add scroll collapse

Use [the complete scroll example](examples/scroll.dart). Its important structure is:

```text
Scaffold
└── body: FloatingNavBarScrollContainer
    ├── child: ListView (with bottom content padding)
    └── navBarBuilder: FloatingModernNavBar
```

The wrapper overlays the bar on the content. Put it in `body`, not in
`bottomNavigationBar`: it needs the page's available height and scroll
notifications. Do not also add a second bar to the Scaffold.

Pass both progress values received by `navBarBuilder` directly into the bar.
Scroll downward to shrink it; scroll upward to expand it. `collapseDistance`
sets how much scrolling produces full collapse (default 140, must be positive).

`transparentAtScrollEnd: true` fades the bar out at the maximum scroll extent.
Set it to `false` when users should always have visible navigation. The wrapper
listens to its nearest vertical scrollable; nested and horizontal scrolling are
ignored. This wrapper supplies bottom navigation only, not adaptive side rails.

Leave enough bottom list padding for the last row to clear the bar; 120 pixels
is a starting point for the default bar, and custom sizes may need more.

### Drive progress yourself

You can connect your own animation/state source to the standalone bar:

```dart
FloatingModernNavBar(
  items: items,
  currentIndex: selectedIndex,
  onTap: onTabSelected,
  collapseProgress: progress,
  transparencyProgress: 0,
  collapseScaleFactor: 0.15,
  collapseHeightFactor: 8,
  collapseBottomInsetFactor: 4,
)
```

Here, `items`, `selectedIndex`, `onTabSelected`, and `progress` are values from
your app. `progress` runs from 0 (expanded) to 1 (collapsed); values outside
that range are clamped. Set `transparencyProgress` separately if you also want
a fade. A fully transparent bar stops receiving pointer input.

## 7. Compose your own side rail

For automatic Duo layout, use the adaptive scaffold. For an app-specific manual
layout with full styling control, put `FloatingModernNavBar(axis: Axis.vertical)`
beside your page. Hide labels with `showLabels: false` if space is tight.

The standalone rail has a 72-pixel surface width and 56-pixel destination slots,
plus padding and safe-area/margin space. Wrap it in a bounded scroll view if
there are more destinations than fit vertically. `height` controls the
horizontal bar, not vertical rail length. Your layout must reserve page space
and handle safe areas; changing `axis` alone does not integrate it with Duo's
system region. Never place a vertical rail in `bottomNavigationBar`.

## 8. Match your app's theme and accessibility settings

The bar derives default colors from `Theme.of(context).colorScheme` and label
styles from `textTheme.labelMedium`. Configure `MaterialApp.theme`, `darkTheme`,
and `themeMode` as usual; Glass changes its base tint with theme brightness.
Use colors with enough contrast over the backgrounds the bar will actually cover.

Items expose a label, selected state, and button semantics. Tooltips use the
item's `tooltip`, falling back to its `label`. Test your chosen labels and
sizes with text scaling and a screen reader: the current implementation can
scale content down to fit, and it does not offer a multiline label layout.

The bar respects `MediaQuery.disableAnimations` by making its animated
transitions immediate. There is no separate native Reduce Transparency bridge
in this package; if your app needs an opaque accessibility mode, select Modern
or supply an opaque surface in your own standalone bar.

## Troubleshooting

| What you see | What to check |
| --- | --- |
| Tapping a tab does not change the page | Update `currentIndex` **and** your body/router in `onTap`; the package does not route automatically. |
| A tab page resets when switching | Use stable page widgets with `IndexedStack`, or preserve state in your navigation architecture. |
| Duo still shows a bottom bar | Use the adaptive host in automatic mode, check the active 27.1+ SDK/runtime, and fully rebuild the native plugin. Some poses legitimately request a bottom bar. |
| Side navigation squeezes the content | Use the current fixed version; remove extra outer `SafeArea`/sidebar padding. Keep the adaptive host at page level. |
| Glass looks solid | Extend content behind it and remove opaque custom gradients. A flat background has little visible detail to blur. |
| Labels remain hidden | Compact always hides them; the adaptive host also hides labels on side rails. |
| `selectedItemColor` does not change icon color | Use `selectedLabelColor`, which controls the icon and label. |
| `indicatorColor` has no visible effect | It colors badges; add a positive `badgeCount` to see it. |
| The last list row is obscured | Add bottom content padding for the overlaid bar. |
| Scroll behavior is absent | Put the scroll wrapper in `Scaffold.body`, pass both progress values, and use a directly observed vertical scrollable. |
| The bar disappears at the bottom of a list | This is `transparentAtScrollEnd: true`; turn it off to retain visible navigation. |
| A styling parameter is rejected on the adaptive host | Check [its supported properties](API.md#floatingadaptivenavscaffold); advanced styling belongs to the standalone bar. |

## Run the examples

From the repository's `example/` directory:

```sh
flutter pub get
flutter run                               # Interactive gallery
flutter run -t ../docs/examples/adaptive.dart
flutter run -t ../docs/examples/styled_bottom.dart
flutter run -t ../docs/examples/scroll.dart
```

The three documentation entry points are complete apps. The smaller snippets
in this guide illustrate settings within your own app.
