import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floating_modern_navbar_example/main.dart';

void main() {
  testWidgets('gallery renders and appearance can change', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const FloatingModernNavBarExampleApp());
    expect(find.text('Floating'), findsOneWidget);
    expect(find.text('Coastal light'), findsOneWidget);
    await tester.tap(find.byTooltip('Toggle appearance'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Floating'))).brightness,
      Brightness.dark,
    );
    await tester.tap(find.text('Automatic').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Right side preview').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
