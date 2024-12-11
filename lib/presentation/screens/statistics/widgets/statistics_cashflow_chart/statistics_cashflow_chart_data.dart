import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

import '../../../../../data/entities/transaction_entity.dart';
import '../../../../../data/model/transaction_type.dart';
import '../../../../../domain/extensions/date_extension.dart';
import '../../../../../domain/model/transaction_range.dart';
import '../../chart_step.dart';

class StatisticsCashflowChartData {
  StatisticsCashflowChartData({
    required this.transactions,
    required this.range,
    required this.cashflowStart,
  }) {
    calculateCashflowData();
  }

  final List<TransactionEntity> transactions;
  final TransactionRange range;
  final double cashflowStart;

  ChartDateStep _step = ChartDateStep.oneDay;
  ChartDateStep get step => _step;

  final _cashflowData = <FlSpot>[];

  double _income = 0;
  double _expense = 0;
  double _cashflowEnd = 0;

  double get cashflowEnd => _cashflowEnd;
  double get income => _income;
  double get expense => _expense;
  double get balance => _income - _expense;

  // axis data
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
  double? get yInterval {
    if (yRange == 0) {
      return 10;
    }
    return yRange / 4;
  }

  bool get showXStart {
    final range = Duration(milliseconds: xRange.toInt());
    if (range.inDays <= 15) {
      return false;
    }
    return true;
  }

  double? get xInterval {
    if (xRange == 0) {
      return 10;
    }
    return xRange / 4;
  }

  List<FlSpot> get lineData {
    return _cashflowData;
  }

  void calculateCashflowData() {
    if (this.transactions.isEmpty) {
      return;
    }
    final transactions = this.transactions.copy();

    // Sort transactions by date
    transactions.sort((final a, final b) => a.date.compareTo(b.date));

    // timestamps
    // final timestamps = transactions.map(
    //   (final e) => e.date.millisecondsSinceEpoch,
    // );

    // start is range.start or first transaction
    final start = range.start ??
        transactions.first.date.subtract(const Duration(days: 1));
    _minX = start.millisecondsSinceEpoch.toDouble();
    var cutoff = start;

    // end is range.end or last transaction
    final end =
        range.end ?? transactions.last.date.add(const Duration(days: 1));

    // decide on step
    final difference = end.difference(start).inDays;

    // assume a month has 30 days
    if (difference <= 1) {
      // 3 months
      _step = ChartDateStep.fourHours;
    } else if (difference < 30 * 3) {
      // 3 months
      _step = ChartDateStep.oneDay;
    } else if (difference < 30 * 6) {
      // 6 months
      _step = ChartDateStep.twoDays;
    } else if (difference < 30 * 12 * 3) {
      // 3 years
      _step = ChartDateStep.month;
    } else {
      _step = ChartDateStep.year;
    }

    // cashflow start can be != 0
    _cashflowEnd = cashflowStart;

    while (cutoff.millisecondsSinceEpoch < end.millisecondsSinceEpoch) {
      _maxX = cutoff.millisecondsSinceEpoch.toDouble();
      final processed = <TransactionEntity>[];
      for (final transaction in transactions) {
        // Calculate cashflow based on transaction type (income or expense)
        if (transaction.date.millisecondsSinceEpoch <=
            cutoff.millisecondsSinceEpoch) {
          if (transaction.type == TransactionType.income) {
            _cashflowEnd += transaction.value;
            _income += transaction.value;
          } else {
            _cashflowEnd -= transaction.value;
            _expense += transaction.value;
          }
          processed.add(transaction);
        } else {
          break;
        }
      }

      if (_minY == null) {
        _minY = _cashflowEnd;
      } else {
        _minY = min(_minY ?? 0, _cashflowEnd);
      }
      if (_maxY == null) {
        _maxY = _cashflowEnd;
      } else {
        _maxY = max(_maxY ?? 0, _cashflowEnd);
      }

      _cashflowData.add(
        FlSpot(
          cutoff.millisecondsSinceEpoch.toDouble(),
          _cashflowEnd,
        ),
      );
      if (_step == ChartDateStep.fourHours) {
        cutoff = cutoff.nextHour;
      } else {
        cutoff = cutoff.nextDay;
      }
      transactions.removeWhere(processed.contains);
    }

    // if (_minX == _maxX) {
    //   _minX = minX - const Duration(hours: 24).inSeconds;
    //   _maxX = minX + const Duration(hours: 24).inSeconds;
    //   _step = ChartDateStep.oneDay;
    // }
  }
}
