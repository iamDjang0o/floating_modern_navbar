# floating_modern_navbar

A minimal, modern, and highly customizable floating bottom navigation bar for
Flutter.

`floating_modern_navbar` is designed for teams that want polished visual
defaults while keeping full control over layout, color, behavior, and animation
without adding heavy UI dependencies.

## Installation

```yaml
dependencies:
  floating_modern_navbar: ^0.1.0
```

## Core Components

### `FloatingModernNavBar`

The main navigation widget. It renders the floating container, item states,
selection animation, labels, badges, and style variants.

### `FloatingNavBarItem`

The model used for each tab item.

- `icon`: default icon
- `activeIcon`: optional selected-state icon
- `label`: item label text
- `tooltip`: optional semantic tooltip
- `badgeCount`: optional badge value

### `FloatingNavBarScrollContainer`

A scroll-aware wrapper that includes:

- internal `NotificationListener<ScrollNotification>`
- internal progress tracking via `ValueNotifier`
- automatic `collapseProgress` and `transparencyProgress` updates
- optional end-of-scroll transparency behavior

Use this when you want the floating bar behavior fully managed by the package.

### `FloatingNavBarVariant`

Prebuilt visual styles:

- `FloatingNavBarVariant.modern`: balanced default style for general products
- `FloatingNavBarVariant.glassmorphism`: frosted/translucent look with blur
- `FloatingNavBarVariant.compact`: reduced vertical footprint and dense layout

## Feature Overview

- **Layout Control:** `height`, `margin`, `padding`, `itemPadding`,
  `borderRadius`, `itemBorderRadius`
- **Visual Styling:** `backgroundColor` / `backgroundGradient`, `borderColor`,
  `borderWidth`, `shadowColor`, `boxShadow`, `elevation`
- **State Colors:** `selectedItemColor`, `unselectedItemColor`,
  `selectedLabelColor`, `unselectedLabelColor`, `indicatorColor`
- **Typography & Icons:** `iconSize`, `selectedIconScale`, `showLabels`,
  `selectedLabelStyle`, `unselectedLabelStyle`
- **Interaction:** `splashColor`, `highlightColor`, `enableFeedback`
- **Motion:** `animationDuration`, `animationCurve`,
  `collapseProgress`, `transparencyProgress`
- **Scroll Integration:** `FloatingNavBarScrollContainer` with
  `collapseDistance` and `transparentAtScrollEnd`

## Basic Usage

```dart
import 'package:floating_modern_navbar/floating_modern_navbar.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SizedBox.expand(),
      bottomNavigationBar: FloatingModernNavBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        items: const [
          FloatingNavBarItem(icon: Icons.home_rounded, label: 'Home'),
          FloatingNavBarItem(icon: Icons.search_rounded, label: 'Search'),
          FloatingNavBarItem(icon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }
}
```

## Advanced Customization

```dart
FloatingModernNavBar(
  currentIndex: currentIndex,
  onTap: onTap,
  variant: FloatingNavBarVariant.glassmorphism,
  height: 78,
  margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  itemPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
  borderRadius: 30,
  itemBorderRadius: 20,
  backgroundGradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10131A), Color(0xFF1A2030)],
  ),
  borderColor: Colors.white.withValues(alpha: 0.15),
  selectedItemColor: Colors.white.withValues(alpha: 0.12),
  selectedLabelColor: Colors.white,
  unselectedLabelColor: Colors.white.withValues(alpha: 0.72),
  indicatorColor: const Color(0xFF56CCF2),
  iconSize: 23,
  selectedIconScale: 1.1,
  items: const [
    FloatingNavBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    FloatingNavBarItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      label: 'Orders',
      badgeCount: 3,
    ),
    FloatingNavBarItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ],
)
```

## Scroll-managed Usage

Use this mode when you want the package to manage scroll tracking, collapse, and
transparency behavior.

```dart
FloatingNavBarScrollContainer(
  collapseDistance: 140,
  transparentAtScrollEnd: true,
  child: yourScrollableBody,
  navBarBuilder: (context, collapseProgress, transparencyProgress) {
    return FloatingModernNavBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      collapseProgress: collapseProgress,
      transparencyProgress: transparencyProgress,
    );
  },
)
```

Set `transparentAtScrollEnd: false` to keep the bar visible at the bottom of
the scroll.

## Example App

A complete runnable sample is included in `example/`.

```bash
cd example
flutter pub get
flutter run
```
