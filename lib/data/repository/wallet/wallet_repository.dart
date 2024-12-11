import 'package:multiple_result/multiple_result.dart';

import '../../entities/tag_entity.dart';
import '../../entities/tag_group_entity.dart';
import '../../entities/transaction_entity.dart';
import '../../error/app_error.dart';
import '../../model/transaction.dart';
import '../../model/transaction_label.dart';
import '../../model/transaction_tag_group.dart';
import '../../model/wallet.dart';

abstract class WalletRepository {
  Future<Wallet> getSelectedWallet();

  Future<Result<Wallet, AppError>> createWallet({
    required final Wallet wallet,
  });

  Future<Wallet?> getWallet({
    required final int walletId,
  });

  Future<List<Wallet>> getWallets();

  Future<Wallet> saveWallet(final Wallet wallet);

  Future<List<TagEntity>> getTransactionTags();

  Future<List<TagGroupEntity>> getTransactionTagGroups();

  Future<Result<TagEntity, AppError>> saveTransactionTag({
    required final TagEntity tag,
  });

  Future<AppError?> deleteTransactionTag({
    required final int id,
  });

  Future<AppError?> deleteTransaction({
    required final int transactionId,
  });

  Future<Result<Transaction, AppError>> saveTransaction({
    required final Transaction transaction,
  });

  Future<List<TransactionEntity>> getTransactions({
    required final int walletId,
    final DateTime? startDate,
    final DateTime? endDate,
    final List<String>? tags,
  });

  Future<AppError?> updateTagGroup({
    required final int id,
    final String? parent,
    final List<String>? children,
  });

  Future<AppError?> deleteTagGroup({
    required final int id,
  });

  Future<AppError?> saveTagGroup({
    required final TransactionTagGroup group,
  });

  Future<List<TransactionLabel>> getTransactionLabels();

  Future<Result<TransactionLabel, AppError>> saveTransactionLabel({
    required final TransactionLabel label,
  });

  Future<AppError?> deleteTransactionLabel({
    required final int id,
  });
}
