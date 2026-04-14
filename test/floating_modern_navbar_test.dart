import 'package:floating_modern_navbar/floating_modern_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders items and updates selection', (tester) async {
    var selectedIndex = 0;
    final items = const [
      FloatingNavBarItem(icon: Icons.home_outlined, label: 'Home'),
      FloatingNavBarItem(icon: Icons.search_rounded, label: 'Search'),
      FloatingNavBarItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: FloatingModernNavBar(
            items: items,
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
            },
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
  });
}
