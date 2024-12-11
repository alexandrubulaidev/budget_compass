import 'package:list_ext/list_ext.dart';

enum TransactionType {
  expense,
  income,
}

extension TransactionTypeStrings on TransactionType {
  String get stringValue => toString().split('.').last;

  static TransactionType? fromString(final String? string) =>
      TransactionType.values.firstWhereOrNull(
        (final element) =>
            element.stringValue.toLowerCase() == string?.toLowerCase(),
      );
}
