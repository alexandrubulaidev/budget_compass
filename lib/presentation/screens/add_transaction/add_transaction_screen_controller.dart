import 'dart:async';

import 'package:flutter/material.dart';
import 'package:list_ext/list_ext.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/entities/tag_entity.dart';
import '../../../data/entities/transaction_entity.dart';
import '../../../data/error/app_error.dart';
import '../../../data/model/transaction.dart';
import '../../../data/model/transaction_label.dart';
import '../../../data/model/transaction_type.dart';
import '../../../data/model/wallet.dart';
import '../../../domain/services.dart';
import '../../../domain/wallet/tags_service.dart';
import '../../../domain/wallet/wallet_service.dart';
import '../../../utils/app_localizations.dart';
import '../../widgets/keyboard/biz_keyboard_controller.dart';
import '../../widgets/transaction/transaction_type_segment/transaction_type_segment_value.dart';
import 'model/selectable_label.dart';
import 'model/selectable_tag_entity.dart';

class AddTransactionScreenController implements BaseService {
  AddTransactionScreenController({
    this.transaction,
  }) {
    unawaited(_init());
  }

  final TransactionEntity? transaction;

  String get title => transaction == null
      ? 'New Transaction'.localized
      : 'Edit Transaction'.localized;

  // data sources
  WalletService get _service => Services.get<WalletService>();
  Wallet get wallet => _service.wallet;
  TagsService get _tagsService => Services.get<TagsService>();

  // ui controllers
  final keyboardController = BizKeyboardController();
  final notesController = TextEditingController();

  // transaction type
  TransactionTypeSegmentValue get type => _type.value;
  Stream<TransactionTypeSegmentValue> get typeStream => _type.stream;
  final BehaviorSubject<TransactionTypeSegmentValue> _type =
      BehaviorSubject.seeded(TransactionTypeSegmentValue.income);
  TransactionType get transactionType =>
      type.transactionType ?? TransactionType.expense;

  // transaction date
  DateTime get date => _date.value;
  Stream<DateTime> get dateStream => _date.stream;
  final BehaviorSubject<DateTime> _date =
      BehaviorSubject.seeded(DateTime.now());

  // all transaction tags
  final _allTags = <SelectableTagEntity>[];

  // transaction type tags
  List<SelectableTagEntity> get tags => _tags.value;
  Stream<List<SelectableTagEntity>> get tagsStream => _tags.stream;
  final BehaviorSubject<List<SelectableTagEntity>> _tags =
      BehaviorSubject.seeded([]);

  // selected transaction labels
  List<SelectableLabel> get labels => _labels.value;
  Stream<List<SelectableLabel>> get labelsStream => _labels.stream;
  final BehaviorSubject<List<SelectableLabel>> _labels =
      BehaviorSubject.seeded([]);

  List<TransactionLabel> get rawLabels => _tagsService.labels.copy();

  // all wallets used to transfer from a wallet to another
  List<Wallet> get wallets => _service.wallets;
  Stream<List<Wallet>> get walletsStream => _service.walletsStream;

  // disposables
  StreamSubscription<List<TagEntity>>? _tagsSubscription;
  StreamSubscription<List<TransactionLabel>>? _labelsSubscription;

  @override
  void onDispose() {
    notesController.dispose();
    keyboardController.dispose();
    unawaited(_tagsSubscription?.cancel());
    unawaited(_labelsSubscription?.cancel());
    unawaited(_labels.close());
    unawaited(_tags.close());
    unawaited(_date.close());
    unawaited(_type.close());
  }

  Future<void> _init() async {
    // update tags
    _updateTags(_tagsService.tags);
    _tagsSubscription = _tagsService.tagsStream.skip(1).listen((final event) {
      _updateTags(_tagsService.tags);
    });
    // update labels
    _updateLabels(_tagsService.labels);
    _labelsSubscription =
        _tagsService.labelsStream.skip(1).listen((final event) {
      _updateLabels(_tagsService.labels);
    });
    // read provided transaction data and update
    _updateWithTransaction(transaction);
  }

  void _updateWithTransaction(
    final TransactionEntity? transaction,
  ) {
    final existing = transaction;
    if (existing != null) {
      // date
      _date.value = existing.date;
      // type
      updateTransactionType(
        existing.type == TransactionType.income
            ? TransactionTypeSegmentValue.income
            : TransactionTypeSegmentValue.expense,
      );
      // description
      notesController.text = existing.description ?? '';
      // actual value
      keyboardController.setValue(existing.value);
      // tag
      toggleTag(
        name: existing.tagName,
        sort: true,
        selected: true,
      );
      // labels
      toggleLabels(
        names: existing.labels,
        sort: true,
        selected: true,
      );
    }
  }

