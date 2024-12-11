import '../../utils/app_localizations.dart';

enum RangeType {
  day,
  week,
  month,
  year,
  custom,
  all,
}

extension RangeTypeExtension on RangeType {
  String get text {
    switch (this) {
      case RangeType.day:
        return 'Today'.localized;
      case RangeType.week:
        return 'This Week'.localized;
      case RangeType.month:
        return 'This Month'.localized;
      case RangeType.year:
        return 'This Year'.localized;
      case RangeType.custom:
        return 'Custom Range'.localized;
      case RangeType.all:
        return 'All Time'.localized;
    }
  }

  DateTime? get startDate {
    final date = DateTime.now();
    final days = date.weekday == 7 ? 0 : date.weekday;

    switch (this) {
      case RangeType.day:
        return DateTime(
          date.year,
          date.month,
          date.day,
        );
      case RangeType.week:
        return DateTime(
          date.year,
          date.month,
          date.day,
        ).subtract(Duration(days: days));
      case RangeType.month:
        return DateTime(
          date.year,
          date.month,
        );
      case RangeType.year:
        return DateTime(
          date.year,
        );
      case RangeType.custom:
        return null;
      case RangeType.all:
        return null;
    }
  }

  DateTime? get endDate {
    final date = DateTime.now();
    final days = date.weekday == 7 ? 0 : date.weekday;

    switch (this) {
      case RangeType.day:
        return DateTime(
          date.year,
          date.month,
          date.day,
        ).add(const Duration(days: 1));
      case RangeType.week:
        return DateTime(
          date.year,
          date.month,
          date.day,
        ).add(Duration(days: DateTime.daysPerWeek - days));
      case RangeType.month:
        return DateTime(
          date.year,
          date.month + 1,
        );
      case RangeType.year:
        return DateTime(
          date.year + 1,
        );
      case RangeType.custom:
        return null;
      case RangeType.all:
        return null;
    }
  }
}
