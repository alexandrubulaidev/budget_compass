import 'package:isar/isar.dart';

import 'wallet_currency.dart';

part 'wallet.g.dart';

@collection
class Wallet {
  Wallet({
    required this.ownerId,
    required this.name,
    required this.currency,
    required this.updatedAt,
    this.id = Isar.autoIncrement,
    this.balance = 0,
    this.description,
    this.sharedWith = const [],
  });

  final Id id;
  final int ownerId;
  final String name;
  final int updatedAt;
  final double balance;
  final String? description;
  final List<int> sharedWith;

  @Enumerated(EnumType.name)
  final WalletCurrency currency;

  Wallet copyWith({
    final Id? id,
    final int? ownerId,
    final String? name,
    final int? updatedAt,
    final double? balance,
    final String? description,
    final List<int>? sharedWith,
    final WalletCurrency? currency,
  }) {
    return Wallet(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      balance: balance ?? this.balance,
      description: description ?? this.description,
      sharedWith: sharedWith ?? this.sharedWith,
      currency: currency ?? this.currency,
    );
  }
}
