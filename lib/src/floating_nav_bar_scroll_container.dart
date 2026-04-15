import 'package:flutter/material.dart';

typedef FloatingNavBarBuilder =
    Widget Function(
      BuildContext context,
      double collapseProgress,
      double transparencyProgress,
    );

class FloatingNavBarScrollContainer extends StatefulWidget {
  const FloatingNavBarScrollContainer({
    super.key,
    required this.child,
    required this.navBarBuilder,
    this.collapseDistance = 140,
    this.transparentAtScrollEnd = true,
  });

  /// The widget below the navigation bar, typically a scrollable content widget.
  final Widget child;

  /// A builder function that returns the navigation bar widget.
  /// 
  /// Receives the current [BuildContext], the collapse progress, and
  /// the transparency progress, which can be used to animate appearance.
  final FloatingNavBarBuilder navBarBuilder;

  /// The scroll distance, in logical pixels, after which the navigation bar
  /// will be fully collapsed.
  ///
  /// Values above 0 specify how far the user must scroll for collapse
  /// (e.g. 140.0 for a medium-range collapse).
  final double collapseDistance;

  /// Whether the navigation bar should become fully transparent at the maximum
  /// scroll extent (i.e., when the user has scrolled to the end).
  ///
  /// If true, the navigation bar fades out as the user scrolls to the end;
  /// if false, the bar remains visible but may still collapse.
  final bool transparentAtScrollEnd;

  @override
  State<FloatingNavBarScrollContainer> createState() =>
      _FloatingNavBarScrollContainerState();
}

class _FloatingNavBarScrollContainerState
    extends State<FloatingNavBarScrollContainer> {
  final ValueNotifier<double> _collapseProgress = ValueNotifier<double>(0);
  final ValueNotifier<double> _transparencyProgress = ValueNotifier<double>(0);

  @override
  void dispose() {
    _collapseProgress.dispose();
    _transparencyProgress.dispose();
    super.dispose();
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification.depth > 0) {
      return false;
    }
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    final currentProgress = _collapseProgress.value;
    final scrollDelta = notification is ScrollUpdateNotification
        ? notification.scrollDelta
        : 0;
    final overscrollDelta = notification is OverscrollNotification
        ? notification.overscroll
        : 0;
    final totalDelta = (scrollDelta ?? 0) + overscrollDelta;
    if (totalDelta == 0) {
      return false;
    }

    final nextProgress =
        (currentProgress + (totalDelta / widget.collapseDistance)).clamp(
          0.0,
          1.0,
        );
    if ((nextProgress - currentProgress).abs() > 0.001) {
      _collapseProgress.value = nextProgress;
    }

    final shouldHideAtEnd = widget.transparentAtScrollEnd;
    if (!shouldHideAtEnd) {
      return false;
    }

    final isAtScrollEnd =
        notification.metrics.pixels >=
        (notification.metrics.maxScrollExtent - 1);
    final targetTransparency = isAtScrollEnd ? 1.0 : 0.0;
    if ((_transparencyProgress.value - targetTransparency).abs() > 0.001) {
      _transparencyProgress.value = targetTransparency;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _collapseProgress,
              builder: (context, collapseProgress, child) {
                return ValueListenableBuilder<double>(
                  valueListenable: _transparencyProgress,
                  builder: (context, transparencyProgress, child) {
                    return widget.navBarBuilder(
                      context,
                      collapseProgress,
                      transparencyProgress,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
