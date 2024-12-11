import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../data/entities/transaction_entity.dart';
import '../../../../../data/model/transaction_type.dart';
import '../../../../../domain/extensions/transaction_type_extension.dart';
import '../../../../../domain/model/transaction_range.dart';
import '../../../../../utils/app_localizations.dart';
import '../../../../app_theme.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../utilities.dart';
import 'statistics_transaction_bars_data.dart';

class StatisticsTransactionBars extends StatefulWidget {
  const StatisticsTransactionBars({
    required this.transactions,
    required this.range,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final TransactionRange range;

  @override
  State<StatisticsTransactionBars> createState() =>
      _StatisticsTransactionBarsState();
}

class _StatisticsTransactionBarsState extends State<StatisticsTransactionBars> {
  int? _selectedIndex;

  @override
  Widget build(final BuildContext context) {
    final data = StatisticsTransactionBarsData(
      transactions: widget.transactions,
      range: widget.range,
    );

    if (data.rawData.isEmpty) {
      return Container();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kVerticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kHorizontalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Breakdown'.localized,
                    style: context.titleSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: kVerticalPadding + 10),
            AspectRatio(
              aspectRatio: 1.6,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: context.background,
                      tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                      tooltipMargin: 5,
                      getTooltipItem: (
                        final group,
                        final groupIndex,
                        final rod,
                        final rodIndex,
                      ) {
                        final style = context.bodyMedium?.apply(
                              fontWeightDelta: 2,
                            ) ??
                            const TextStyle();
                        return BarTooltipItem(
                          '${data.titles[groupIndex]}\n',
                          style,
                          children: <TextSpan>[
                            TextSpan(
                              text: formatValue(
                                value: data.rawData[groupIndex].$1,
                                currency: widget.transactions.first.currency,
                              ),
                              style: style.apply(
                                color: TransactionType.income.color,
                              ),
                            ),
                            const TextSpan(text: '\n'),
                            TextSpan(
                              text: formatValue(
                                value: data.rawData[groupIndex].$2,
                                currency: widget.transactions.first.currency,
                              ),
                              style: style.apply(
                                color: TransactionType.expense.color,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    touchCallback: (final event, final barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          _selectedIndex = null;
                          return;
                        }
                        _selectedIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  maxY: data.maxY,
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (final value, final meta) {
                          final index = value.toInt() - 1;
                          return Text(
                            data.titles[index],
                            style: context.bodyExtraSmall,
                          );
                        },
                        reservedSize: kChartBottomSpace,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: kChartLeftSpace,
                        getTitlesWidget: (final value, final meta) {
                          if (value == data.maxY) {
                            return Container();
                          }
                          return Text(
                            formatValue(
                              value: value,
                              currency: widget.transactions.first.currency,
                              digits: 0,
                            ),
                            style: context.bodyExtraSmall,
                            textAlign: TextAlign.right,
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: data.rawData.map((final raw) {
                    final raw1 = raw.$1;
                    final raw2 = raw.$2;
                    final index = data.rawData.indexOf(raw);
                    final selected = _selectedIndex == index;
                    final width = selected ? 8.0 : 7.0;
                    return BarChartGroupData(
                      barsSpace: 4,
                      x: index + 1,
                      barRods: [
                        BarChartRodData(
                          toY: raw1 == 0
                              ? 0.01
                              : raw1 + (selected ? raw1 * 0.01 : 0),
                          color: raw1 == 0
                              ? TransactionType.income.color.withAlpha(50)
                              : TransactionType.income.color,
                          width: width,
                        ),
                        BarChartRodData(
                          toY: raw2 == 0
                              ? 0.01
                              : raw2 + (selected ? raw2 * 0.02 : 0),
                          color: raw2 == 0
                              ? TransactionType.expense.color.withAlpha(50)
                              : TransactionType.expense.color,
                          width: width,
                        ),
                      ],
                    );
                  }).toList(),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
