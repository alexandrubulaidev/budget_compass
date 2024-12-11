import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/entities/transaction_entity.dart';
import '../../data/error/app_error.dart';
import '../../data/model/transaction.dart';
import '../../data/model/transaction_type.dart';
import '../../data/model/user.dart';
import '../../data/model/wallet.dart';
import '../../data/model/wallet_currency.dart';
import '../../data/repository/wallet/repository_defaults.dart';
import '../../data/repository/wallet/wallet_repository.dart';
import '../../data/repository/wallet/wallet_repository_impl.dart';
import '../extensions/transaction_entity_list_helper.dart';
import '../model/range_adjustment.dart';
import '../model/range_type.dart';
import '../model/transaction_filter.dart';
import '../model/transaction_range.dart';
import '../services.dart';
import 'tags_service.dart';

class WalletService implements BaseService {
  WalletService({
    required this.user,
  }) : _repository = WalletRepositoryImpl(user: user) {
    unawaited(_init());
  }

  final User user;
  final WalletRepository _repository;
  WalletRepository get repository => _repository;

  WalletCurrency get currency => wallet.currency;

  // User can have only one selected wallet at a time within the app
  final BehaviorSubject<Wallet> _wallet = BehaviorSubject.seeded(dummyWallet());
  Stream<Wallet> get walletStream => _wallet.stream;
  Wallet get wallet => _wallet.value;

  // Range for transactions for the session
  final BehaviorSubject<TransactionRange> _range = BehaviorSubject.seeded(
    TransactionRange(
      type: RangeType.all,
      start: null,
      end: null,
    ),
  );
  Stream<TransactionRange> get rangeStream => _range.stream;
  TransactionRange get range => _range.value;

  // Original transactions
  final _originalTransactions = <TransactionEntity>[];

  // Curated transactions
  List<TransactionEntity> get transactions => _transactions.value.copy();
  Stream<List<TransactionEntity>> get transactionsStream =>
      _transactions.stream;
  final _transactions = BehaviorSubject<List<TransactionEntity>>.seeded([]);

  // Cashflow start - based on current range
  double get cashflowStart => _cashflowStart.value;
  Stream<double> get cashflowStartStream => _cashflowStart.stream;
  final _cashflowStart = BehaviorSubject<double>.seeded(0);

  // all user's wallets (and maybe shared ones? TODO)
  List<Wallet> get wallets => _wallets.value;
  Stream<List<Wallet>> get walletsStream => _wallets.stream;
  final BehaviorSubject<List<Wallet>> _wallets = BehaviorSubject.seeded([]);

  // filter transactions - applied locally
  TransactionFilter get filter => _filter.value;
  Stream<TransactionFilter> get filterStream => _filter.stream;
  final BehaviorSubject<TransactionFilter> _filter =
      BehaviorSubject.seeded(TransactionFilter(tags: []));

  @override
  void onDispose() {
    unawaited(_filter.close());
    unawaited(_wallets.close());
    unawaited(_cashflowStart.close());
    unawaited(_transactions.close());
    unawaited(_range.close());
    unawaited(_wallet.close());
  }

  // session update

  Future<void> _init() async {
    await setWallet(await _repository.getSelectedWallet());
    await refreshWallets();
  }

  // ==================================
  // ========= WALLET CONTROL =========
  // ==================================

