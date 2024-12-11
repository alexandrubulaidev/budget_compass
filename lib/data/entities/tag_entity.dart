import 'package:flutter/material.dart';

import '../model/transaction_type.dart';

class TagEntity {
  TagEntity({
    required this.name,
    required this.color,
    this.icon,
    this.weight = 0,
    this.type,
    this.id,
  });

  final int? id;
  final String name;
  final Color color;
  final IconData? icon;
  final int weight;
  final TransactionType? type;

  /// Returns true if tag is for this transaction type OR
  /// if provided type is null. False otherwise
  bool isFor(final TransactionType? type) {
    if (type == null) {
      return true;
    }
    if (this.type == null || this.type == type) {
      return true;
    }
    return false;
  }

  TagEntity copy() {
    return TagEntity(
      id: id,
      name: name,
      color: color,
      icon: icon,
      weight: weight,
      type: type,
    );
  }

  TagEntity copyWith({
    final int? id,
    final String? name,
    final Color? color,
    final IconData? icon,
    final int? weight,
    final bool? selected,
    final TransactionType? type,
  }) {
    return TagEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      weight: weight ?? this.weight,
      type: type ?? this.type,
    );
  }
}

extension TagEntityListCopy on List<TagEntity> {
  List<TagEntity> copy() {
    return map((final e) => e.copy()).toList();
  }
}
