import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';
import 'biz_button.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    required this.child,
    required this.onButtonTap,
    this.padding,
    this.buttonText,
    this.buttonHeight = 36.0,
    this.buttonWidth = 180,
    super.key,
  });

  final Widget child;
  final String? buttonText;
  final double buttonHeight;
  final double buttonWidth;
  final void Function() onButtonTap;
  final EdgeInsets? padding;

  @override
  Widget build(final BuildContext context) {
    final text = buttonText;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: buttonHeight / 2),
          child: Container(
            decoration: BoxDecoration(
              color: context.background,
              boxShadow: [
                BoxShadow(
                  color: context.primary.withAlpha(100),
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
            child: child,
          ),
        ),
        if (text != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: BizButton(
                  onTap: onButtonTap,
                  text: text,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
