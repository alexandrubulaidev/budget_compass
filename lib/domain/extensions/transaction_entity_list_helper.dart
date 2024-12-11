// ignore_for_file: use_to_and_as_if_applicable

import 'package:list_ext/list_ext.dart';

import '../../data/entities/transaction_entity.dart';
import '../model/transaction_filter.dart';

extension GroupByTransactionEntities on List<TransactionEntity> {
  List<TransactionEntity> groupByTags() {
    final groupedMap = <String, TransactionEntity>{};

    for (final transactionEntity in this) {
      final name = transactionEntity.tagName;
      final existing = groupedMap[name];
      if (existing == null) {
        groupedMap[name] = transactionEntity.copy();
      } else {
        final newTransaction = existing.copyWith(
          value: existing.value + transactionEntity.value,
          parentIcon: transactionEntity.parentIcon,
          parentColor: transactionEntity.parentColor,
          parentTagName: transactionEntity.parentTagName,
        );
        groupedMap[name] = newTransaction;
      }
    }

    return groupedMap.values.toList();
  }
}

extension TransactionEntityListFilter on List<TransactionEntity> {
  List<TransactionEntity> filter(final TransactionFilter filter) {
    var results = copy();
    if (filter.tags.isNotEmpty) {
      results = results
          .where(
            (final element) =>
                filter.tags.contains(element.tagName) ||
                filter.tags.contains(element.parentTagName),
          )
          .toList();
    }
    if (filter.labels.isNotEmpty) {
      results = results
          .where(
            (final element) => filter.labels
                .toSet()
                .intersection(element.labels.toSet())
                .isNotEmpty,
          )
          .toList();
    }
    final text = filter.text?.toLowerCase();
    if (text != null && text.isNotEmpty) {
      results = results.where((final element) {
        if (element.parentTagName.toString().contains(text)) {
          return true;
        }
        if (element.value.toString().contains(text)) {
          return true;
        }
        if (element.title.toLowerCase().contains(text)) {
          return true;
        }
        if (element.description?.toLowerCase().contains(text) ?? false) {
          return true;
        }
        if (element.tagName.toLowerCase().contains(text)) {
          return true;
        }
        if (element.labels.firstWhereOrNull((final element) {
              return element.toLowerCase().contains(text);
            }) !=
            null) {
          return true;
        }
        return false;
      }).toList();
    }
    return results;
  }
}
