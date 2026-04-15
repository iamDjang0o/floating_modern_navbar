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
  bool _transparentAtScrollEnd = true;
  double _collapseDistance = 140;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('test'), centerTitle: true),
      bottomNavigationBar: FloatingNavBarScrollContainer(
        collapseDistance: _collapseDistance,
        transparentAtScrollEnd: _transparentAtScrollEnd,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 200, 16, 140),
            children: [
              const SizedBox(height: 16),
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
              const SizedBox(height: 10),
              SwitchListTile(
                value: _transparentAtScrollEnd,
                contentPadding: EdgeInsets.zero,
                title: const Text('Transparent at scroll end'),
                onChanged: (value) {
                  setState(() {
                    _transparentAtScrollEnd = value;
                  });
                },
              ),
              const SizedBox(height: 2),
              Text(
                'Collapse distance: ${_collapseDistance.toStringAsFixed(0)} px',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Slider(
                value: _collapseDistance,
                min: 80,
                max: 260,
                divisions: 9,
                label: _collapseDistance.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _collapseDistance = value;
                  });
                },
              ),
              const SizedBox(height: 6),
              ...List.generate(20, (index) {
                final accent = const Color.fromARGB(255, 133, 133, 133);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: accent.withValues(alpha: 0.22)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: accent.withValues(alpha: 0.15),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(
                      'test ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'test demo item with mock content for scroll and collapse preview.',
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: accent.withValues(alpha: 0.9),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        navBarBuilder: (context, collapseProgress, transparencyProgress) =>
            FloatingModernNavBar(
              collapseProgress: collapseProgress,
              transparencyProgress: transparencyProgress,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              height: 78,
              margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 10,
              ),
              borderRadius: 30,
              itemBorderRadius: 20,
              backgroundGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white.withValues(alpha: 0.5)],
              ),
              borderColor: Colors.black.withValues(alpha: 0.15),
              selectedItemColor: Colors.black.withValues(alpha: 0.12),
              selectedLabelColor: Colors.black,
              unselectedLabelColor: Colors.black.withValues(alpha: 0.72),
              indicatorColor: Colors.black,
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
      ),
    );
  }
}
