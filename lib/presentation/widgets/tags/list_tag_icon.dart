// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import 'transaction_tag_icon.dart';

class ListTagIcon extends StatelessWidget {
  const ListTagIcon({
    required this.icon,
    required this.color,
    this.size = 40,
    this.secondaryIcon,
    this.secondaryColor,
    super.key,
  });

  final double size;
  final IconData icon;
  final Color color;
  final IconData? secondaryIcon;
  final Color? secondaryColor;

  @override
  Widget build(final BuildContext context) {
    final secondaryIcon = this.secondaryIcon;
    final secondaryColor = this.secondaryColor;

    final primaryIconWidget = Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color,
        ),
        child: SizedBox.square(
          dimension: size,
          child: Center(
            child: TransactionTagIcon(
              icon: icon,
              size: size / 2,
              color: context.onPrimary,
            ),
          ),
        ),
      ),
    );

    Widget? secondaryIconWidget;
    if (secondaryIcon != null && secondaryColor != null) {
      secondaryIconWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 4),
          color: secondaryColor,
          // border: Border.all(
          //   color: context.background,
          //   width: 1.5,
          // ),
        ),
        child: SizedBox.square(
          dimension: size / 2,
          child: Center(
            child: TransactionTagIcon(
              icon: secondaryIcon,
              size: size / 4,
              color: context.onPrimary,
            ),
          ),
        ),
      );
    }

    final iconWidget = secondaryIconWidget == null
        ? primaryIconWidget
        : Stack(
            children: [
              primaryIconWidget,
              Positioned(
                bottom: 0,
                right: 0,
                child: secondaryIconWidget,
              ),
            ],
          );

    return iconWidget;
  }
}
