import 'package:flutter/material.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';

void main() => runApp(const MaterialApp(home: NavigationDemo()));

class NavigationDemo extends StatefulWidget {
  const NavigationDemo({super.key});

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  int selectedIndex = 0;

  static const items = [
    FloatingNavBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    FloatingNavBarItem(icon: Icons.search, label: 'Search'),
    FloatingNavBarItem(
      icon: Icons.inbox_outlined,
      activeIcon: Icons.inbox,
      label: 'Inbox',
      tooltip: 'Open your inbox',
      badgeCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FloatingAdaptiveNavScaffold(
      items: items,
      currentIndex: selectedIndex,
      onTap: (index) => setState(() => selectedIndex = index),
      variant: FloatingNavBarVariant.glassmorphism,
      placement: FloatingNavBarPlacement.automatic,
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: const [
            Center(child: Text('Home')),
            Center(child: Text('Search')),
            Center(child: Text('Inbox')),
          ],
        ),
      ),
    );
  }
}
