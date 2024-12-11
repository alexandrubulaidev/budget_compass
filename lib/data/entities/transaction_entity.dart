// ignore_for_file: use_to_and_as_if_applicable

import 'package:flutter/material.dart';

import '../model/transaction_type.dart';
import '../model/wallet_currency.dart';

class TransactionEntity {
  TransactionEntity({
    required this.id,
    required this.walletId,
    required this.type,
    required this.title,
    required this.value,
    required this.date,
    required this.currency,
    required this.icon,
    required this.tagName,
    required this.color,
    this.parentIcon,
    this.parentColor,
    this.parentTagName,
    this.description,
    this.labels = const [],
  });

  final int id;
  final int walletId;
  final TransactionType type;
  final String title;
  final String? description;
  final double value;
  final IconData icon;
  final DateTime date;
  final Color color;
  final WalletCurrency currency;
  final String tagName;
  //  the parent tag
  final IconData? parentIcon;
  final Color? parentColor;
  final String? parentTagName;
  // labels array
  final List<String> labels;

  TransactionEntity copy() {
    return TransactionEntity(
      id: id,
      walletId: walletId,
      type: type,
      title: title,
      description: description,
      value: value,
      icon: icon,
      date: date,
      color: color,
      tagName: tagName,
      currency: currency,
      parentColor: parentColor,
      parentIcon: parentIcon,
      parentTagName: parentTagName,
      labels: labels,
    );
  }

  TransactionEntity copyWith({
    final int? id,
    final int? walletId,
    final TransactionType? type,
    final String? title,
    final String? description,
    final double? value,
    final String? name,
    final IconData? icon,
    final DateTime? date,
    final Color? color,
    final String? tagName,
    final WalletCurrency? currency,
    final Color? parentColor,
    final IconData? parentIcon,
    final String? parentTagName,
    final List<String>? labels,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      date: date ?? this.date,
      color: color ?? this.color,
      tagName: tagName ?? this.tagName,
      currency: currency ?? this.currency,
      parentColor: parentColor ?? this.parentColor,
      parentIcon: parentIcon ?? this.parentIcon,
      parentTagName: parentTagName ?? this.parentTagName,
      labels: labels ?? this.labels,
    );
  }
}

extension TransactionEntityListCopy on List<TransactionEntity> {
  List<TransactionEntity> copy() {
    return List<TransactionEntity>.from(this);
  }
}
