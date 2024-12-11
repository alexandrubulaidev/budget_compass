import 'package:isar/isar.dart';

part 'transaction_label.g.dart';

@collection
class TransactionLabel {
  TransactionLabel({
    required this.name,
    this.weight = 0,
    this.id = Isar.autoIncrement,
  });

  final Id id;
  @Index(unique: true)
  final String name;
  final int weight;

  TransactionLabel copy() {
    return TransactionLabel(
      name: name,
      id: id,
      weight: weight,
    );
  }

  TransactionLabel copyWith({
    final int? id,
    final String? name,
    final int? weight,
  }) {
    return TransactionLabel(
      name: name ?? this.name,
      id: id ?? this.id,
      weight: weight ?? this.weight,
    );
  }
}

extension TransactionLabelListCopy on List<TransactionLabel> {
  List<TransactionLabel> copy() {
    return map((final e) => e.copy()).toList();
  }
}
