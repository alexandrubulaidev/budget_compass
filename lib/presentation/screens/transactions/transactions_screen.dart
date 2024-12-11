import 'dart:async';

import 'package:flutter/material.dart';
import '../../../data/entities/transaction_entity.dart';
import '../../../domain/services.dart';
import '../../../domain/wallet/wallet_service.dart';
import '../../../utils/app_localizations.dart';
import '../../dialog/base/simple_dialog_helpers.dart';
import '../../extensions/context_extension.dart';
import '../add_transaction/add_transaction_screen.dart';
import 'widgets/transactions_list.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({
    required this.transactions,
    super.key,
  });

  final List<TransactionEntity> transactions;

  Future<void> _showTransaction({
    required final BuildContext context,
    required final TransactionEntity transaction,
  }) async {
    await context.basicPush<List<String>?>(
      AddTransactionScreen(
        transaction: transaction,
      ),
    );
  }

  Future<void> _deleteTransaction({
    required final BuildContext context,
    required final TransactionEntity transaction,
  }) async {
    final success = await showConfirmationDialog(
      context: context,
      message:
          'Do you want to delete this transaction? This action is irreversible.'
              .localized,
      confirmTitle: 'Yes'.localized,
      declineTitle: 'Cancel'.localized,
    );
    if (success) {
      final result = await Services.get<WalletService>().deleteTransaction(
        transaction: transaction,
      );
      if (result != null) {
        if (context.mounted) {
          await showErrorDialog(
            context: context,
            message: result.message,
          );
        }
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: TransactionsList(
        transactions: transactions,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        onTap: (final transaction) {
          unawaited(
            _showTransaction(
              context: context,
              transaction: transaction,
            ),
          );
        },
        onLongTap: (final transaction) {
          unawaited(
            _deleteTransaction(
              context: context,
              transaction: transaction,
            ),
          );
        },
      ),
    );
  }
}
