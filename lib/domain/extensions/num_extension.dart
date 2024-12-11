import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../application.dart';
import '../../data/model/transaction_type.dart';
import '../../presentation/widgets/keyboard/widgets/biz_keyboard_key.dart';
import 'transaction_type_extension.dart';

extension NumExtension on num {
  Color get valueColor {
    if (this < 0) {
      return TransactionType.expense.color;
    } else {
      return TransactionType.income.color;
    }
  }

  IconData get trendIcon {
    if (this < 0) {
      return FontAwesomeIcons.arrowTrendDown;
    } else {
      return FontAwesomeIcons.arrowTrendUp;
    }
  }

  IconData get valueIcon {
    if (this < 0) {
      return FontAwesomeIcons.downLong;
    } else {
      return FontAwesomeIcons.upLong;
    }
  }

  List<BizKeyboardKey> get keys {
    return toStringAsFixed(Application.decimals)
        .characters
        .map(BizKeyboardKeyExtension.fromString)
        .where((final element) => element != null)
        .cast<BizKeyboardKey>()
        .toList();
  }
}
