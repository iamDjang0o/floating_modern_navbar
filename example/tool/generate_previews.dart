// Run from example/: flutter test tool/generate_previews.dart
// Requires ffmpeg and a real font; override PREVIEW_FONT on non-macOS hosts.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';
import 'package:floating_modern_navbar_example/main.dart';

void main() {
  testWidgets('regenerate all project previews', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final output = Directory('../assets/previews');
    final frames = Directory.systemTemp.createTempSync('navbar-previews-');
    addTearDown(() => frames.deleteSync(recursive: true));
    await tester.runAsync(() async {
      final fontPath =
          Platform.environment['PREVIEW_FONT'] ??
          '/System/Library/Fonts/SFNS.ttf';
      final font = FontLoader('Roboto')
        ..addFont(
          Future.value(
            ByteData.sublistView(await File(fontPath).readAsBytes()),
          ),
        );
      await font.load();
      final manifest =
          jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
      for (final entry in manifest) {
        final loader = FontLoader(entry['family'] as String);
        for (final asset in entry['fonts'] as List) {
          loader.addFont(rootBundle.load(asset['asset'] as String));
        }
        await loader.load();
      }
    });
    final boundaryKey = GlobalKey();
    Future<void> capture(String path) async {
      expect(tester.takeException(), isNull);
      final boundary =
          boundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(path).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    await tester.pumpWidget(
      RepaintBoundary(
        key: boundaryKey,
        child: const FloatingModernNavBarExampleApp(),
      ),
    );
    await tester.pumpAndSettle();
    for (final name in ['Modern', 'Glass', 'Compact']) {
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      await capture('${output.path}/${name.toLowerCase()}.png');
    }
    await tester.tap(find.text('Glass'));
    await tester.pumpAndSettle();
    await capture('${output.path}/glass-light.png');
    await tester.tap(find.byTooltip('Toggle appearance'));
    await tester.pumpAndSettle();
    await capture('${output.path}/glass-dark.png');
    await tester.tap(find.byTooltip('Toggle appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Automatic').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Right side preview').last);
    await tester.pumpAndSettle();
    // Remove the selector's transient focus outline from the screenshot.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await capture('${output.path}/glass-side.png');

    // Reuse the real example gallery as content for the scroll-wrapper demos.
    // The shipped adaptive scaffold has no scroll-collapse behavior itself.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const FloatingModernNavBarExampleApp());
    await tester.pumpAndSettle();
    final scaffold = tester.widget<FloatingAdaptiveNavScaffold>(
      find.byType(FloatingAdaptiveNavScaffold),
    );
    final theme = Theme.of(tester.element(find.text('Floating')));
    for (final transparent in [false, true]) {
      final name = transparent ? 'transparent' : 'regular';
      final folder = Directory('${frames.path}/$name')..createSync();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: FloatingNavBarScrollContainer(
                transparentAtScrollEnd: transparent,
                child: scaffold.body,
                navBarBuilder: (context, collapse, transparency) =>
                    FloatingModernNavBar(
                      items: scaffold.items,
                      currentIndex: 0,
                      onTap: (_) {},
                      variant: FloatingNavBarVariant.glassmorphism,
                      margin: const EdgeInsets.all(12),
                      collapseProgress: collapse,
                      transparencyProgress: transparency,
                    ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      var frame = 0;
      Future<void> record() =>
          capture('${folder.path}/${(frame++).toString().padLeft(4, '0')}.png');
      Future<void> hold(int count) async {
        for (var i = 0; i < count; i++) {
          await tester.pump(const Duration(milliseconds: 80));
          await record();
        }
      }

      await hold(10);
      final scroll = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position;
      final extent = scroll.maxScrollExtent;
      final gesture = await tester.startGesture(const Offset(210, 710));
      for (var i = 0; i < 32; i++) {
        await gesture.moveBy(Offset(0, -(extent + 40) / 32));
        await tester.pump(const Duration(milliseconds: 80));
        await record();
      }
      await gesture.up();
      await hold(15);
      expect(scroll.pixels, closeTo(extent, 1));
      final bar = tester.widget<FloatingModernNavBar>(
        find.byType(FloatingModernNavBar),
      );
      expect(bar.collapseProgress, 1);
      expect(bar.transparencyProgress, transparent ? 1 : 0);
      final reverse = await tester.startGesture(const Offset(210, 220));
      for (var i = 0; i < 32; i++) {
        await reverse.moveBy(Offset(0, (extent + 40) / 32));
        await tester.pump(const Duration(milliseconds: 80));
        await record();
      }
      await reverse.up();
      await tester.pumpAndSettle();
      await hold(10);
      await tester.runAsync(() async {
        final result = await Process.run('ffmpeg', [
          '-hide_banner',
          '-loglevel',
          'error',
          '-y',
          '-framerate',
          '12.5',
          '-i',
          '${folder.path}/%04d.png',
          '-filter_complex',
          '[0:v]split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=sierra2_4a',
          '-loop',
          '0',
          '${output.path}/$name.gif',
        ]);
        expect(result.exitCode, 0, reason: '${result.stderr}');
      });
    }
  }, timeout: const Timeout(Duration(minutes: 5)));
}
