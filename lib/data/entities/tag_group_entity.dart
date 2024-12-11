import 'tag_entity.dart';

class TagGroupEntity {
  TagGroupEntity({
    required this.id,
    required this.parent,
    required this.children,
  });

  final int id;
  final TagEntity parent;
  final List<TagEntity> children;

  TagGroupEntity copy() {
    return TagGroupEntity(
      id: id,
      parent: parent.copy(),
      children: children.copy(),
    );
  }

  TagGroupEntity copyWith({
    final int? id,
    final TagEntity? parent,
    final List<TagEntity>? children,
  }) {
    return TagGroupEntity(
      id: id ?? this.id,
      parent: parent ?? this.parent,
      children: children ?? this.children,
    );
  }
}

extension TagGroupEntityListCopy on List<TagGroupEntity> {
  List<TagGroupEntity> copy() {
    return map((final e) => e.copy()).toList();
  }
}
