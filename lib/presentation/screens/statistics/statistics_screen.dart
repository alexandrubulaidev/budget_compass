import 'package:flutter/material.dart';

import '../../../data/entities/transaction_entity.dart';
import '../../../domain/model/transaction_range.dart';
import 'widgets/statistics_view.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    required this.transactions,
    required this.cashflowStart,
    required this.range,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final double cashflowStart;
  final TransactionRange range;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: StatisticsView(
        transactions: transactions,
        cashflowStart: cashflowStart,
        range: range,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
      ),
    );
  }
}
