import 'package:flutter/material.dart';

import '../../../../domain/services.dart';
import '../../../app_theme.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/multi_rx_builder.dart';
import '../../../widgets/keyboard/widgets/biz_keyboard_evaluator.dart';
import '../../../widgets/keyboard/widgets/biz_keyboard_key.dart';
import '../../../widgets/transaction/transaction_type_segment/transaction_type_segment_value.dart';
import '../add_transaction_screen_controller.dart';

class TransactionValueSegment extends StatelessWidget {
  TransactionValueSegment({super.key});

  final _controller = Services.get<AddTransactionScreenController>();

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 60,
      decoration: BoxDecoration(
        color: context.primaryTextColor.withAlpha(25),
        borderRadius: BorderRadius.circular(
          kBorderRadius,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: MultiRxBuilder(
              subjects: [
                _controller.keyboardController.operationStream,
                _controller.typeStream,
              ],
              builder: (final context, final values) {
                return BizKeyboardEvaluator(
                  currency: _controller.wallet.currency,
                  keys: values[0] as List<BizKeyboardKey>,
                  color: (values[1] as TransactionTypeSegmentValue).color,
                  elementSize: 25,
                  smallDecimals: false,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
