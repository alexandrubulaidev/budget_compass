import '../../../../data/entities/tag_entity.dart';

class SelectableTagEntity extends TagEntity {
  SelectableTagEntity({
    required this.selected,
    required super.id,
    required super.name,
    required super.color,
    super.icon,
    super.weight,
    super.type,
  });
  bool selected;
}
