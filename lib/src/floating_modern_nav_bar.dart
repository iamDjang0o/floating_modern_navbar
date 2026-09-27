import 'dart:ui';

import 'package:flutter/material.dart';

import 'floating_nav_bar_item.dart';

enum FloatingNavBarVariant { modern, glassmorphism, compact }

class FloatingModernNavBar extends StatelessWidget {
  const FloatingModernNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 74,
    this.axis = Axis.horizontal,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    this.borderRadius = 36,
    this.itemBorderRadius = 28,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1,
    this.elevation = 0,
    this.shadowColor,
    this.boxShadow,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.iconSize = 22,
    this.selectedIconScale = 1.08,
    this.showLabels = true,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.itemMainAxisAlignment = MainAxisAlignment.center,
    this.enableFeedback = true,
    this.splashColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 240),
    this.animationCurve = Curves.easeOutCubic,
    this.variant = FloatingNavBarVariant.modern,
    this.backdropBlur = 24,
    this.collapseProgress = 0,
    this.transparencyProgress = 0,
    this.collapseScaleFactor = 0.2,
    this.collapseHeightFactor = 12,
    this.collapseBottomInsetFactor = 4,
    this.containerAnimationDuration = const Duration(milliseconds: 220),
    this.containerAnimationCurve = Curves.easeOutCubic,
  });

  /// The list of navigation bar items to display.
  ///
  /// Each item represents a tab or navigational destination within the bar.
  final List<FloatingNavBarItem> items;

  /// The zero-based index of the currently selected item.
  ///
  /// Determines which navigation item is visually highlighted and considered active.
  final int currentIndex;

  /// Callback that is triggered when a navigation item is tapped.
  ///
  /// Receives the index of the tapped navigation item.
  final ValueChanged<int> onTap;

  /// The horizontal surface height, excluding margin and safe-area spacing.
  /// Vertical rails use fixed 56-pixel item slots instead.
  final double height;

  /// Vertical rails should be hosted beside content, not in bottomNavigationBar.
  final Axis axis;

  /// The outer margin surrounding the navigation bar.
  ///
  /// This defines spacing between the navigation bar and other content.
  final EdgeInsets margin;

  /// The internal padding applied to the navigation bar container.
  ///
  /// This defines the space between the container edge and the items inside.
  final EdgeInsets padding;

  /// Padding applied to each individual navigation item.
  ///
  /// This defines the space inside each item for icons and labels.
  final EdgeInsets itemPadding;

  /// The border radius of the navigation bar container.
  ///
  /// Controls the roundness of the navigation bar's corners.
  final double borderRadius;

  /// The border radius applied to each navigation item.
  ///
  /// Controls the roundness of each item's background.
  final double itemBorderRadius;

  /// The solid background color of the navigation bar.
  ///
  /// If null, the default color from the current theme will be used.
  final Color? backgroundColor;

  /// Optional background gradient of the navigation bar.
  ///
  /// If provided, this gradient fills the background instead of `backgroundColor`.
  final Gradient? backgroundGradient;

  /// The color of the border surrounding the navigation bar.
  ///
  /// If null, uses the preset border (a glass highlight or themed outline).
  /// Use Colors.transparent to hide the border.
  final Color? borderColor;

  /// The width of the border surrounding the navigation bar.
  final double borderWidth;

  /// The elevation, in logical pixels, of the navigation bar's Material surface.
  ///
  /// Sets the z-coordinate at which to place this bar relative to its parent.
  final double elevation;

  /// The color of the shadow rendered by the navigation bar's elevation.
  ///
  /// Used when elevation is greater than 0.
  final Color? shadowColor;

  /// A list of custom box shadows to apply to the navigation bar container.
  final List<BoxShadow>? boxShadow;

  /// The background color used for the currently selected navigation item.
  final Color? selectedItemColor;

  /// The background color used for unselected navigation items.
  final Color? unselectedItemColor;

  /// The icon and label color of the selected navigation item.
  final Color? selectedLabelColor;

  /// The icon and label color of unselected navigation items.
  final Color? unselectedLabelColor;

  /// Badge background color; defaults to the theme primary color.
  /// This does not draw a separate selection indicator.
  final Color? indicatorColor;

  /// The base icon size, in logical pixels, for navigation items.
  final double iconSize;

  /// The scale factor applied to the icon of the selected item.
  ///
  /// Use to visually emphasize the selected icon.
  final double selectedIconScale;

  /// Whether to display labels for navigation items.
  ///
  /// If false, only icons are shown.
  final bool showLabels;

  /// Text style applied to the label of the selected navigation item.
  final TextStyle? selectedLabelStyle;

  /// Text style applied to labels of unselected navigation items.
  final TextStyle? unselectedLabelStyle;

  /// How to align the contents of each navigation item along the main axis.
  ///
  /// Common values are [MainAxisAlignment.center] or [MainAxisAlignment.start].
  final MainAxisAlignment itemMainAxisAlignment;

  /// Whether feedback (such as haptic or acoustic) is enabled for tap interactions.
  final bool enableFeedback;

  /// The color of the Material splash effect shown on tap.
  final Color? splashColor;

  /// The color of the highlight shown during a press interaction.
  final Color? highlightColor;

  /// The duration of navigation item state transition animations.
  final Duration animationDuration;

  /// The curve used for navigation item state transition animations.
  final Curve animationCurve;

  /// The visual variant preset to apply to the navigation bar.
  ///
  /// Determines the overall look, such as glassmorphic or modern.
  final FloatingNavBarVariant variant;

  /// The intensity of the backdrop blur, used for translucent effects.
  ///
  /// Only used in certain variants like glassmorphism.
  final double backdropBlur;

  /// The progress of the bar's collapse animation.
  ///
  /// 0.0 corresponds to fully expanded; 1.0 to fully collapsed.
  final double collapseProgress;

  /// The progress of the bar's transparency animation.
  ///
  /// 0.0 preserves the normal material appearance; 1.0 hides the whole bar.
  /// This is independent of the glass surface tint.
  final double transparencyProgress;

  /// The factor by which the navigation bar scales down during collapse.
  final double collapseScaleFactor;

  /// The vertical height reduction, in logical pixels, during collapse.
  final double collapseHeightFactor;

  /// The amount by which the bottom inset (margin) is reduced during collapse.
  final double collapseBottomInsetFactor;

  /// The duration of whole-bar scale and opacity transitions.
  final Duration containerAnimationDuration;

  /// The curve used for whole-bar scale and opacity transitions.
  final Curve containerAnimationCurve;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final glass = variant == FloatingNavBarVariant.glassmorphism;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final clampedCollapse = collapseProgress.clamp(0.0, 1.0);
    final clampedTransparency = transparencyProgress.clamp(0.0, 1.0);
    final barOpacity = (1 - clampedTransparency).clamp(0.0, 1.0);
    final barScale = (1 - (collapseScaleFactor * clampedCollapse)).clamp(
      0.0,
      1.0,
    );
    final collapsedBottomInset = (margin.bottom - collapseBottomInsetFactor)
        .clamp(0.0, margin.bottom)
        .toDouble();
    final effectiveMargin = margin.copyWith(
      bottom:
          margin.bottom -
          ((margin.bottom - collapsedBottomInset) * clampedCollapse),
    );
    final effectiveHeight = variant == FloatingNavBarVariant.compact
        ? height.clamp(56, 70).toDouble()
        : height;
    final animatedHeight =
        (effectiveHeight - (collapseHeightFactor * clampedCollapse))
            .clamp(0.0, effectiveHeight)
            .toDouble();
    final effectiveBorderRadius = variant == FloatingNavBarVariant.compact
        ? borderRadius.clamp(16, 24).toDouble()
        : borderRadius;
    final effectiveItemRadius = variant == FloatingNavBarVariant.compact
        ? itemBorderRadius.clamp(12, 16).toDouble()
        : itemBorderRadius;
    final effectivePadding = variant == FloatingNavBarVariant.compact
        ? const EdgeInsets.symmetric(horizontal: 5, vertical: 4)
        : padding;
    final effectiveItemPadding = variant == FloatingNavBarVariant.compact
        ? const EdgeInsets.symmetric(horizontal: 3, vertical: 6)
        : itemPadding;
    final effectiveIconSize = variant == FloatingNavBarVariant.compact
        ? (iconSize - 2).clamp(16, 22).toDouble()
        : iconSize;
    final effectiveShowLabels = variant == FloatingNavBarVariant.compact
        ? false
        : showLabels;
    final effectiveBackground = glass
        ? (backgroundColor ??
              (dark
                  ? const Color(0xFF20232B).withValues(alpha: 0.42)
                  : Colors.white.withValues(alpha: 0.32)))
        : (backgroundColor ?? colorScheme.surface);
    final effectiveBorderColor = variant == FloatingNavBarVariant.glassmorphism
        ? (borderColor ?? Colors.white.withValues(alpha: dark ? 0.22 : 0.65))
        : borderColor;
    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        glass
            ? Color.lerp(
                effectiveBackground,
                Colors.white.withValues(alpha: dark ? 0.12 : 0.48),
                0.35,
              )!
            : effectiveBackground,
        Color.lerp(effectiveBackground, colorScheme.primary, 0.05) ??
            effectiveBackground,
      ],
    );
    final defaultShadow = [
      BoxShadow(
        color: (shadowColor ?? colorScheme.shadow).withValues(
          alpha: glass ? 0.10 : 0.12,
        ),
        blurRadius: 26,
        offset: const Offset(0, 12),
      ),
      BoxShadow(
        color: colorScheme.primary.withValues(alpha: 0.07),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ];
    return IgnorePointer(
      ignoring: barOpacity == 0,
      child: AnimatedOpacity(
        duration: MediaQuery.of(context).disableAnimations
            ? Duration.zero
            : containerAnimationDuration,
        curve: containerAnimationCurve,
        opacity: barOpacity,
        child: AnimatedScale(
          duration: MediaQuery.of(context).disableAnimations
              ? Duration.zero
              : containerAnimationDuration,
          curve: containerAnimationCurve,
          scale: barScale,
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            minimum: effectiveMargin,
            child: Material(
              type: MaterialType.transparency,
              child: SizedBox(
                width: axis == Axis.vertical ? 72 : null,
                height: axis == Axis.vertical ? null : animatedHeight,
                child: Container(
                  height: axis == Axis.vertical ? null : animatedHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(effectiveBorderRadius),
                    boxShadow: boxShadow ?? defaultShadow,
                  ),
                  child: _clipNavBarShape(
                    effectiveBorderRadius: effectiveBorderRadius,
                    child: Material(
                      elevation: elevation,
                      shadowColor: (shadowColor ?? colorScheme.shadow)
                          .withValues(alpha: 0.2),
                      color: Colors.transparent,
                      child: _buildContainerContent(
                        colorScheme: colorScheme,
                        gradient: backgroundGradient ?? defaultGradient,
                        effectiveBorderRadius: effectiveBorderRadius,
                        effectiveBorderColor: effectiveBorderColor,
                        effectivePadding: effectivePadding,
                        effectiveItemPadding: effectiveItemPadding,
                        effectiveItemRadius: effectiveItemRadius,
                        effectiveIconSize: effectiveIconSize,
                        effectiveShowLabels: effectiveShowLabels,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainerContent({
    required ColorScheme colorScheme,
    required Gradient gradient,
    required double effectiveBorderRadius,
    required Color? effectiveBorderColor,
    required EdgeInsets effectivePadding,
    required EdgeInsets effectiveItemPadding,
    required double effectiveItemRadius,
    required double effectiveIconSize,
    required bool effectiveShowLabels,
  }) {
    final content = DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: Border.all(
          color:
              effectiveBorderColor ??
              colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: borderWidth,
        ),
      ),
      child: Padding(
        padding: effectivePadding,
        child: Flex(
          direction: axis,
          mainAxisSize: axis == Axis.vertical
              ? MainAxisSize.min
              : MainAxisSize.max,
          children: _buildRowChildren(
            colorScheme: colorScheme,
            effectiveItemPadding: effectiveItemPadding,
            effectiveItemRadius: effectiveItemRadius,
            effectiveIconSize: effectiveIconSize,
            effectiveShowLabels: effectiveShowLabels,
          ),
        ),
      ),
    );

    if (variant == FloatingNavBarVariant.glassmorphism) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: backdropBlur, sigmaY: backdropBlur),
          child: content,
        ),
      );
    }
    return content;
  }

  List<Widget> _buildRowChildren({
    required ColorScheme colorScheme,
    required EdgeInsets effectiveItemPadding,
    required double effectiveItemRadius,
    required double effectiveIconSize,
    required bool effectiveShowLabels,
  }) {
    final children = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      children.add(
        _itemSlot(
          child: _FloatingModernNavBarItem(
            item: item,
            isSelected: index == currentIndex,
            onTap: () => onTap(index),
            iconSize: effectiveIconSize,
            selectedIconScale: selectedIconScale,
            itemPadding: effectiveItemPadding,
            itemBorderRadius: effectiveItemRadius,
            selectedItemColor:
                selectedItemColor ??
                colorScheme.primary.withValues(alpha: 0.14),
            unselectedItemColor: unselectedItemColor ?? Colors.transparent,
            selectedLabelColor: selectedLabelColor ?? colorScheme.primary,
            unselectedLabelColor:
                unselectedLabelColor ??
                colorScheme.onSurface.withValues(alpha: 0.7),
            indicatorColor: indicatorColor ?? colorScheme.primary,
            showLabels: effectiveShowLabels,
            selectedLabelStyle: selectedLabelStyle,
            unselectedLabelStyle: unselectedLabelStyle,
            itemMainAxisAlignment: itemMainAxisAlignment,
            animationDuration: animationDuration,
            animationCurve: animationCurve,
            enableFeedback: enableFeedback,
            splashColor:
                splashColor ?? colorScheme.primary.withValues(alpha: 0.1),
            highlightColor:
                highlightColor ?? colorScheme.primary.withValues(alpha: 0.06),
          ),
        ),
      );
    }
    return children;
  }

  Widget _itemSlot({required Widget child}) {
    if (axis == Axis.horizontal) return Expanded(child: child);
    return SizedBox(height: 56, child: child);
  }

  Widget _clipNavBarShape({
    required double effectiveBorderRadius,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveBorderRadius),
      child: child,
    );
  }
}

