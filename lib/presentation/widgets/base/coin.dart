// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Coin extends StatelessWidget {
  const Coin({
    required this.size,
    super.key,
  });
  final double size;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 6,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.yellow.shade200.withAlpha(150),
            width: size * 0.04,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withAlpha(50),
              width: size * 0.02,
            ),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.dollarSign,
              color: Colors.yellow[200],
              size: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
