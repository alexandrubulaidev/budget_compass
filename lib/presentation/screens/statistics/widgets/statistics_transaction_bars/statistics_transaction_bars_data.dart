import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../data/entities/transaction_entity.dart';
import '../../../../../data/model/transaction_type.dart';
import '../../../../../domain/model/transaction_range.dart';
import '../../chart_step.dart';

class StatisticsTransactionBarsData {
  StatisticsTransactionBarsData({
    required this.transactions,
    required this.range,
    this.context,
  }) {
    _calculate();
  }

  final List<TransactionEntity> transactions;
  final TransactionRange range;
  final BuildContext? context;

  final titles = <String>[];
  final rawData = <(double, double)>[];

  // double _income = 0;
  // double _expense = 0;

  // double get income => _income;
  // double get expense => _expense;

  double? _minX;
  double? _maxX;
  double? _minY;
  double? _maxY;

  double get minX => _minX ?? 0;
  double get maxX => _maxX ?? 0;
  double get minY => _minY ?? 0;
  double get maxY => _maxY ?? 0;

  double get xRange => (_maxX ?? 0) - (_minX ?? 0);
  double get yRange => (_maxY ?? 0) - (_minY ?? 0);

  void _calculate() {
    final transactions = this.transactions.copy();

    // Sort transactions by date
    transactions.sort((final a, final b) => a.date.compareTo(b.date));

    // start is range.start or first transaction
    final start = range.start ?? transactions.first.date;

    // end is range.end or last transaction
    final end = range.end ?? transactions.last.date;

    // decide on step
    final difference = end.difference(start).inDays;

    var step = ChartDateStepValue(
      count: 1,
      step: ChartDateStep.oneDay,
    );

    // overwrite range for custom types
    // assume a month has 31 days
    if (difference <= 2) {
      step = ChartDateStepValue(
        count: 1,
        step: ChartDateStep.fourHours,
      );
    } else if (difference <= 7) {
      step = ChartDateStepValue(
        count: 1,
        step: ChartDateStep.oneDay,
      );
    } else if (difference <= 14) {
      step = ChartDateStepValue(
        count: 2,
        step: ChartDateStep.oneDay,
      );
    } else if (difference <= 31) {
      step = ChartDateStepValue(
        count: 7,
        step: ChartDateStep.oneDay,
      );
    } else if (difference <= 62) {
      step = ChartDateStepValue(
        count: 14,
        step: ChartDateStep.oneDay,
      );
    } else {
      step = ChartDateStepValue(
        count: difference ~/ 4,
        step: ChartDateStep.oneDay,
      );
    }

    var previous = start;
    var cutoff = start.next(step);

    while (cutoff.millisecondsSinceEpoch <= end.millisecondsSinceEpoch) {
      final processed = <TransactionEntity>[];
      var income = 0.0;
      var expense = 0.0;
      for (final transaction in transactions) {
        if (transaction.date.millisecondsSinceEpoch <
            cutoff.millisecondsSinceEpoch) {
          if (transaction.type == TransactionType.income) {
            income += transaction.value;
          } else {
            expense += transaction.value;
          }
          processed.add(transaction);
        } else {
          break;
        }
      }

      if (_minY == null) {
        _minY = min(income, expense);
      } else {
        _minY = min(_minY ?? 0, min(income, expense));
      }
      if (_maxY == null) {
        _maxY = max(income, expense);
      } else {
        _maxY = max(_maxY ?? 0, max(income, expense));
      }

      rawData.add((income, expense));
      var trueEnd = cutoff.next(step);
      if (trueEnd.millisecondsSinceEpoch > end.millisecondsSinceEpoch) {
        trueEnd = end.subtract(const Duration(milliseconds: 1));
      }
      // titles for bottom chart labels
      final wdf = DateFormat.E();
      final df = DateFormat.d();
      final mdf = DateFormat.Md();
      final hmf = DateFormat.Hm();
      if (difference <= 2) {
        titles.add('${hmf.format(previous)}\n'
            '${hmf.format(trueEnd)}');
      } else if (difference <= 7) {
        titles.add(wdf.format(previous));
      } else if (difference <= 14) {
        titles.add('${df.format(previous)} - '
            '${df.format(trueEnd)}');
      } else if (difference <= 31) {
        titles.add('${df.format(previous)} - '
            '${df.format(trueEnd)}');
      } else if (difference <= 62) {
        titles.add('${mdf.format(previous)} - '
            '${mdf.format(trueEnd)}');
      } else {
        titles.add('${mdf.format(previous)} - '
            '${mdf.format(trueEnd)}');
        // titles.add('Q${rawData.length}');
      }

      previous = cutoff;
      cutoff = cutoff.next(step);
      transactions.removeWhere(processed.contains);
    }
  }
}

class ChartDateStepValue {
  ChartDateStepValue({
    required this.count,
    required this.step,
  });
  final int count;
  final ChartDateStep step;
}

extension ChartDateStepDateExtension on DateTime {
  DateTime next(final ChartDateStepValue value) {
    if (value.step == ChartDateStep.fourHours) {
      return DateTime(
        year,
        month,
        day,
        hour + value.count * 4,
      );
    }
    assert(
      value.step == ChartDateStep.oneDay,
      'ChartDateStepDateExtension ${value.step} not implemented!',
    );
    return DateTime(
      year,
      month,
      day + value.count,
    );
  }
}
