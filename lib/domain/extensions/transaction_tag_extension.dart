import 'package:flutter/material.dart';

import '../../data/model/transaction_tag.dart';
import 'icon_extension.dart';

extension TransactionTagIconData on TransactionTag {
  IconData? get iconData => IconDataString.fromString(icon);
}
