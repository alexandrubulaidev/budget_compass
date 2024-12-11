import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'biz_keyboard_key.dart';

class BizKeyboardKeyWidget extends StatelessWidget {
  const BizKeyboardKeyWidget({
    required this.button,
    required this.color,
    required this.size,
    super.key,
  });

  final double size;
  final Color color;
  final BizKeyboardKey button;

  @override
  Widget build(final BuildContext context) {
    final icon = button.icon;
    return Builder(
      builder: (final context) {
        // if (button.isNumber) {
        //   return SizedBox(
        //     child: Text(
        //       button.stringValue ?? '',
        //       style: TextStyle(
        //         fontSize: size,
        //         color: color,
        //       ),
        //     ),
        //   );
        // }
        if (button == BizKeyboardKey.comma) {
          return SizedBox(
            height: size,
            child: Text(
              ',',
              style: TextStyle(
                fontSize: size * 0.75,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          );
        }
        if (button == BizKeyboardKey.decimal) {
          return SizedBox(
            width: size / 3,
            height: size,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: size / 10),
                child: Container(
                  height: size / 8,
                  width: size / 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
            ),
          );
        }
        if (button == BizKeyboardKey.space) {
          return SizedBox(
            height: size / 5,
            width: size / 5,
          );
        }
        if (icon == null) {
          return Container();
        }
        return FaIcon(
          icon,
          size: size,
          color: color,
        );
      },
    );
  }
}
