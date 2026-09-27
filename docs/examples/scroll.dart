import 'package:flutter/material.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';

void main() => runApp(const MaterialApp(home: ScrollDemo()));

class ScrollDemo extends StatefulWidget {
  const ScrollDemo({super.key});
  @override
  State<ScrollDemo> createState() => _ScrollDemoState();
}

class _ScrollDemoState extends State<ScrollDemo> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(['Library', 'Saved'][selectedIndex])),
    body: FloatingNavBarScrollContainer(
      collapseDistance: 140,
      transparentAtScrollEnd: true, // Use false to keep navigation visible.
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: 30,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(
              '${selectedIndex == 0 ? 'Library' : 'Saved'} item ${index + 1}',
            ),
            subtitle: const Text(
              'Scroll down, then back up to expand navigation.',
            ),
          ),
        ),
      ),
      navBarBuilder: (context, collapse, transparency) => FloatingModernNavBar(
        items: const [
          FloatingNavBarItem(
            icon: Icons.collections_bookmark_outlined,
            label: 'Library',
          ),
          FloatingNavBarItem(icon: Icons.bookmark_outline, label: 'Saved'),
        ],
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        variant: FloatingNavBarVariant.glassmorphism,
        collapseProgress: collapse,
        transparencyProgress: transparency,
      ),
    ),
  );
}
