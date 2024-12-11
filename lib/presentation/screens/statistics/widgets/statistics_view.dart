import 'package:flutter/material.dart';

import '../../../../data/entities/transaction_entity.dart';
import '../../../../data/model/transaction_type.dart';
import '../../../../domain/model/transaction_range.dart';
import '../../../../utils/app_localizations.dart';
import '../../../app_theme.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/tab_viewer.dart';
import '../tabs/statistics_categories_list.dart';
import '../tabs/statistics_overall.dart';

enum StatisticsMode {
  overall,
  expenses,
  incomes,
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({
    required this.transactions,
    required this.cashflowStart,
    required this.range,
    this.padding,
    this.modes = StatisticsMode.values,
    this.initial = StatisticsMode.overall,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final double cashflowStart;
  final EdgeInsets? padding;
  final List<StatisticsMode> modes;
  final StatisticsMode initial;
  final TransactionRange range;

  @override
  Widget build(final BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 70,
          ),
          child: Text(
            'You have no transactions for this selection',
            textAlign: TextAlign.center,
            style: context.titleSmall?.apply(color: context.disabledColor),
          ),
        ),
      );
    }

    return TabViewer(
      titles: [
        'Overall'.localized,
        'Income'.localized,
        'Expenses'.localized,
      ],
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kHorizontalPadding / 2,
          ),
          child: StatisticsOverall(
            transactions: transactions,
            cashflowStart: cashflowStart,
            range: range,
          ),
        ),
        StatisticsCategoriesList(
          type: TransactionType.income,
          transactions: transactions
              .where((final element) => element.type == TransactionType.income)
              .toList(),
        ),
        StatisticsCategoriesList(
          type: TransactionType.expense,
          transactions: transactions
              .where((final element) => element.type == TransactionType.expense)
              .toList(),
        ),
      ],
    );
  }
}
