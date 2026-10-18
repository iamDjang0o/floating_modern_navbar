import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';

void main() {
  const items = [
    FloatingNavBarItem(icon: Icons.home, label: 'Home'),
    FloatingNavBarItem(icon: Icons.search, label: 'Search'),
  ];
  for (final placement in [
    FloatingNavBarPlacement.bottom,
    FloatingNavBarPlacement.left,
    FloatingNavBarPlacement.right,
  ]) {
    testWidgets('scroll collapse respects $placement', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FloatingAdaptiveNavScaffold(
            placement: placement,
            collapseOnScroll: true,
            collapseDistance: 100,
            items: items,
            currentIndex: 0,
            onTap: (_) {},
            body: ListView.builder(
              itemExtent: 60,
              itemCount: 100,
              itemBuilder: (_, i) => Text('Row $i'),
            ),
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      final bar = tester.widget<FloatingModernNavBar>(
        find.byType(FloatingModernNavBar),
      );
      expect(
        bar.collapseProgress,
        placement == FloatingNavBarPlacement.bottom ? 1 : 0,
      );
      expect(bar.transparencyProgress, 0);
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FloatingModernNavBar>(find.byType(FloatingModernNavBar))
            .collapseProgress,
        0,
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'automatic transition clears collapse and opt-out keeps bottom expanded',
    (tester) async {
      const channel = MethodChannel('floating_modern_navbar/layout');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (_) async => 'bottom',
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      Widget host(bool enabled) => MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: FloatingAdaptiveNavScaffold(
          collapseOnScroll: enabled,
          items: items,
          currentIndex: 0,
          onTap: (_) {},
          body: ListView.builder(
            itemExtent: 60,
            itemCount: 100,
            itemBuilder: (_, i) => Text('Row $i'),
          ),
        ),
      );
      FloatingModernNavBar bar() => tester.widget<FloatingModernNavBar>(
        find.byType(FloatingModernNavBar),
      );
      Future<void> edge(String value) async {
        await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
          channel.name,
          channel.codec.encodeMethodCall(MethodCall('edgeChanged', value)),
          (_) {},
        );
        await tester.pumpAndSettle();
      }

      await tester.pumpWidget(host(true));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(bar().collapseProgress, 1);
      await edge('right');
      expect(bar().axis, Axis.vertical);
      expect(bar().collapseProgress, 0);
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(bar().collapseProgress, 0);
      await edge('bottom');
      expect(bar().axis, Axis.horizontal);
      expect(bar().collapseProgress, 0);
      await tester.pumpWidget(host(false));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(bar().collapseProgress, 0);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('native edge switches layout and preserves taps', (tester) async {
    const channel = MethodChannel('floating_modern_navbar/layout');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => 'right');
    var selected = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: FloatingAdaptiveNavScaffold(
          items: items,
          currentIndex: 0,
          onTap: (i) => selected = i,
          body: const Center(child: SizedBox(width: 200, child: TextField())),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final home = tester.getCenter(find.byIcon(Icons.home));
    final search = tester.getCenter(find.byIcon(Icons.search));
    expect(home.dx, search.dx);
    expect(home.dy, lessThan(search.dy));
    await tester.tap(find.byIcon(Icons.search));
    expect(selected, 1);
    await tester.enterText(find.byType(TextField), 'Keep this draft');
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(const MethodCall('edgeChanged', 'bottom')),
      (_) {},
    );
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(find.byIcon(Icons.home)).dy,
      tester.getCenter(find.byIcon(Icons.search)).dy,
    );
    expect(find.text('Keep this draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
  testWidgets('ordinary wide devices retain bottom navigation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FloatingAdaptiveNavScaffold(
          items: items,
          currentIndex: 0,
          onTap: (_) {},
          body: const SizedBox.expand(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(find.byIcon(Icons.home)).dy,
      tester.getCenter(find.byIcon(Icons.search)).dy,
    );
  });
  testWidgets('short RTL side layout scrolls without covering body', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 220);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: FloatingAdaptiveNavScaffold(
            placement: FloatingNavBarPlacement.right,
            items: List.generate(
              7,
              (i) => FloatingNavBarItem(icon: Icons.home, label: 'Tab $i'),
            ),
            currentIndex: 0,
            onTap: (_) {},
            body: const SizedBox.expand(key: ValueKey('page')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final page = tester.getRect(find.byKey(const ValueKey('page')));
    expect(
      page.right,
      lessThan(tester.getCenter(find.byIcon(Icons.home).first).dx),
    );
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('iOS missing plugin falls back to bottom', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: FloatingAdaptiveNavScaffold(
          items: items,
          currentIndex: 0,
          onTap: (_) {},
          body: const SizedBox.expand(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(find.byIcon(Icons.home)).dy,
      tester.getCenter(find.byIcon(Icons.search)).dy,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('Duo rail uses system region without double safe-area padding', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(466, 678);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = FakeViewPadding(
      left: 24,
      right: 96,
      top: 24,
      bottom: 24,
    );
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    const channel = MethodChannel('floating_modern_navbar/layout');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (call) async => call.method == 'getLayout'
              ? {
                  'edge': 'right',
                  'width': 466.0,
                  'height': 678.0,
                  'bar': {
                    'x': 382.0,
                    'y': 130.0,
                    'width': 72.0,
                    'height': 524.0,
                  },
                }
              : 'right',
        );
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: FloatingAdaptiveNavScaffold(
          items: items,
          currentIndex: 0,
          onTap: (_) {},
          body: const SafeArea(
            child: SizedBox.expand(key: ValueKey('usable-content')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final content = tester.getRect(
      find.byKey(const ValueKey('usable-content')),
    );
    expect(content.left, 24);
    expect(content.right, 370);
    expect(tester.getCenter(find.byIcon(Icons.home)).dx, 418);
    expect(tester.takeException(), isNull);
  });
}
