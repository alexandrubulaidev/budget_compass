import 'package:flutter/material.dart';

import '../../app_theme.dart';

class BizButton extends StatelessWidget {
  const BizButton({
    required this.text,
    this.onTap,
    super.key,
  });

  final void Function()? onTap;
  final String text;

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        // backgroundColor: Colors.black, // Background color
        // foregroundColor: Colors.amber, // Text Color (Foreground color)
      ),
      onPressed: onTap,
      child: Text(
        text,
      ),
    );
  }
}
