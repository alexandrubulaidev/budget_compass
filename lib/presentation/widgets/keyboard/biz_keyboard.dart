// ignore_for_file: no_default_cases, use_colored_box

import 'package:flutter/material.dart';
import 'package:list_ext/list_ext.dart';

import '../../../domain/extensions/transaction_type_extension.dart';
import '../../extensions/context_extension.dart';
import '../base/multi_rx_builder.dart';
import 'biz_keyboard_controller.dart';
import 'widgets/biz_keyboard_key.dart';
import 'widgets/biz_keyboard_key_widget.dart';

class BizKeyboard extends StatelessWidget {
  const BizKeyboard({
    required this.controller,
  });

  final BizKeyboardController controller;

  @override
  Widget build(final BuildContext context) {
    final keyboard = [
      [
        BizKeyboardKey.divide,
        BizKeyboardKey.seven,
        BizKeyboardKey.eight,
        BizKeyboardKey.nine,
        BizKeyboardKey.delete,
      ],
      [
        BizKeyboardKey.multiply,
        BizKeyboardKey.four,
        BizKeyboardKey.five,
        BizKeyboardKey.six,
        BizKeyboardKey.empty,
      ],
      [
        BizKeyboardKey.subtract,
        BizKeyboardKey.one,
        BizKeyboardKey.two,
        BizKeyboardKey.three,
        BizKeyboardKey.empty,
      ],
      [
        BizKeyboardKey.add,
        BizKeyboardKey.trash,
        BizKeyboardKey.zero,
        BizKeyboardKey.decimal,
        BizKeyboardKey.check,
      ]
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keyboard
          .map((final row) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row
                    .map((final key) {
                      if (key == BizKeyboardKey.check) {
                        return Expanded(
                          child: MultiRxBuilder(
                            subjects: [
                              controller.operationStream,
                              controller.typeStream,
                            ],
                            builder: (final context, final value) {
                              final operatorCount = controller.operation
                                  .where((final e) => e.isOperation)
                                  .length;
                              final firstIsNegative =
                                  controller.operation.first ==
                                      BizKeyboardKey.subtract;

                              var valid = firstIsNegative && operatorCount == 1;
                              valid = valid || operatorCount == 0;

                              return _buildKeyboardButton(
                                context: context,
                                button: valid ? key : BizKeyboardKey.equals,
                                color: valid ? controller.type.color : null,
                              );
                            },
                          ),
                        );
                      } else {
                        return Expanded(
                          child: _buildKeyboardButton(
                            context: context,
                            button: key,
                          ),
                        );
                      }
                    })
                    .cast<Widget>()
                    .intersperse(
                      Container(
                        width: 1,
                        color: context.captionColor?.withAlpha(50),
                      ),
                    )
                    .toList(),
              ),
            );
          })
          .cast<Widget>()
          .intersperse(
            Container(
              height: 1,
              color: context.captionColor?.withAlpha(50),
            ),
          )
          .toList(),
    );
  }

  Widget _buildKeyboardButton({
    required final BuildContext context,
    required final BizKeyboardKey button,
    final Color? background,
    final Color? color,
  }) {
    final clr = color ?? context.primaryTextColor;
    final bgr = background ?? context.background;

    return Material(
      color: bgr,
      child: Ink(
        color: bgr,
        child: InkWell(
          onTap: button == BizKeyboardKey.empty
              ? null
              : () => controller.onKeyPressed(button),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: BizKeyboardKeyWidget(
              button: button,
              color: clr,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
