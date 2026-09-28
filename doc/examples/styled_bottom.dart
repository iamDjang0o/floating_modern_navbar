import 'package:flutter/material.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
    home: const StyledBottomDemo(),
  ),
);

class StyledBottomDemo extends StatefulWidget {
  const StyledBottomDemo({super.key});
  @override
  State<StyledBottomDemo> createState() => _StyledBottomDemoState();
}

class _StyledBottomDemoState extends State<StyledBottomDemo> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true, // Let the background show through the glass.
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFBDE5E7), Color(0xFF8BAFC9), Color(0xFFF0D3B1)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Text(
            ['Home', 'Favorites', 'Profile'][selectedIndex],
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
    ),
    bottomNavigationBar: FloatingModernNavBar(
      items: const [
        FloatingNavBarItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
        ),
        FloatingNavBarItem(
          icon: Icons.favorite_border,
          activeIcon: Icons.favorite,
          label: 'Favorites',
          badgeCount: 7,
        ),
        FloatingNavBarItem(icon: Icons.person_outline, label: 'Profile'),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => setState(() => selectedIndex = index),
      variant: FloatingNavBarVariant.glassmorphism,
      height: 78,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      borderRadius: 38,
      itemBorderRadius: 28,
      backdropBlur: 24,
      selectedItemColor: Colors.blue.withValues(alpha: 0.14),
      selectedLabelColor: const Color(0xFF174A7E),
      indicatorColor: const Color(0xFFAD3652), // Badge background.
      iconSize: 24,
      selectedIconScale: 1.06,
      animationDuration: const Duration(milliseconds: 220),
    ),
  );
}
