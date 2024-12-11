// ignore_for_file: prefer_conditional_assignment
// ignore_for_file: inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar/isar.dart';
import 'package:list_ext/list_ext.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../application.dart';

import '../../../domain/extensions/icon_extension.dart';
import '../../../domain/extensions/transaction_tag_extension.dart';
import '../../../domain/services.dart';
import '../../../utils/app_localizations.dart';
import '../../db/quick_store.dart';
import '../../entities/tag_entity.dart';
import '../../entities/tag_group_entity.dart';
import '../../entities/transaction_entity.dart';
import '../../error/app_error.dart';
import '../../model/transaction.dart';
import '../../model/transaction_label.dart';
import '../../model/transaction_tag.dart';
import '../../model/transaction_tag_group.dart';
import '../../model/transaction_type.dart';
import '../../model/user.dart';
import '../../model/wallet.dart';
import 'repository_defaults.dart';
import 'wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl({
    required this.user,
  });

  Isar get database => Services.get<Isar>();

  final User user;
  int get _userId => user.id;

  @override
  Future<Wallet> getSelectedWallet() async {
    Wallet? wallet;
    var walletId = QuickStore.read<int>(kSelectedWallet);
    if (walletId != null) {
      wallet = await database.wallets
          .filter()
          .ownerIdEqualTo(_userId)
          .idEqualTo(walletId)
          .findFirst();
    }
    // just get first wallet
    if (wallet == null) {
      wallet =
          await database.wallets.filter().ownerIdEqualTo(_userId).findFirst();
      walletId = wallet?.id;
    }
    if (wallet == null) {
      final newWallet = dummyWallet().copyWith(
        ownerId: _userId,
      );
      walletId = await database.writeTxn<int>(() {
        return database.wallets.put(newWallet);
      });
      wallet = newWallet.copyWith(
        id: walletId,
      );
    }

    // save as selected
    QuickStore.write(kSelectedWallet, wallet.id);
    return wallet;
  }

  @override
  Future<Result<Wallet, AppError>> createWallet({
    required final Wallet wallet,
  }) async {
    try {
      final walletId = await database.writeTxn<int>(() {
        return database.wallets.put(wallet);
      });
      return Result.success(
        wallet.copyWith(
          id: walletId,
        ),
      );
    } catch (e) {
      return Result.error(UnexpectedError());
    }
  }

  @override
  Future<Wallet?> getWallet({
    required final int walletId,
  }) async {
    return database.wallets
        .filter()
        .ownerIdEqualTo(_userId)
        .idEqualTo(walletId)
        .findFirst();
  }

  @override
  Future<List<Wallet>> getWallets() async {
    return database.wallets.filter().ownerIdEqualTo(_userId).findAll();
  }

  @override
  Future<Result<Transaction, AppError>> saveTransaction({
    required final Transaction transaction,
  }) async {
    final walletId = transaction.walletId;
    final wallet = await database.wallets.get(walletId);
    if (wallet == null) {
      return Result.error(
        AppError(
          message: 'Wallet not found'.localized,
        ),
      );
    }

    // increment tag weight
    final tagName = transaction.tag;
    TransactionTag? tag;
    if (tagName != null) {
      tag = await database.transactionTags
          .filter()
          .nameEqualTo(tagName)
          .findFirst();
      tag = tag?.copyWith(
        weight: tag.weight + 1,
      );
    }

    // increment label weight
    final labelNames = transaction.labels;
    List<TransactionLabel>? labels;
    if (labelNames.isNotEmpty) {
      labels = await database.transactionLabels.filter().anyOf(
        labelNames,
        (final q, final element) {
          return q.nameEqualTo(element, caseSensitive: false);
        },
      ).findAll();
      labels = labels.map((final e) {
        return e.copyWith(weight: e.weight + 1);
      }).toList();
    }

    // save
    await database.writeTxn<void>(() {
      if (tag != null) {
        database.transactionTags.put(tag);
      }
      if (labels != null && labels.isNotEmpty) {
        database.transactionLabels.putAll(labels);
      }
      return database.transactions.put(transaction);
    });

    return Result.success(transaction);
  }

  @override
  Future<AppError?> deleteTransaction({
    required final int transactionId,
  }) async {
    final success = await database.writeTxn<bool>(() {
      return database.transactions.delete(transactionId);
    });

    return success
        ? null
        : AppError(
            message: 'Transaction not found'.localized,
          );
  }

  @override
  Future<List<TagEntity>> getTransactionTags() async {
    // this is a fresh install if it's 0
    if (Application.isFirstRun) {
      try {
        await database.writeTxn<void>(() {
          return database.transactionTags.putAll(defaultTags());
        });
      } catch (e) {}
    }
    final tags =
        await database.transactionTags.filter().nameIsNotEmpty().findAll();

    return tags
        .map(
          (final e) => TagEntity(
            id: e.id,
            name: e.name,
            icon: e.iconData,
            color: Color(e.color),
            weight: e.weight,
            type: e.type,
          ),
        )
        .toList()
      ..sortByDescending((final e) => e.weight);
  }

  @override
  Future<List<TagGroupEntity>> getTransactionTagGroups() async {
    // this is a fresh install if it's 0
    if (Application.isFirstRun) {
      try {
        await database.writeTxn<void>(() {
          return database.transactionTagGroups.putAll(defaultTagGroups());
        });
      } catch (e) {}
    }
    final tags = await getTransactionTags();

    final rawGroups = await database.transactionTagGroups
        .filter()
        .parentIsNotEmpty()
        .findAll();

    final tagGroups = <TagGroupEntity>[];
    for (final group in rawGroups) {
      final tag = tags.firstWhereOrNull(
        (final element) => element.name == group.parent,
      );
      if (tag == null) {
        continue;
      }
      tagGroups.add(
        TagGroupEntity(
          id: group.id,
          parent: tag,
          children: tags.where((final element) {
            return group.children.contains(element.name);
          }).toList(),
        ),
      );
    }

    return tagGroups;
  }

  @override
  Future<Result<TagEntity, AppError>> saveTransactionTag({
    required final TagEntity tag,
  }) async {
    TagEntity? result = tag;
    // I see no reason to have more than 100 tags right now
    if (await database.transactionTags.count() > 100) {
      return Result.error(
        AppError(
          message: 'Hey there! You have to many categories already, '
                  'how about you delete some first?'
              .localized,
        ),
      );
    }
    final existing = await database.transactionTags
        .filter()
        .nameEqualTo(
          tag.name,
          caseSensitive: false,
        )
        .findFirst();

    if (existing == null) {
      try {
        result = result.copyWith(
          id: await database.writeTxn<int>(() {
            return database.transactionTags.put(
              TransactionTag(
                name: tag.name,
                icon: tag.icon?.stringValue ?? '',
                type: tag.type,
                color: tag.color.value,
              ),
            );
          }),
        );
      } catch (e) {
        return Result.error(UnexpectedError());
      }
    } else {
      if (existing.type != null &&
          tag.type != null &&
          tag.type != existing.type) {
        try {
          result = result.copyWith(
            id: await database.writeTxn<int>(() {
              return database.transactionTags.put(
                TransactionTag(
                  id: existing.id,
                  stock: existing.stock,
                  name: existing.name,
                  icon: existing.icon,
                  color: existing.color,
                  weight: existing.weight,
                ),
              );
            }),
          );
        } catch (e) {
          return Result.error(UnexpectedError());
        }
      }
    }

    return Result.success(result);
  }

  @override
  Future<AppError?> deleteTransactionTag({
    required final int id,
  }) async {
    final tag = await database.transactionTags.get(id);
    if (tag == null) {
      return AppError(
        message: 'Cannot delete category. Unexpected Error.'.localized,
      );
    }
    try {
      await database.writeTxn<void>(() {
        return database.transactionTags.delete(id);
      });
    } catch (e) {
      return UnexpectedError();
    }

    // delete tag from transactions

    final transactions = await database.transactions
        .filter()
        .tagEqualTo(tag.name, caseSensitive: false)
        .findAll();

    for (final transaction in transactions) {
      transaction.tag = null;
    }

    try {
      await database.writeTxn(() async {
        return database.transactions.putAll(
          transactions,
        );
      });
    } catch (e) {}

    // delete groups with this parent

    try {
      await database.writeTxn(() async {
        return database.transactionTagGroups
            .filter()
            .parentEqualTo(tag.name, caseSensitive: false)
            .deleteAll();
      });
    } catch (e) {}

    // remove child from groups

    try {
      final existing = await database.transactionTagGroups
          .filter()
          .childrenElementContains(tag.name)
          .findAll();
      for (final group in existing) {
        group.children.remove(tag.name);
      }
      await database.writeTxn(() async {
        return database.transactionTagGroups.putAll(
          existing,
        );
      });
    } catch (e) {}

    return null;
  }

  @override
  Future<List<TransactionEntity>> getTransactions({
    required final int walletId,
    final DateTime? startDate,
    final DateTime? endDate,
    final List<String>? tags,
  }) async {
    final wallet = await database.wallets.get(walletId);
    if (wallet == null) {
      return [];
    }
    var transactions = <Transaction>[];
    var query = database.transactions.filter().walletIdEqualTo(walletId);
    if (startDate != null) {
      query = query.timestampGreaterThan(
        startDate.millisecondsSinceEpoch,
        include: true,
      );
    }
    if (endDate != null) {
      query = query.timestampLessThan(endDate.millisecondsSinceEpoch);
    }
    if (tags != null) {
      query = query.anyOf(
        tags,
        (final q, final element) {
          return q.tagEqualTo(element, caseSensitive: false);
        },
      );
    }
    transactions = await query.sortByTimestampDesc().findAll();

    final dbTags = await getTransactionTags();
    final dbGroups = await getTransactionTagGroups();

    return transactions.map((final transaction) {
      TagEntity? parentTag;
      final tag = dbTags.firstWhereOrNull(
        (final element) => element.name == transaction.tag,
      );
      if (tag != null) {
        final group = dbGroups.firstWhereOrNull((final element) {
          return element.children.map((final e) => e.name).contains(tag.name);
        });
        if (group != null) {
          parentTag = group.parent;
        }
      }
      return TransactionEntity(
        // transaction related
        currency: wallet.currency,
        id: transaction.id,
        walletId: walletId,
        type: transaction.type,
        title: transaction.type.stringValue,
        value: transaction.value,
        description: transaction.description,
        date: DateTime.fromMillisecondsSinceEpoch(transaction.timestamp),
        // tag related
        tagName: tag?.name ?? 'Other',
        icon: tag?.icon ?? FontAwesomeIcons.receipt,
        color: tag?.color ?? Colors.grey.shade300,
        // secondary tag
        parentColor: parentTag?.color,
        parentIcon: parentTag?.icon,
        parentTagName: parentTag?.name,
        labels: transaction.labels,
      );
    }).toList();
  }

  @override
  Future<Wallet> saveWallet(final Wallet wallet) async {
    await database.writeTxn<void>(() {
      return database.wallets.put(wallet);
    });
    return wallet;
  }

  @override
  Future<AppError?> updateTagGroup({
    required final int id,
    final String? parent,
    final List<String>? children,
  }) async {
    // check if there is already a group with this parent
    if (parent != null) {
      final existing = await database.transactionTagGroups
          .filter()
          .idGreaterThan(id)
          .parentEqualTo(parent, caseSensitive: false)
          .findFirst();
      if (existing != null) {
        return AppError(
          message: 'A transaction group under this category already exists.',
        );
      }
    }

    // check if this tag is in someone else's children
    if (parent != null) {
      final existing = await database.transactionTagGroups
          .filter()
          .childrenElementContains(parent)
          .findFirst();
      if (existing != null) {
        return AppError(
          message:
              "Selected grouping category is part of another's subcategory.",
        );
      }
    }

    // check if any of the children are part of any other group children
    if (children != null && children.isNotEmpty) {
      final existing =
          await database.transactionTagGroups.filter().idGreaterThan(id).anyOf(
        children,
        (final q, final element) {
          return q.childrenElementContains(
            element,
            caseSensitive: false,
          );
        },
      ).findFirst();
      if (existing != null) {
        return AppError(
          message: 'One or more of the selected subcategories '
              'are part of another group.',
        );
      }
    }

    final group = await database.transactionTagGroups.get(id);
    if (group == null) {
      return AppError(
        message: 'Transaction group not found.'.localized,
      );
    }

    try {
      await database.writeTxn<void>(() {
        return database.transactionTagGroups.put(
          group.copyWith(
            parent: parent,
            children: children,
          ),
        );
      });
    } catch (e) {
      return UnexpectedError();
    }

    return null;
  }

  @override
  Future<AppError?> deleteTagGroup({
    required final int id,
  }) async {
    try {
      await database.writeTxn<void>(() {
        return database.transactionTagGroups.delete(id);
      });
    } catch (e) {
      return UnexpectedError();
    }

    return null;
  }

  @override
  Future<AppError?> saveTagGroup({
    required final TransactionTagGroup group,
  }) async {
    try {
      await database.writeTxn<void>(() {
        return database.transactionTagGroups.put(group);
      });
    } catch (e) {
      return UnexpectedError();
    }

    return null;
  }

  @override
  Future<List<TransactionLabel>> getTransactionLabels() async {
    // this is a fresh install if it's 0
    if (Application.isFirstRun) {
      try {
        await database.writeTxn<void>(() {
          return database.transactionLabels.putAll(defaultLabels());
        });
      } catch (e) {}
    }
    return database.transactionLabels.filter().nameIsNotEmpty().findAll();
  }

  @override
  Future<Result<TransactionLabel, AppError>> saveTransactionLabel({
    required final TransactionLabel label,
  }) async {
    if (await database.transactionLabels.count() > 100) {
      return Result.error(
        AppError(
          message: 'Hey there! You have to many labels already, '
                  'how about you delete some first?'
              .localized,
        ),
      );
    }
    final existing = await database.transactionLabels
        .filter()
        .nameEqualTo(
          label.name,
          caseSensitive: false,
        )
        .findFirst();

    if (existing != null) {
      return Result.error(
        AppError(
          message:
              'A transaction label with this name already exists'.localized,
        ),
      );
    }

    final id = await database.writeTxn<int>(() {
      return database.transactionLabels.put(
        label,
      );
    });

    return Result.success(
      label.copyWith(
        id: id,
      ),
    );
  }

  @override
  Future<AppError?> deleteTransactionLabel({
    required final int id,
  }) async {
    final label = await database.transactionLabels.get(id);
    if (label == null) {
      return AppError(
        message: 'Cannot delete label. Unexpected Error.'.localized,
      );
    }
    try {
      await database.writeTxn<void>(() {
        return database.transactionLabels.delete(id);
      });
    } catch (e) {
      return UnexpectedError();
    }

    // delete labels from transactions

    final transactions = await database.transactions
        .filter()
        .labelsIsNotEmpty()
        .labelsElementContains(label.name)
        .findAll();

    for (final transaction in transactions) {
      final labels = <String>[...transaction.labels];
      labels.remove(label.name);
      transaction.labels = labels;
    }

    try {
      await database.writeTxn(() async {
        return database.transactions.putAll(
          transactions,
        );
      });
    } catch (e) {
      return UnexpectedError();
    }

    return null;
  }
}
