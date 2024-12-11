import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../extensions/context_extension.dart';

class FlatBorderedButton extends StatelessWidget {
  const FlatBorderedButton({
    required this.text,
    this.style,
    this.color,
    this.onTap,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(final BuildContext context) {
    final color = onTap == null
        ? context.captionColor?.withAlpha(100) ?? Colors.grey.shade300
        : this.color ?? context.primary;

    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: style?.apply(color: color) ??
                  context.titleMedium?.apply(
                    color: color,
                    fontWeightDelta: 2,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
