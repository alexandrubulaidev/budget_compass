import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../data/entities/transaction_entity.dart';
import '../../../../domain/extensions/transaction_entity_list_helper.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/tags/transaction_tag_icon.dart';

class StatisticsCategoriesPie extends StatelessWidget {
  const StatisticsCategoriesPie({
    required this.transactions,
    this.radius = 100,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final double radius;

  @override
  Widget build(final BuildContext context) {
    final statistics = transactions.groupByTags();
    final total = statistics.isEmpty
        ? 0.0
        : statistics
            .map((final e) => e.value)
            .reduce((final value, final element) => value + element);

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
            centerSpaceRadius: 0,
            borderData: FlBorderData(
              border: Border.all(
                color: context.background,
              ),
            ),
            pieTouchData: PieTouchData(
              touchCallback: (final event, final pieTouchResponse) {
                // setState(() {
                //   if (!event.isInterestedForInteractions ||
                //       pieTouchResponse == null ||
                //       pieTouchResponse.touchedSection == null) {
                //     touchedIndex = -1;s
                //     return;
                //   }
                //   touchedIndex =
                //       pieTouchResponse.touchedSection!.touchedSectionIndex;
                // });
              },
            ),
            sections: statistics.map((final transaction) {
              final percent = (transaction.value / total) * 100;
              return PieChartSectionData(
                title: '${percent.toStringAsFixed(0)}%',
                value: transaction.value,
                color: transaction.color,
                badgeWidget: TransactionTagIcon(
                  icon: transaction.icon,
                  size: 25,
                  color: transaction.color,
                ),
                titleStyle: context.bodyMedium?.apply(
                  fontWeightDelta: 2,
                  color: context.background,
                ),
                titlePositionPercentageOffset: 0.80,
                radius: radius,
                badgePositionPercentageOffset: 1.20,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
