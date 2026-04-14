import 'package:flutter/material.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';

void main() {
  runApp(const FloatingModernNavBarExampleApp());
}

class FloatingModernNavBarExampleApp extends StatelessWidget {
  const FloatingModernNavBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Floating Modern NavBar Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D5AFE)),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int _currentIndex = 0;
  FloatingNavBarVariant _variant = FloatingNavBarVariant.modern;

  static const _titles = ['Home', 'Discover', 'Orders', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex]), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _titles[_currentIndex],
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              'Minimal and modern floating nav for Flutter apps.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            SegmentedButton<FloatingNavBarVariant>(
              segments: const [
                ButtonSegment(
                  value: FloatingNavBarVariant.modern,
                  label: Text('Modern'),
                ),
                ButtonSegment(
                  value: FloatingNavBarVariant.glassmorphism,
                  label: Text('Glass'),
                ),
                ButtonSegment(
                  value: FloatingNavBarVariant.compact,
                  label: Text('Compact'),
                ),
              ],
              selected: {_variant},
              onSelectionChanged: (value) {
                setState(() {
                  _variant = value.first;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingModernNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
        variant: _variant,
        items: const [
          FloatingNavBarItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          FloatingNavBarItem(
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore_rounded,
            label: 'Discover',
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
      ),
    );
  }
}
