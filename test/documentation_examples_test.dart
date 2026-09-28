import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';
import '../doc/examples/adaptive.dart' as adaptive;
import '../doc/examples/styled_bottom.dart' as styled;
import '../doc/examples/scroll.dart' as scrolling;

void main() {
  testWidgets('documentation apps render and handle navigation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final sample in <(Widget, String)>[
      (const adaptive.NavigationDemo(), 'Inbox'),
      (const styled.StyledBottomDemo(), 'Favorites'),
      (const scrolling.ScrollDemo(), 'Saved'),
    ]) {
      await tester.pumpWidget(MaterialApp(home: sample.$1));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(FloatingModernNavBar),
          matching: find.text(sample.$2),
        ),
      );
      await tester.pumpAndSettle();
      final bar = tester.widget<FloatingModernNavBar>(
        find.byType(FloatingModernNavBar),
      );
      expect(bar.items[bar.currentIndex].label, sample.$2);
      expect(tester.takeException(), isNull);
    }
  });
}
