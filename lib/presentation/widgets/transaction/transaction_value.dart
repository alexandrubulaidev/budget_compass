import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../application.dart';
import '../../../data/model/transaction_type.dart';
import '../../../data/model/wallet_currency.dart';
import '../../../domain/extensions/wallet_currency_extension.dart';
import '../../extensions/context_extension.dart';

class TransactionValue extends StatelessWidget {
  const TransactionValue({
    required this.currency,
    required this.value,
    required this.type,
    super.key,
  });

  final WalletCurrency currency;
  final double value;
  final TransactionType type;

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FaIcon(
          currency.icon,
          size: (context.titleMedium?.fontSize ?? 15) * 0.70,
        ),
        Text(
          value.toStringAsFixed(Application.decimals),
          style: context.titleMedium,
        ),
      ],
    );
  }
}
