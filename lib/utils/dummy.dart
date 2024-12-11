import 'dart:math';

import '../data/model/transaction.dart';
import '../data/model/transaction_type.dart';
import '../domain/extensions/date_extension.dart';
import '../domain/services.dart';
import '../domain/wallet/tags_service.dart';
import '../domain/wallet/wallet_service.dart';

Future<void> generateDummyData() async {
  final transactionDescriptions = [
    'Grocery shopping',
    'Gasoline refill',
    'Restaurant dinner',
    'Online book purchase',
    'Movie ticket',
    'Gym membership',
    'Utility bill payment',
    'Car repair',
    'Rent payment',
    'Coffee shop',
    'Electronics store',
    'Clothing shopping',
    'Taxi ride',
    'Vacation booking',
    'Pharmacy purchase',
    'Haircut appointment',
    'Dentist visit',
    'Home improvement',
    'Online streaming subscription',
    'Medical checkup',
    'School supplies',
    'Pet grooming',
    'Birthday gift',
    'Furniture shopping',
    'Travel expenses',
    'Bank transfer',
    'Home insurance payment',
    'Music concert ticket',
    'Coffee beans purchase',
    'Fitness equipment',
    'Car insurance payment',
    'Tech gadget purchase',
    'Home renovation',
    'Public transportation pass',
    'Movie rental',
    'Charity donation',
    'Magazine subscription',
    'Grocery delivery',
    'Online course fee',
    'Video game purchase',
    'Gift card',
    'Office supplies',
    'Dinner reservation',
    'Home security system',
    'Car wash',
    'Art supplies',
    'Emergency medical expense',
  ];

  final service = Services.get<WalletService>();
  final tagService = Services.get<TagsService>();
  final walletId = service.wallet.id;
  final initial = service.range.start ?? DateTime.now();
  final incomeTags = tagService.tags
      .where(
        (final element) =>
            element.type == TransactionType.income || element.type == null,
      )
      .toList();
  final expenseTags = tagService.tags
      .where(
        (final element) =>
            element.type == TransactionType.expense || element.type == null,
      )
      .toList();
  var date = initial;
  final random = Random(date.millisecondsSinceEpoch);
  while (date.compareTo(initial.add(const Duration(days: 30))) < 0) {
    final type = random.nextInt(2) == 1
        ? TransactionType.income
        : TransactionType.expense;
    final tags = type == TransactionType.income ? incomeTags : expenseTags;
    final tag = tags[random.nextInt(tags.length)];
    final addDescription = random.nextInt(3) == 1;
    await service.saveTransaction(
      transaction: Transaction(
        tag: tag.name,
        walletId: walletId,
        value: random.nextInt(300).toDouble(),
        timestamp: date.millisecondsSinceEpoch,
        type: type,
        updatedAt: date.millisecondsSinceEpoch,
        description: addDescription
            ? transactionDescriptions[
                random.nextInt(transactionDescriptions.length)]
            : null,
      ),
    );
    date = date.nextDay;
  }
}
