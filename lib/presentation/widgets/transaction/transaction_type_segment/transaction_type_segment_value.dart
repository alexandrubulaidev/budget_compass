import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/model/transaction_type.dart';
import '../../../../domain/extensions/transaction_type_extension.dart';
import '../../../../utils/app_localizations.dart';

enum TransactionTypeSegmentValue {
  income,
  expense,
  transfer,
  both,
}

extension TransactionSegmentValueHelper on TransactionTypeSegmentValue {
  String get userString {
    switch (this) {
      case TransactionTypeSegmentValue.expense:
        return TransactionType.expense.userString;
      case TransactionTypeSegmentValue.income:
        return TransactionType.income.userString;
      case TransactionTypeSegmentValue.transfer:
        return 'Transfer'.localized;
      case TransactionTypeSegmentValue.both:
        return 'Both'.localized;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionTypeSegmentValue.expense:
        return TransactionType.expense.icon;
      case TransactionTypeSegmentValue.income:
        return TransactionType.income.icon;
      case TransactionTypeSegmentValue.transfer:
        return FontAwesomeIcons.rightLeft;
      case TransactionTypeSegmentValue.both:
        return FontAwesomeIcons.plusMinus;
    }
  }

  Color get color {
    switch (this) {
      case TransactionTypeSegmentValue.expense:
        return TransactionType.expense.color;
      case TransactionTypeSegmentValue.income:
        return TransactionType.income.color;
      case TransactionTypeSegmentValue.transfer:
        return Colors.yellowAccent.shade700;
      case TransactionTypeSegmentValue.both:
        return Colors.orange;
    }
  }

  TransactionType? get transactionType {
    switch (this) {
      case TransactionTypeSegmentValue.expense:
        return TransactionType.expense;
      case TransactionTypeSegmentValue.income:
        return TransactionType.income;
      case TransactionTypeSegmentValue.transfer:
      case TransactionTypeSegmentValue.both:
        return null;
    }
  }

  static TransactionTypeSegmentValue fromTransactionType(
    final TransactionType? type,
  ) {
    switch (type) {
      case TransactionType.expense:
        return TransactionTypeSegmentValue.expense;
      case TransactionType.income:
        return TransactionTypeSegmentValue.income;
      case null:
        return TransactionTypeSegmentValue.both;
    }
  }
}
