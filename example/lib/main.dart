import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:floating_modern_navbar/floating_modern_navbar.dart';

void main() => runApp(const FloatingModernNavBarExampleApp());

class FloatingModernNavBarExampleApp extends StatefulWidget {
  const FloatingModernNavBarExampleApp({super.key});
  @override
  State<FloatingModernNavBarExampleApp> createState() => _AppState();
}

class _AppState extends State<FloatingModernNavBarExampleApp> {
  bool dark = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Floating / Material study',
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF007AFF),
        surface: const Color(0xFFF3F5F8),
      ),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF409CFF),
        brightness: Brightness.dark,
        surface: const Color(0xFF16191F),
      ),
      useMaterial3: true,
    ),
    home: ExampleHomePage(onToggleTheme: () => setState(() => dark = !dark)),
  );
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;
  @override
  State<ExampleHomePage> createState() => _HomeState();
}

class _HomeState extends State<ExampleHomePage> {
  int index = 0;
  FloatingNavBarVariant variant = FloatingNavBarVariant.glassmorphism;
  FloatingNavBarPlacement placement = FloatingNavBarPlacement.automatic;
  static const items = [
    FloatingNavBarItem(icon: CupertinoIcons.square_grid_2x2, label: 'Library'),
    FloatingNavBarItem(icon: CupertinoIcons.compass, label: 'Explore'),
    FloatingNavBarItem(
      icon: CupertinoIcons.heart,
      label: 'Favorites',
      badgeCount: 3,
    ),
    FloatingNavBarItem(icon: CupertinoIcons.person, label: 'Profile'),
  ];
  @override
  Widget build(BuildContext context) => FloatingAdaptiveNavScaffold(
    items: items,
    currentIndex: index,
    onTap: (i) => setState(() => index = i),
    variant: variant,
    placement: placement,
    body: SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 130),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Floating',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.4,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onToggleTheme,
                tooltip: 'Toggle appearance',
                icon: const Icon(CupertinoIcons.moon),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'A lighter way to move.',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          SegmentedButton<FloatingNavBarVariant>(
            showSelectedIcon: false,
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
            selected: {variant},
            onSelectionChanged: (v) => setState(() => variant = v.first),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<FloatingNavBarPlacement>(
            isExpanded: true,
            initialValue: placement,
            decoration: const InputDecoration(
              labelText: 'Navigation placement',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: FloatingNavBarPlacement.automatic,
                child: Text('Automatic'),
              ),
              DropdownMenuItem(
                value: FloatingNavBarPlacement.bottom,
                child: Text('Bottom preview'),
              ),
              DropdownMenuItem(
                value: FloatingNavBarPlacement.left,
                child: Text('Left side preview'),
              ),
              DropdownMenuItem(
                value: FloatingNavBarPlacement.right,
                child: Text('Right side preview'),
              ),
            ],
            onChanged: (v) => setState(() => placement = v!),
          ),
          const SizedBox(height: 28),
          Text(
            items[index].label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 16),
          for (final scene in const [
            (
              'Coastal light',
              'A little room to breathe',
              Color(0xFF547D9D),
              Color(0xFFC4E7E6),
            ),
            (
              'Golden hour',
              'Keep the softer moments',
              Color(0xFFC57553),
              Color(0xFFF1D5AB),
            ),
            (
              'Still water',
              'Find your own pace',
              Color(0xFF416D68),
              Color(0xFFAAD2BD),
            ),
            (
              'After dusk',
              'A different perspective',
              Color(0xFF555F8D),
              Color(0xFFBCC8E2),
            ),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 240,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(painter: _Landscape(scene.$3, scene.$4)),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.45),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 22,
                        bottom: 22,
                        right: 22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scene.$1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              scene.$2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _Landscape extends CustomPainter {
  const _Landscape(this.base, this.sky);
  final Color base;
  final Color sky;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [sky, base],
        ).createShader(Offset.zero & size),
    );
    canvas.drawCircle(
      Offset(size.width * .76, size.height * .27),
      32,
      Paint()..color = Colors.white.withValues(alpha: .55),
    );
    for (var i = 0; i < 3; i++) {
      final y = size.height * (.48 + i * .16);
      final path = Path()
        ..moveTo(0, y)
        ..cubicTo(
          size.width * .3,
          y - 65,
          size.width * .6,
          y + 80,
          size.width,
          y - 25,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        path,
        Paint()
          ..color = Color.lerp(
            base,
            Colors.black,
            i * .13,
          )!.withValues(alpha: .45 + i * .2),
      );
    }
  }

  @override
  bool shouldRepaint(_Landscape old) => base != old.base || sky != old.sky;
}
