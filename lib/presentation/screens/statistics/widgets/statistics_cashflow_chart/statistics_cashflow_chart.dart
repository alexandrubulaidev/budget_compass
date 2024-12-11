// ignore_for_file: avoid_redundant_argument_values

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../data/entities/transaction_entity.dart';
import '../../../../../data/model/transaction_type.dart';
import '../../../../../domain/extensions/num_extension.dart';
import '../../../../../domain/extensions/transaction_type_extension.dart';
import '../../../../../domain/model/transaction_range.dart';
import '../../../../../domain/services.dart';
import '../../../../../domain/wallet/wallet_service.dart';
import '../../../../../utils/app_localizations.dart';
import '../../../../app_theme.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../utilities.dart';
import '../../../../widgets/transaction/biz_transaction_value.dart';
import '../../chart_step.dart';
import 'statistics_cashflow_chart_data.dart';

class StatisticsCashflowChart extends StatelessWidget {
  const StatisticsCashflowChart({
    required this.transactions,
    required this.range,
    required this.cashflowStart,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final TransactionRange range;
  final double cashflowStart;

  WalletService get _service => Services.get<WalletService>();

  @override
  Widget build(final BuildContext context) {
    final data = StatisticsCashflowChartData(
      transactions: transactions,
      cashflowStart: cashflowStart,
      range: range,
    );

    if (data.lineData.isEmpty) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cashflow'.localized,
                        style: context.titleSmall,
                      ),
                      FaIcon(
                        data.balance.valueIcon,
                        color: data.balance.valueColor,
                        size: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Income'.localized,
                        style: context.bodyMedium,
                      ),
                      BizTransactionValue(
                        currency: transactions.first.currency,
                        value: data.income,
                        color: TransactionType.income.color,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expenses'.localized,
                        style: context.bodyMedium,
                      ),
                      BizTransactionValue(
                        currency: transactions.first.currency,
                        value: data.expense,
                        color: TransactionType.expense.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 0.5,
                    color: context.disabledColor.withAlpha(50),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total'.localized,
                        style: context.bodyMedium,
                      ),
                      BizTransactionValue(
                        currency: transactions.first.currency,
                        value: data.balance.abs(),
                        color: data.balance == 0
                            ? context.primaryTextColor
                            : data.balance < 0
                                ? TransactionType.expense.color
                                : TransactionType.income.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kVerticalPadding + 10),
            AspectRatio(
              aspectRatio: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: kHorizontalPadding,
                  left: kHorizontalPadding,
                ),
                child: LineChart(
                  LineChartData(
                    minX: data.minX,
                    maxX: data.maxX,
                    minY: data.minY,
                    maxY: data.maxY,
                    backgroundColor: Colors.transparent,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 0,
                          dashArray: [8, 2],
                          strokeWidth: 0.5,
                          color: context.primaryColorLight,
                        ),
                      ],
                    ),
                    gridData: const FlGridData(
                      show: false,
                      drawVerticalLine: false,
                      drawHorizontalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: kChartBottomSpace,
                          interval: data.xInterval,
                          getTitlesWidget: (final value, final meta) {
                            final isFirst = value == data.minX;
                            final isLast = value == data.maxX;
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                isFirst || isLast
                                    ? ''
                                    : data.step.formatTimestamp(value),
                                style: context.bodyExtraSmall,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: data.yInterval,
                          getTitlesWidget: (final value, final meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                numberShortForm(value),
                                style: context.bodyExtraSmall,
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                          reservedSize: kChartLeftSpace,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.lineData,
                        isCurved: false,
                        curveSmoothness: 0.15,
                        barWidth: 1,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(
                          show: false,
                        ),
                        color: context.primaryColorDark,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              context.primaryColorLight,
                              context.primaryColorDark,
                            ]
                                .map((final color) => color.withOpacity(0.3))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      getTouchedSpotIndicator:
                          (final barData, final spotIndexes) {
                        return spotIndexes.map((final index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: context.primary,
                              strokeWidth: 1,
                            ),
                            FlDotData(
                              getDotPainter: (
                                final spot,
                                final percent,
                                final bar,
                                final index,
                              ) {
                                return FlDotCirclePainter(
                                  radius: 3,
                                  color: context.primary,
                                  strokeColor: context.primary,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: context.background,
                        getTooltipItems: (final touchedSpots) {
                          return touchedSpots.map((final flSpot) {
                            final formatted = DateFormat.MMMd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                flSpot.x.toInt(),
                              ),
                            );
                            final style = context.bodyMedium?.apply(
                                  fontWeightDelta: 2,
                                ) ??
                                const TextStyle();
                            return LineTooltipItem(
                              '$formatted\n',
                              style,
                              children: [
                                TextSpan(
                                  text: formatValue(
                                    value: flSpot.y,
                                    currency: _service.currency,
                                  ),
                                  style: style,
                                ),
                              ],
                              textAlign: TextAlign.center,
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
