import 'package:isar/isar.dart';

import 'transaction_type.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Transaction({
    required this.walletId,
    required this.value,
    required this.timestamp,
    required this.type,
    required this.updatedAt,
    this.tag,
    this.description,
    this.labels = const [],
  });

  Id id = Isar.autoIncrement;
  int walletId;
  double value;
  int timestamp;

  @Enumerated(EnumType.name)
  TransactionType type;

  String? tag;
  int updatedAt;
  String? description;
  List<String> labels;
}
