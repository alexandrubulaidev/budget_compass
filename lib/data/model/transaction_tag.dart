import 'package:isar/isar.dart';

import 'transaction_type.dart';

part 'transaction_tag.g.dart';

@collection
class TransactionTag {
  TransactionTag({
    required this.name,
    required this.icon,
    required this.color,
    this.id = Isar.autoIncrement,
    this.stock = false,
    this.weight = 0,
    this.type,
  });

  final Id id;
  @Index(unique: true)
  final String name;
  final int color;
  final String icon;
  final bool stock;
  final int weight;

  @Enumerated(EnumType.name)
  final TransactionType? type;

  TransactionTag copy() {
    return TransactionTag(
      id: id,
      name: name,
      color: color,
      icon: icon,
      weight: weight,
      type: type,
      stock: stock,
    );
  }

  TransactionTag copyWith({
    final int? id,
    final String? name,
    final int? color,
    final String? icon,
    final int? weight,
    final bool? stock,
    final TransactionType? type,
  }) {
    return TransactionTag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      weight: weight ?? this.weight,
      type: type ?? this.type,
      stock: stock ?? this.stock,
    );
  }
}

extension TransactionTagListCopy on List<TransactionTag> {
  List<TransactionTag> copy() {
    return map((final e) => e.copy()).toList();
  }
}
