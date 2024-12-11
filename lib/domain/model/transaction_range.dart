import 'package:intl/intl.dart';

import '../../utils/app_localizations.dart';
import 'range_adjustment.dart';
import 'range_type.dart';

class TransactionRange {
  TransactionRange({
    required this.type,
    required this.start,
    required this.end,
    final String? title,
  }) : _title = title;

  final RangeType type;
  final DateTime? start;
  final DateTime? end;
  final String? _title;

  String get title {
    return _title ?? text;
  }

  String get text {
    final start = this.start;
    final end = this.end;
    if (start == null) {
      if (end != null) {
        return 'Before ${DateFormat.yMMMd().format(end)}';
      } else {
        return 'All Time'.localized;
      }
    } else if (end == null) {
      return 'After ${DateFormat.yMMMd().format(start)}';
    } else {
      switch (type) {
        case RangeType.day:
          return DateFormat.yMMMd().format(start);
        case RangeType.week:
          return '${DateFormat.yMMMd().format(start)} - '
              '${DateFormat.yMMMd().format(end)}';
        case RangeType.month:
          return DateFormat.MMMM().format(start);
        case RangeType.year:
          return DateFormat.y().format(start);
        case RangeType.custom:
          return '${DateFormat.yMMMd().format(start)} - '
              '${DateFormat.yMMMd().format(end)}';
        case RangeType.all:
          return 'All Time'.localized;
      }
    }
  }

  TransactionRange adjustedRange({
    required final RangeAdjustment adjustment,
  }) {
    final operation = adjustment == RangeAdjustment.increment ? 1 : -1;

    final type = this.type;
    final start = this.start;
    final end = this.end;
    var days = 0;
    var months = 0;
    var years = 0;

    if (type == RangeType.day) {
      days = 1;
    } else if (type == RangeType.week) {
      days = 7;
    } else if (type == RangeType.month) {
      months = 1;
    } else if (type == RangeType.year) {
      years = 1;
    } else if (type == RangeType.custom) {
      if (end != null && start != null) {
        days = end.difference(start).inDays;
      }
    }

    return TransactionRange(
      type: type,
      start: start == null
          ? null
          : DateTime(
              start.year + years * operation,
              start.month + months * operation,
              start.day + days * operation,
            ),
      end: end == null
          ? null
          : DateTime(
              end.year + years * operation,
              end.month + months * operation,
              end.day + days * operation,
            ),
    );
  }

  TransactionRange next() {
    return adjustedRange(
      adjustment: RangeAdjustment.increment,
    );
  }

  TransactionRange previous() {
    return adjustedRange(
      adjustment: RangeAdjustment.increment,
    );
  }
}
