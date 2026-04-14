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

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? tooltip;
  final int? badgeCount;
}
