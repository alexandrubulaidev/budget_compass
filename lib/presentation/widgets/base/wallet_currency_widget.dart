import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/model/wallet_currency.dart';
import '../../../domain/extensions/wallet_currency_extension.dart';

class WalletCurrencyWidget extends StatelessWidget {
  const WalletCurrencyWidget({
    required this.currency,
    required this.color,
    required this.size,
    super.key,
  });

  final WalletCurrency currency;
  final Color color;
  final double size;

  @override
  Widget build(final BuildContext context) {
    final icon = currency.icon;

    return icon == null
        ? Text(
            currency.userString,
            style: TextStyle(
              height: 0.9,
              fontSize: size,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          )
        : FaIcon(
            icon,
            size: size,
            color: color,
          );
  }
}