  // Transaction Type

  void updateTransactionType(final TransactionTypeSegmentValue type) {
    _type.value = type;
    keyboardController.updateTransactionType(
      transactionType,
    );
    _filterTagsForTransactionType();
  }

  // Date

  void incrementDate() {
    _date.value = date.add(const Duration(days: 1));
  }

  void decrementDate() {
    _date.value = date.subtract(const Duration(days: 1));
  }

  void updateDate(final DateTime updated) {
    _date.value = DateTime(
      updated.year,
      updated.month,
      updated.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
    );
  }

  void updateTime(final TimeOfDay updated) {
    _date.value = DateTime(
      date.year,
      date.month,
      date.day,
      updated.hour,
      updated.minute,
      date.second,
      date.millisecond,
    );
  }

  // Tags

  void _updateTags(final List<TagEntity> tags) {
    _allTags.clear();
    _allTags.addAll(
      tags.map(
        (final e) => SelectableTagEntity(
          selected: false,
          id: e.id,
          name: e.name,
          color: e.color,
          weight: e.weight,
          type: e.type,
          icon: e.icon,
        ),
      ),
    );

    _filterTagsForTransactionType();
  }

  void _filterTagsForTransactionType() {
    _tags.value = _allTags
        .where(
          (final element) =>
              element.type == null || element.type == type.transactionType,
        )
        .toList()
      ..sortByDescending((final e) => e.weight)
      ..sortByDescending((final e) => e.selected ? 1 : 0);
  }

  void toggleTag({
    required final String name,
    required final bool sort,
    final bool? selected,
  }) {
    final tags = this.tags;
    for (final tag in tags) {
      if (tag.name == name) {
        tag.selected = selected ?? !tag.selected;
      } else {
        tag.selected = false;
      }
    }
    if (sort) {
      tags.sort((final a, final b) {
        if (a.selected && !b.selected) {
          return -1; // `a` comes before `b`
        } else if (!a.selected && b.selected) {
          return 1; // `b` comes before `a`
        } else {
          return 0; // No change in order
        }
      });
    }
    _tags.value = tags;
  }

  // labels

  void _updateLabels(final List<TransactionLabel> labels) {
    _labels.value = labels.map((final e) {
      return SelectableLabel(
        selected: _labels.value
                .firstWhereOrNull((final element) => element.name == e.name)
                ?.selected ??
            false,
        name: e.name,
        id: e.id,
        weight: e.weight,
      );
    }).toList()
      ..sortByDescending((final e) => e.weight);
  }

  void toggleLabel({
    required final String name,
    required final bool sort,
    final bool? selected,
  }) {
    toggleLabels(
      names: [name],
      sort: sort,
      selected: selected,
    );
  }

  void toggleLabels({
    required final List<String> names,
    required final bool sort,
    final bool? selected,
  }) {
    for (final label in _labels.value) {
      if (names.contains(label.name)) {
        label.selected = selected ?? !label.selected;
      }
    }
    if (sort) {
      _labels.value.sort((final a, final b) => b.selected ? 1 : 0);
    }
    _labels.value = [...labels];
  }

  // Save transaction

  Future<AppError?> saveTransaction() async {
    final value = keyboardController.total;
    if (value == null) {
      return AppError(
        message: 'Invalid transaction value.'.localized,
      );
    }
    if (value <= 0) {
      return AppError(
        message: 'The transaction value must be greater than zero.'.localized,
      );
    }
    final tag = _tags.value.firstWhereOrNull(
      (final element) => element.selected,
    );
    String? text = notesController.text;
    if (text.isEmpty) {
      text = null;
    }
    final transaction = Transaction(
      walletId: wallet.id,
      value: value,
      type: transactionType,
      tag: tag?.name,
      timestamp: date.millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      description: text,
      labels: labels
          .where((final element) => element.selected)
          .map((final e) => e.name)
          .toList(),
    );
    final transactionId = this.transaction?.id;
    if (transactionId != null) {
      transaction.id = transactionId;
    }
    return _service.saveTransaction(
      transaction: transaction,
    );
  }
}
