import 'dart:async';

import 'package:multiple_result/multiple_result.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/entities/tag_entity.dart';
import '../../data/entities/tag_group_entity.dart';
import '../../data/error/app_error.dart';
import '../../data/model/transaction_label.dart';
import '../../data/model/transaction_tag_group.dart';
import '../../data/model/user.dart';
import '../../data/repository/wallet/wallet_repository.dart';
import '../../data/repository/wallet/wallet_repository_impl.dart';
import '../services.dart';
import 'wallet_service.dart';

class TagsService implements BaseService {
  TagsService({
    required final User user,
  }) : _repository = WalletRepositoryImpl(user: user) {
    unawaited(_init());
  }

  final WalletRepository _repository;

  // transaction tags
  List<TagEntity> get tags => _tags.value.copy();
  Stream<List<TagEntity>> get tagsStream => _tags.stream;
  final _tags = BehaviorSubject<List<TagEntity>>.seeded([]);

  // transaction labels
  List<TransactionLabel> get labels => _labels.value.copy();
  Stream<List<TransactionLabel>> get labelsStream => _labels.stream;
  final _labels = BehaviorSubject<List<TransactionLabel>>.seeded([]);

  // transaction tag groups
  List<TagGroupEntity> get groups => _groups.value.copy();
  Stream<List<TagGroupEntity>> get groupsStream => _groups.stream;
  final _groups = BehaviorSubject<List<TagGroupEntity>>.seeded([]);

  // session update

  Future<void> _init() async {
    await refreshTags();
    await refreshTagGroups();
    await refreshLabels();
  }

  @override
  void onDispose() {
    unawaited(_tags.close());
    unawaited(_labels.close());
    unawaited(_groups.close());
  }

  // =======================================
  // ============ TAGS CONTROL =============
  // =======================================

  /// Adds new [tag], and that's it
  Future<Result<TagEntity, AppError>> addTransactionTag({
    required final TagEntity tag,
  }) async {
    final result = await _repository.saveTransactionTag(
      tag: tag,
    );
    final newTag = result.tryGetSuccess();
    if (newTag != null) {
      _tags.value = [..._tags.value, newTag];
    }
    return result;
  }

  /// Fetch tags and notify observers
  Future<void> refreshTags() async {
    _tags.value = await _repository.getTransactionTags();
  }

  Future<AppError?> deleteTag({
    required final int id,
  }) async {
    final result = await _repository.deleteTransactionTag(
      id: id,
    );
    await refreshTags();
    await refreshTagGroups();

    // on delete we need to refresh transactions
    unawaited(
      Services.tryGet<WalletService>()?.refreshTransactions(),
    );

    return result;
  }

  // =======================================
  // =========== GROUPS CONTROL ============
  // =======================================

  /// Fetch groups and notify observers
  Future<void> refreshTagGroups() async {
    _groups.value = await _repository.getTransactionTagGroups();
  }

  Future<AppError?> updateTagGroup({
    required final TagGroupEntity group,
    final String? parent,
    final List<String>? children,
  }) async {
    final result = await _repository.updateTagGroup(
      id: group.id,
      parent: parent,
      children: children,
    );
    await refreshTagGroups();

    // on delete we need to refresh transactions
    unawaited(
      Services.tryGet<WalletService>()?.refreshTransactions(),
    );

    return result;
  }

  Future<AppError?> deleteTagGroup({
    required final TagGroupEntity group,
  }) async {
    final result = await _repository.deleteTagGroup(id: group.id);
    await refreshTagGroups();

    return result;
  }

  Future<AppError?> createTagGroup({
    required final TransactionTagGroup group,
  }) async {
    final result = await _repository.saveTagGroup(
      group: group,
    );
    await refreshTagGroups();

    // on delete we need to refresh transactions
    unawaited(
      Services.tryGet<WalletService>()?.refreshTransactions(),
    );

    return result;
  }

  // List<String> tagExclusionGroupEdit({
  //   final int? groupId,
  // }) {
  //   final exclusion = <String>[];
  //   for (final group in collection) {
  //     if (groupId != null && )
  //   }
  // }

  List<String> groupExclusionForCreation() {
    final exclusion = <String>[];
    for (final group in groups) {
      exclusion.add(group.parent.name);
      exclusion.addAll(group.children.map((final e) => e.name));
    }
    return exclusion.toSet().toList();
  }

  // =======================================
  // =========== LABELS CONTROL ============
  // =======================================

  /// Fetch groups and notify observers
  Future<void> refreshLabels() async {
    _labels.value = await _repository.getTransactionLabels();
  }

  Future<Result<TransactionLabel, AppError>> createLabel({
    required final TransactionLabel label,
  }) async {
    final result = await _repository.saveTransactionLabel(
      label: label,
    );
    await refreshLabels();

    return result;
  }

  Future<AppError?> deleteLabel({
    required final int id,
  }) async {
    final result = await _repository.deleteTransactionLabel(
      id: id,
    );
    await refreshLabels();

    // on delete we need to refresh transactions
    unawaited(
      Services.tryGet<WalletService>()?.refreshTransactions(),
    );

    return result;
  }
}
