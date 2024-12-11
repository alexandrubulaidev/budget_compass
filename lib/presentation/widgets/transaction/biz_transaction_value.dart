import 'package:flutter/material.dart';

import '../../../data/model/wallet_currency.dart';
import '../../../domain/extensions/num_extension.dart';
import '../../extensions/context_extension.dart';
import '../keyboard/widgets/biz_keyboard_evaluator.dart';

class BizTransactionValue extends StatelessWidget {
  const BizTransactionValue({
    required this.currency,
    required this.value,
    this.color,
    this.size,
    super.key,
  });

  final double? size;
  final double value;
  final WalletCurrency currency;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    return BizKeyboardEvaluator(
      currency: currency,
      keys: value.keys,
      color: color ?? context.primaryTextColor,
      elementSize: size ?? context.bodySmall?.fontSize ?? 15,
      smallDecimals: true,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
