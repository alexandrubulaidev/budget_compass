import 'package:flutter/material.dart';

import '../../../data/model/wallet.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({
    required this.wallet,
    super.key,
  });

  final Wallet wallet;

  @override
  Widget build(final BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Reminders Screen'),
      ),
    );
  }
}
