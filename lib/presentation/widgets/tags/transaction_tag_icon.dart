import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionTagIcon extends StatelessWidget {
  const TransactionTagIcon({
    this.icon,
    this.size,
    this.color,
    super.key,
  });

  final IconData? icon;
  final double? size;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    return FaIcon(
      icon,
      size: size ?? 15,
      color: color,
    );
  }
}
