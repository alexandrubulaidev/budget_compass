import 'package:flutter/material.dart';

import 'widgets/wallet_view.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({
    required this.walletId,
    super.key,
  });

  final int walletId;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: const WalletView(),
    );
  }
}
