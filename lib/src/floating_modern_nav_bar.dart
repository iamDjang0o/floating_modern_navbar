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
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    this.borderRadius = 28,
    this.itemBorderRadius = 18,
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
    this.backdropBlur = 16,
    this.collapseProgress = 0,
    this.transparencyProgress = 0,
    this.collapseScaleFactor = 0.2,
    this.collapseHeightFactor = 12,
    this.collapseBottomInsetFactor = 4,
    this.containerAnimationDuration = const Duration(milliseconds: 220),
    this.containerAnimationCurve = Curves.easeOutCubic,
  });

  final List<FloatingNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final double borderRadius;
  final double itemBorderRadius;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double borderWidth;
  final double elevation;
  final Color? shadowColor;
  final List<BoxShadow>? boxShadow;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? selectedLabelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final double iconSize;
  final double selectedIconScale;
  final bool showLabels;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final MainAxisAlignment itemMainAxisAlignment;
  final bool enableFeedback;
  final Color? splashColor;
  final Color? highlightColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final FloatingNavBarVariant variant;
  final double backdropBlur;
  final double collapseProgress;
  final double transparencyProgress;
  final double collapseScaleFactor;
  final double collapseHeightFactor;
  final double collapseBottomInsetFactor;
  final Duration containerAnimationDuration;
  final Curve containerAnimationCurve;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
    final effectiveBackground = variant == FloatingNavBarVariant.glassmorphism
        ? (backgroundColor ?? colorScheme.surface).withValues(alpha: 0.55)
        : (backgroundColor ?? colorScheme.surface);
    final effectiveBorderColor = variant == FloatingNavBarVariant.glassmorphism
        ? (borderColor ?? Colors.white.withValues(alpha: 0.28))
        : borderColor;
    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        effectiveBackground,
        Color.lerp(effectiveBackground, colorScheme.primary, 0.05) ??
            effectiveBackground,
      ],
    );
    final defaultShadow = [
      BoxShadow(
        color: (shadowColor ?? colorScheme.shadow).withValues(alpha: 0.14),
        blurRadius: 26,
        offset: const Offset(0, 12),
      ),
      BoxShadow(
        color: colorScheme.primary.withValues(alpha: 0.07),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ];
    return AnimatedOpacity(
      duration: containerAnimationDuration,
      curve: containerAnimationCurve,
      opacity: barOpacity,
      child: AnimatedScale(
        duration: containerAnimationDuration,
        curve: containerAnimationCurve,
        scale: barScale,
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          minimum: effectiveMargin,
          child: Material(
            type: MaterialType.transparency,
            child: SizedBox(
              height: animatedHeight,
              child: Container(
                height: animatedHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
                  boxShadow: boxShadow ?? defaultShadow,
                ),
                child: _clipNavBarShape(
                  effectiveBorderRadius: effectiveBorderRadius,
                  child: Material(
                    elevation: elevation,
                    shadowColor: (shadowColor ?? colorScheme.shadow).withValues(
                      alpha: 0.2,
                    ),
                    color: backgroundGradient == null
                        ? effectiveBackground
                        : null,
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
    final content = Ink(
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
        child: Row(
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
        Expanded(
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

    return Padding(
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
            duration: animationDuration,
            curve: animationCurve,
            padding: itemPadding,
            decoration: BoxDecoration(
              color: isSelected ? selectedItemColor : unselectedItemColor,
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
                                duration: animationDuration,
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
                              duration: animationDuration,
                              curve: animationCurve,
                              style:
                                  (isSelected
                                          ? (selectedLabelStyle ?? labelTheme)
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
