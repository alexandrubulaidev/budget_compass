import 'package:flutter/material.dart';

import '../../app_theme.dart';

class InkTap extends StatelessWidget {
  const InkTap({
    this.color,
    this.child,
    this.borderRadius,
    this.onTap,
    this.onLongTap,
    super.key,
  });

  final void Function()? onTap;
  final void Function()? onLongTap;
  final Color? color;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(final BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(kBorderRadius),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongTap,
        child: child,
      ),
    );
  }
}