  /// Specify [swap] to swap to the newly crated wallet
  Future<Result<Wallet, AppError>> createWallet({
    required final String name,
    required final bool swap,
  }) async {
    final result = await repository.createWallet(
      wallet: Wallet(
        ownerId: user.id,
        name: name,
        currency: currency,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    await result.when((final wallet) async {
      Fimber.d(
        "Wallet '${_wallet.value.name}' "
        '(${wallet.id}) created',
      );
      await refreshWallets();
      await setWallet(wallet);
    }, (final error) {
      Fimber.d(
        "Can't create wallet $name "
        "'${error.message}'",
      );
    });

    return result;
  }

  Future<void> setWallet(final Wallet wallet) async {
    Fimber.d(
      'Wallet changed from '
      '${_wallet.value.name} (${_wallet.value.id}) to '
      '${wallet.name} (${wallet.id})',
    );
    _wallet.value = wallet;
    _transactions.value = [];
    await refreshTransactions();
    await _recalculateCashflowStart();
  }

  Future<void> refreshWallets() async {
    _wallets.value = await _repository.getWallets();
  }

  Future<void> updateCurrency(final WalletCurrency currency) async {
    _wallet.value = await _repository.saveWallet(
      wallet.copyWith(currency: currency),
    );
    _transactions.value = _transactions.value
        .map((final e) => e.copyWith(currency: currency))
        .toList();
  }

  // =================================
  // ========= RANGE CONTROL =========
  // =================================

  /// Set the current viewable range.
  /// Can be predefined (day,week,month) or custom
  void updateRange(final TransactionRange range) {
    _range.value = range;
    unawaited(refreshTransactions());
    unawaited(_recalculateCashflowStart());
  }

  /// Increments of decrements the current selected range
  void adjustRange({
    required final RangeAdjustment adjustment,
  }) {
    _range.value = range.adjustedRange(
      adjustment: adjustment,
    );

    unawaited(refreshTransactions());
    unawaited(_recalculateCashflowStart());
  }

  // =======================================
  // ========= TRANSACTION CONTROL =========
  // =======================================

  /// Add new [transaction] OR update existing one, will refresh transactions
  /// for selected range and cashflow start if  transaction.date < range.start
  Future<AppError?> saveTransaction({
    required final Transaction transaction,
  }) async {
    final result = await _repository.saveTransaction(transaction: transaction);
    unawaited(refreshTransactions());
    unawaited(Services.get<TagsService>().refreshTags());
    unawaited(Services.get<TagsService>().refreshLabels());
    final rangeStart = range.start?.millisecondsSinceEpoch;
    if (rangeStart == null || transaction.timestamp < rangeStart) {
      unawaited(_recalculateCashflowStart());
    }
    return result.when<AppError?>(
      (final success) => null,
      (final error) => error,
    );
  }

  /// Simply deletes existing [transaction]
  Future<AppError?> deleteTransaction({
    required final TransactionEntity transaction,
  }) async {
    final result = await _repository.deleteTransaction(
      transactionId: transaction.id,
    );
    if (result == null) {
      unawaited(refreshTransactions());
      final rangeStart = range.start?.millisecondsSinceEpoch;
      if (rangeStart == null ||
          transaction.date.millisecondsSinceEpoch < rangeStart) {
        unawaited(_recalculateCashflowStart());
      }
    }
    return result;
  }

  /// Fetches transactions for selected range
  Future<void> refreshTransactions() async {
    _originalTransactions.clear();
    _originalTransactions.addAll(
      await _repository.getTransactions(
        walletId: wallet.id,
        startDate: range.start,
        endDate: range.end,
      ),
    );
    _transactions.value = _originalTransactions.filter(filter);
  }

  Future<void> _recalculateCashflowStart() async {
    final rangeStart = range.start?.millisecondsSinceEpoch;
    if (rangeStart == null) {
      _cashflowStart.value = 0;
    } else {
      final transactions = await _repository.getTransactions(
        walletId: wallet.id,
        endDate: DateTime.fromMillisecondsSinceEpoch(rangeStart),
      );
      if (transactions.isEmpty) {
        _cashflowStart.value = 0;
      } else {
        _cashflowStart.value = transactions.map((final element) {
          if (element.type == TransactionType.income) {
            return element.value;
          } else {
            return -element.value;
          }
        }).reduce((final value, final element) {
          return value + element;
        });
      }
    }
    Fimber.d('Cashflow start is $cashflowStart');
  }

  // =======================================
  // =========== FILTER CONTROL ============
  // =======================================

  void updateFilter(final TransactionFilter filter) {
    _filter.value = filter;
    _transactions.value = _originalTransactions.filter(filter);
  }

  void search(final String? text) {
    if (text != _filter.value.text) {
      _filter.value = TransactionFilter(
        tags: _filter.value.tags,
        labels: _filter.value.labels,
        text: text,
      );
      _transactions.value = _originalTransactions.filter(filter);
    }
  }
}
