import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'floating_modern_nav_bar.dart';
import 'floating_nav_bar_item.dart';

/// Physical edges: native Duo placement must not flip in RTL locales.
enum FloatingNavBarPlacement { automatic, bottom, left, right }

/// Hosts the content and navigation together so side navigation reserves space.
/// On iOS, automatic placement follows the system vertical-bar trait; other
/// devices and older SDKs retain bottom navigation regardless of screen width.
class FloatingAdaptiveNavScaffold extends StatefulWidget {
  const FloatingAdaptiveNavScaffold({
    super.key,
    required this.body,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.variant = FloatingNavBarVariant.glassmorphism,
    this.placement = FloatingNavBarPlacement.automatic,
    this.backgroundColor,
  });
  /// Page content. Place SafeArea inside this body, not around the host.
  final Widget body;

  /// Destinations in the same order as your pages or routes.
  final List<FloatingNavBarItem> items;

  /// Selected zero-based index. Keep it within [items].
  final int currentIndex;

  /// Reports taps; the caller updates selection and page/router state.
  final ValueChanged<int> onTap;

  /// Bar appearance. Defaults to the glass preset.
  final FloatingNavBarVariant variant;

  /// Automatic native placement or a physical-edge override.
  final FloatingNavBarPlacement placement;

  /// Scaffold/page background, not the bar's surface tint.
  final Color? backgroundColor;

  @override
  State<FloatingAdaptiveNavScaffold> createState() => _AdaptiveState();
}

// One channel handler supports multiple scaffold instances without replacing
// each other's listeners. Each engine has its own native bridge.
class _NativeLayout {
  const _NativeLayout(this.edge, {this.viewport, this.bar});
  final FloatingNavBarPlacement edge;
  final Size? viewport;
  final Rect? bar;
}

class _NativeEdge extends ValueNotifier<_NativeLayout> {
  _NativeEdge() : super(const _NativeLayout(FloatingNavBarPlacement.bottom)) {
    channel.setMethodCallHandler((call) async {
      if (call.method == 'edgeChanged' || call.method == 'layoutChanged') {
        update(call.arguments);
      }
    });
  }
  static final instance = _NativeEdge();
  static const channel = MethodChannel('floating_modern_navbar/layout');
  void update(Object? data) {
    final map = data is Map ? data : null;
    final edge = switch (map?['edge'] ?? data) {
      'left' => FloatingNavBarPlacement.left,
      'right' => FloatingNavBarPlacement.right,
      _ => FloatingNavBarPlacement.bottom,
    };
    final frame = map?['bar'];
    final width = map?['width'];
    final height = map?['height'];
    Rect? bar;
    if (frame is Map && ['x', 'y', 'width', 'height'].every((k) => frame[k] is num)) {
      bar = Rect.fromLTWH((frame['x'] as num).toDouble(), (frame['y'] as num).toDouble(),
        (frame['width'] as num).toDouble(), (frame['height'] as num).toDouble());
      if (!bar.isFinite || bar.isEmpty) bar = null;
    }
    value = _NativeLayout(edge, bar: bar, viewport: width is num && height is num
      ? Size(width.toDouble(), height.toDouble()) : null);
  }

  Future<void> refresh() async {
    try {
      update(await channel.invokeMethod<Object?>('getLayout'));
    } on MissingPluginException {
      update(null);
    } on PlatformException {
      update(null);
    }
  }
}

class _AdaptiveState extends State<FloatingAdaptiveNavScaffold>
    with WidgetsBindingObserver {
  bool get _usesNative =>
      !kIsWeb && Theme.of(context).platform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_usesNative) _NativeEdge.instance.refresh();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _usesNative) _NativeEdge.instance.refresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _usesNative) {
      _NativeEdge.instance.refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _NativeEdge.instance,
    builder: (context, nativeLayout, _) {
      final automatic = widget.placement == FloatingNavBarPlacement.automatic;
      final edge = automatic
          ? (_usesNative ? nativeLayout.edge : FloatingNavBarPlacement.bottom)
          : widget.placement;
      final vertical = edge != FloatingNavBarPlacement.bottom;
      final bar = FloatingModernNavBar(
        items: widget.items,
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        variant: widget.variant,
        axis: vertical ? Axis.vertical : Axis.horizontal,
        showLabels: !vertical,
        margin: vertical ? EdgeInsets.zero : const EdgeInsets.all(12),
      );
      return Scaffold(
        backgroundColor: widget.backgroundColor,
        extendBody: true,
        bottomNavigationBar: vertical ? null : bar,
        body: LayoutBuilder(builder: (context, constraints) {
          final media = MediaQuery.of(context);
          final bounds = Offset.zero & constraints.biggest;
          final left = edge == FloatingNavBarPlacement.left;
          Rect? rail;
          if (vertical) {
            // UIKit's bar region already avoids the status area, camera and
            // rounded edges. It is in the Flutter host view's logical points.
            if (automatic && _usesNative && nativeLayout.bar != null &&
                nativeLayout.viewport != null &&
                (nativeLayout.viewport!.width - bounds.width).abs() < 1) {
              rail = nativeLayout.bar!.intersect(bounds);
              if (rail.isEmpty) rail = null;
            }
            rail ??= Rect.fromLTWH(
              left ? 12 : math.max(0, bounds.width - 84),
              math.max(12, media.padding.top),
              math.min(72, bounds.width),
              math.max(0, bounds.height - math.max(12, media.padding.top) -
                math.max(12, media.padding.bottom)),
            );
          }
          final inset = rail == null ? 0.0 : left
              ? math.max(media.padding.left, rail.right + 12)
              : math.max(media.padding.right, bounds.width - rail.left + 12);
          return Stack(fit: StackFit.expand, children: [
            Padding(
              key: const ValueKey('content'),
              padding: EdgeInsets.only(left: vertical && left ? inset : 0,
                right: vertical && !left ? inset : 0),
              // The rail has consumed this edge once. A page's SafeArea must
              // not subtract Duo's large side inset a second time.
              child: MediaQuery.removePadding(context: context,
                removeLeft: vertical && left, removeRight: vertical && !left,
                child: widget.body),
            ),
            if (rail != null)
              Positioned.fromRect(rect: rail,
                child: MediaQuery.removePadding(context: context,
                  removeLeft: true, removeRight: true, removeTop: true, removeBottom: true,
                  child: Center(child: SingleChildScrollView(child: bar))),
              ),
          ]);
        }),
      );
    },
  );
}
