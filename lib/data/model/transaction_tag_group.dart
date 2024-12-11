import 'package:isar/isar.dart';

part 'transaction_tag_group.g.dart';

@collection
class TransactionTagGroup {
  TransactionTagGroup({
    required this.parent,
    required this.children,
    this.id = Isar.autoIncrement,
  });

  final Id id;
  @Index(unique: true)
  final String parent;
  final List<String> children;

  TransactionTagGroup copyWith({
    final Id? id,
    final String? parent,
    final List<String>? children,
  }) {
    return TransactionTagGroup(
      id: id ?? this.id,
      parent: parent ?? this.parent,
      children: children ?? this.children,
    );
  }
}
