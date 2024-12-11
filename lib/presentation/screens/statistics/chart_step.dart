import 'package:intl/intl.dart';

enum ChartDateStep {
  fourHours,
  oneDay,
  twoDays,
  month,
  year,
}

extension StepFormatter on ChartDateStep {
  String formatTimestamp(final num timestamp) {
    switch (this) {
      case ChartDateStep.fourHours:
        return DateFormat.Hm().format(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.toInt(),
          ),
        );
      case ChartDateStep.oneDay:
      case ChartDateStep.twoDays:
        return DateFormat.MMMd().format(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.toInt(),
          ),
        );
      case ChartDateStep.month:
        return DateFormat.MMM().format(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.toInt(),
          ),
        );
      case ChartDateStep.year:
        return DateFormat.y().format(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.toInt(),
          ),
        );
    }
  }
}
