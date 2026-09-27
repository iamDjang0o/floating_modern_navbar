import 'package:flutter/widgets.dart';

@immutable
class FloatingNavBarItem {
  const FloatingNavBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.tooltip,
    this.badgeCount,
  });

  /// Default icon; also used for selection when [activeIcon] is absent.
  final IconData icon;
  /// Optional icon displayed for the selected destination.
  final IconData? activeIcon;
  /// Visible label and accessible name, including for icon-only items.
  final String label;
  /// Tooltip text. Defaults to [label] when omitted.
  final String? tooltip;
  /// Positive counts display a badge, capped visually at `99+`.
  /// Null, zero, and negative values hide the badge.
  final int? badgeCount;
}
