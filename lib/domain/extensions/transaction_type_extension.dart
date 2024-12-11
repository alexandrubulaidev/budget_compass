import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/model/transaction_type.dart';
import '../../utils/app_localizations.dart';

extension TransactionTypeExtension on TransactionType {
  String get userString {
    switch (this) {
      case TransactionType.expense:
        return 'Expense'.localized;
      case TransactionType.income:
        return 'Income'.localized;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionType.expense:
        return FontAwesomeIcons.minus;
      case TransactionType.income:
        return FontAwesomeIcons.plus;
    }
  }

  Color get color {
    switch (this) {
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.income:
        return Colors.greenAccent.shade700;
    }
  }
}
