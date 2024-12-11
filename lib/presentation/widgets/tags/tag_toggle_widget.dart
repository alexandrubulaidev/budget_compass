import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../app_theme.dart';
import '../../extensions/context_extension.dart';
import 'transaction_tag_icon.dart';

class TagToggleWidget extends StatelessWidget {
  const TagToggleWidget({
    required this.color,
    required this.name,
    this.iconSize,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    this.icon,
    this.selected = false,
    this.onTap,
    this.onLongTap,
    this.textStyle,
    this.borderWidth = 1,
    this.borderRadius = kBorderRadius,
    this.direction = TextDirection.ltr,
    super.key,
  });

  final TextDirection direction;
  final double borderRadius;
  final double borderWidth;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final double? iconSize;
  final IconData? icon;
  final Color color;
  final String name;
  final bool selected;
  final void Function()? onTap;
  final void Function()? onLongTap;

  @override
  Widget build(final BuildContext context) {
    final background = selected ? color : context.background;
    final text = selected ? context.background : color;

    var children = [
      if (icon != null) ...[
        TransactionTagIcon(
          icon: icon,
          size: iconSize,
          color: text,
        ),
        const SizedBox(width: 6),
      ],
      Text(
        name.localized,
        style: textStyle ??
            context.labelLarge?.apply(
              color: text,
            ),
      ),
    ];

    if (direction == TextDirection.rtl) {
      children = children.reversed.toList();
    }

    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      color: background,
      child: Ink(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          onTap: onTap,
          onLongPress: onLongTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderWidth == 0
                  ? null
                  : Border.all(
                      width: borderWidth,
                      color: color,
                      strokeAlign: 0,
                    ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