class _FloatingModernNavBarItem extends StatelessWidget {
  const _FloatingModernNavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.iconSize,
    required this.selectedIconScale,
    required this.itemPadding,
    required this.itemBorderRadius,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.selectedLabelColor,
    required this.unselectedLabelColor,
    required this.indicatorColor,
    required this.showLabels,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.itemMainAxisAlignment,
    required this.animationDuration,
    required this.animationCurve,
    required this.enableFeedback,
    required this.splashColor,
    required this.highlightColor,
  });

  final FloatingNavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final double iconSize;
  final double selectedIconScale;
  final EdgeInsets itemPadding;
  final double itemBorderRadius;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final Color indicatorColor;
  final bool showLabels;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final MainAxisAlignment itemMainAxisAlignment;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableFeedback;
  final Color splashColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    final labelTheme = Theme.of(context).textTheme.labelMedium;
    final activeIcon = item.activeIcon ?? item.icon;

    return Semantics(
      label: item.label,
      selected: isSelected,
      button: true,
      child: Tooltip(
        message: item.tooltip ?? item.label,
        excludeFromSemantics: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(itemBorderRadius),
              enableFeedback: enableFeedback,
              splashColor: splashColor,
              highlightColor: highlightColor,
              child: AnimatedContainer(
                duration: MediaQuery.of(context).disableAnimations
                    ? Duration.zero
                    : animationDuration,
                curve: animationCurve,
                padding: itemPadding,
                decoration: BoxDecoration(
                  color: isSelected ? selectedItemColor : unselectedItemColor,
                  border: isSelected
                      ? Border.all(
                          color: selectedLabelColor.withValues(alpha: 0.08),
                        )
                      : null,
                  borderRadius: BorderRadius.circular(itemBorderRadius),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                          maxHeight: constraints.maxHeight,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: itemMainAxisAlignment,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  AnimatedScale(
                                    duration:
                                        MediaQuery.of(context).disableAnimations
                                        ? Duration.zero
                                        : animationDuration,
                                    curve: animationCurve,
                                    scale: isSelected ? selectedIconScale : 1,
                                    child: Icon(
                                      isSelected ? activeIcon : item.icon,
                                      size: iconSize,
                                      color: isSelected
                                          ? selectedLabelColor
                                          : unselectedLabelColor,
                                    ),
                                  ),
                                  if ((item.badgeCount ?? 0) > 0)
                                    Positioned(
                                      top: -6,
                                      right: -10,
                                      child: _Badge(
                                        count: item.badgeCount!,
                                        color: indicatorColor,
                                      ),
                                    ),
                                ],
                              ),
                              if (showLabels) const SizedBox(height: 4),
                              if (showLabels)
                                AnimatedDefaultTextStyle(
                                  duration:
                                      MediaQuery.of(context).disableAnimations
                                      ? Duration.zero
                                      : animationDuration,
                                  curve: animationCurve,
                                  style:
                                      (isSelected
                                              ? (selectedLabelStyle ??
                                                    labelTheme)
                                              : (unselectedLabelStyle ??
                                                    labelTheme))
                                          ?.copyWith(
                                            color: isSelected
                                                ? selectedLabelColor
                                                : unselectedLabelColor,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ) ??
                                      const TextStyle(),
                                  child: Text(
                                    item.label,
                                    semanticsLabel: '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }
}
