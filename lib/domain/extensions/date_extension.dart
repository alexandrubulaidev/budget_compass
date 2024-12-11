extension DateTimeExtension on DateTime {
  bool get isToday {
    final today = DateTime.now();
    return today.day == day && today.month == month && today.year == year;
  }

  bool get isYesterday {
    return add(const Duration(days: 1)).isToday;
  }

  DateTime get nextHour {
    return DateTime(
      year,
      month,
      day,
      hour + 1,
    );
  }

  DateTime get nextDay {
    return DateTime(
      year,
      month,
      day + 1,
    );
  }

  DateTime get afterTwoDays {
    return DateTime(
      year,
      month,
      day + 2,
    );
  }

  DateTime get nextMonth {
    return DateTime(
      year,
      month + 1,
    );
  }

  DateTime get nextYear {
    return DateTime(
      year + 1,
    );
  }
}
