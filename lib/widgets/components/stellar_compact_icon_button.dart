import 'package:flutter/material.dart';

/// An [IconButton] but removed extra space it takes around itself.
class StellarCompactIconButton extends StatelessWidget {
  const StellarCompactIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.padding,
    this.color,
    this.iconSize,
    this.backgroundColor,
  });

  final Widget icon;

  final VoidCallback onPressed;

  final String? tooltip;

  final EdgeInsetsGeometry? padding;

  final Color? color;

  final double? iconSize;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      color: color,
      tooltip: tooltip,
      visualDensity: .compact,
      style: IconButton.styleFrom(tapTargetSize: .shrinkWrap, backgroundColor: backgroundColor),
      padding: padding ?? .zero,
      constraints: BoxConstraints(),
      onPressed: onPressed,
      icon: icon,
    );
  }
}
