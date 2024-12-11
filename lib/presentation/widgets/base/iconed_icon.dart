import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../extensions/context_extension.dart';

class IconedIcon extends StatelessWidget {
  const IconedIcon({
    required this.icon,
    required this.size,
    this.indicator,
    this.color,
    this.indicatorColor,
    super.key,
  });

  final double size;
  final Color? color;
  final IconData icon;
  final IconData? indicator;
  final Color? indicatorColor;

  @override
  Widget build(final BuildContext context) {
    final icon = FaIcon(
      this.icon,
      size: size,
      color: color,
    );

    if (indicator == null) {
      return icon;
    }
    return Stack(
      children: [
        icon,
        Positioned(
          bottom: 0,
          right: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              FaIcon(
                indicator,
                size: size * 0.6,
                color: context.background,
              ),
              FaIcon(
                indicator,
                size: size * 0.5,
                color: indicatorColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
