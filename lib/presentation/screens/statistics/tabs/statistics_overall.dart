import 'package:flutter/material.dart';

import '../../../../data/entities/transaction_entity.dart';
import '../../../../domain/model/transaction_range.dart';
import '../../../app_theme.dart';
import '../widgets/statistics_cashflow_chart/statistics_cashflow_chart.dart';
import '../widgets/statistics_transaction_bars/statistics_transaction_bars.dart';

class StatisticsOverall extends StatelessWidget {
  const StatisticsOverall({
    required this.transactions,
    required this.range,
    required this.cashflowStart,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final TransactionRange range;
  final double cashflowStart;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: kVerticalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatisticsCashflowChart(
            transactions: transactions,
            cashflowStart: cashflowStart,
            range: range,
          ),
          StatisticsTransactionBars(
            transactions: transactions,
            range: range,
          ),
          // Center(
          //   child: StatisticsOverallPie(
          //     transactions: transactions,
          //   ),
          // ),
          // Center(
          //   child: StatisticsCategoriesPie(
          //     transactions: transactions,
          //   ),
          // ),
        ],
      ),
    );
  }
}
