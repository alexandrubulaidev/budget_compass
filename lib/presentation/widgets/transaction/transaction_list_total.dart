import 'package:flutter/material.dart';

import '../../../data/entities/transaction_entity.dart';
import '../../../data/model/transaction_type.dart';
import '../../../domain/extensions/num_extension.dart';
import '../../../utils/app_localizations.dart';
import '../../extensions/context_extension.dart';
import '../keyboard/widgets/biz_keyboard_evaluator.dart';

class TransactionListTotal extends StatelessWidget {
  const TransactionListTotal({
    required this.transactions,
    super.key,
  });

  final List<TransactionEntity> transactions;

  @override
  Widget build(final BuildContext context) {
    final total = transactions.isEmpty
        ? 0.0
        : transactions
            .map(
              (final e) =>
                  e.value * (e.type == TransactionType.expense ? -1 : 1),
            )
            .reduce((final value, final element) => value + element);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '%s transactions'.localized.formatted([transactions.length]),
          style: context.titleSmall,
        ),
        BizKeyboardEvaluator(
          currency: transactions.first.currency,
          keys: total.abs().keys,
          color: total.valueColor,
          elementSize: context.titleSmall?.fontSize ?? 15,
          smallDecimals: true,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}
