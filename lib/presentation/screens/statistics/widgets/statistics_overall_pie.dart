import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../data/entities/transaction_entity.dart';
import '../../../../data/model/transaction_type.dart';
import '../../../../domain/extensions/transaction_type_extension.dart';
import '../../../extensions/context_extension.dart';

class StatisticsOverallPie extends StatefulWidget {
  const StatisticsOverallPie({
    required this.transactions,
    this.radius = 100,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final double radius;

  @override
  State<StatisticsOverallPie> createState() => _StatisticsOverallPieState();
}

class _StatisticsOverallPieState extends State<StatisticsOverallPie> {
  @override
  Widget build(final BuildContext context) {
    final incomes = widget.transactions
        .where((final e) => e.type == TransactionType.income);
    final expenses = widget.transactions
        .where((final e) => e.type == TransactionType.expense);

    final incomeValue = incomes.isEmpty
        ? 0.0
        : incomes
            .map((final e) => e.value)
            .reduce((final value, final element) => value + element);
    final expenseValue = expenses.isEmpty
        ? 0.0
        : expenses
            .map((final e) => e.value)
            .reduce((final value, final element) => value + element);

    final totalValue = incomeValue + expenseValue;
    final incomePercent = incomeValue / totalValue * 100;
    final expensePercent = expenseValue / totalValue * 100;
    final pieSize = widget.radius * 0.40;
    final centerSize = widget.radius * 0.60;

    return Padding(
      padding: const EdgeInsets.all(50),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 200,
          maxWidth: 200,
        ),
        child: PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: centerSize,
            pieTouchData: PieTouchData(
              touchCallback: (final event, final pieTouchResponse) {},
            ),
            sections: [
              PieChartSectionData(
                title: '${incomePercent.toStringAsFixed(0)}%',
                value: incomeValue,
                color: TransactionType.income.color,
                titleStyle: context.bodyMedium?.apply(
                  fontWeightDelta: 2,
                  color: context.background,
                ),
                radius: pieSize,
              ),
              PieChartSectionData(
                title: '${expensePercent.toStringAsFixed(0)}%',
                value: expenseValue,
                color: TransactionType.expense.color,
                titleStyle: context.bodyMedium?.apply(
                  fontWeightDelta: 2,
                  color: context.background,
                ),
                radius: pieSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
