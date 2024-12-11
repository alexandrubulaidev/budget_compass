import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../domain/services.dart';
import 'wallet_view_controller.dart';

class WalletView extends StatefulWidget {
  const WalletView({
    super.key,
  });

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  void dispose() {
    super.dispose();
    unawaited(Services.unregister<WalletScreenController>());
  }

  @override
  Widget build(final BuildContext context) {
    return const Center(
      child: Text('Wallet view'),
    );
  }
}
