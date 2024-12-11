import 'package:flutter/material.dart';

import '../../../../data/model/wallet_currency.dart';
import '../../base/wallet_currency_widget.dart';
import 'biz_keyboard_key.dart';
import 'biz_keyboard_key_widget.dart';

class BizKeyboardEvaluator extends StatelessWidget {
  const BizKeyboardEvaluator({
    required this.currency,
    required this.keys,
    required this.color,
    required this.elementSize,
    required this.smallDecimals,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    super.key,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final WalletCurrency currency;
  final bool smallDecimals;
  final double elementSize;
  final Color color;
  final List<BizKeyboardKey> keys;

  List<BizKeyboardKey> _insertCommas(final List<BizKeyboardKey> keys) {
    final result = <BizKeyboardKey>[];

    var count = 0;
    for (var i = keys.length - 1; i >= 0; i--) {
      final key = keys[i];
      result.insert(0, key);
      if (key.isNumber) {
        count++;
      } else {
        count = 0;
      }
      final next = i - 1 >= 0 ? keys[i - 1] : null;
      final current = keys[i];
      final betweenNumbers = next != null && next.isNumber && current.isNumber;
      if (count == 3) {
        if (betweenNumbers) {
          result.insert(0, BizKeyboardKey.comma);
        }
        count = 0;
      }
      // else if (betweenNumbers) {
      //   result.insert(0, BizKeyboardKey.space);
      // }
    }

    return result;
  }

  double size(final int index, final List<BizKeyboardKey> operation) {
    if (smallDecimals) {
      if (index - 1 > 0 && operation[index - 1] == BizKeyboardKey.decimal) {
        return elementSize * 0.75;
      }
      if (index - 2 > 0 && operation[index - 2] == BizKeyboardKey.decimal) {
        return elementSize * 0.75;
      }
    }
    return elementSize;
  }

  @override
  Widget build(final BuildContext context) {
    final operation = _insertCommas(keys);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        WalletCurrencyWidget(
          currency: currency,
          color: color,
          size: elementSize * 0.8,
        ),
        SizedBox(width: elementSize / 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < operation.length; i++) ...[
              if (operation[i].isOperation) ...[
                SizedBox(width: elementSize / 5),
              ] else ...[
                SizedBox(width: elementSize / 20),
              ],
              BizKeyboardKeyWidget(
                button: operation[i],
                color: color,
                size: size(i, operation),
              ),
              if (operation[i].isOperation) ...[
                SizedBox(width: elementSize / 5),
              ],
            ],
          ],
        ),
      ],
    );
  }
}
