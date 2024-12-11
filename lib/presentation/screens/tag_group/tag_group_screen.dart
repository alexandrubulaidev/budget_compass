import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_ext/list_ext.dart';

import '../../../data/entities/tag_entity.dart';
import '../../../data/entities/tag_group_entity.dart';
import '../../../data/model/transaction_tag_group.dart';
import '../../../domain/services.dart';
import '../../../domain/wallet/tags_service.dart';
import '../../../utils/app_localizations.dart';
import '../../dialog/base/simple_dialog_helpers.dart';
import '../../dialog/delete_tag_dialog.dart';
import '../../extensions/context_extension.dart';
import '../../widgets/base/rx_builder.dart';
import '../transaction_tags/transaction_tags_screen.dart';
import 'widgets/tag_group_list_item.dart';

class TagGroupScreen extends StatelessWidget {
  const TagGroupScreen({super.key});

  TagsService get service => Services.get<TagsService>();

  Future<void> _addGroup({
    required final BuildContext context,
  }) async {
    String? parent;
    List<String>? children;

    // select parent first
    final exclusion = service.groupExclusionForCreation();
    var results = await context.basicPush<List<String>?>(
      TransactionTagsScreen(
        excluded: exclusion,
        savingMode: true,
        title: 'Select Category'.localized,
      ),
    );
    if (results != null && results.isNotEmpty) {
      parent = results.first;
      exclusion.add(parent);
    } else {
      return;
    }

    // select children
    final tag = service.tags.firstWhereOrNull(
      (final element) => element.name == parent,
    );
    // ignore: use_build_context_synchronously
    results = await context.basicPush<List<String>?>(
      TransactionTagsScreen(
        type: tag?.type,
        excluded: exclusion,
        savingMode: true,
        multiselect: true,
        title: 'Select Subcategories'.localized,
      ),
    );
    if (results != null && results.isNotEmpty) {
      children = results;
    } else {
      return;
    }

    await service.createTagGroup(
      group: TransactionTagGroup(parent: parent, children: children),
    );
  }

  Future<void> _update({
    required final BuildContext context,
    required final TagGroupEntity group,
    final String? parent,
    final List<String>? children,
  }) async {
    final result = await service.updateTagGroup(
      group: group,
      parent: parent,
      children: children,
    );
    if (result != null) {
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          message: result.message,
        );
      }
    }
  }

  Future<void> _delete({
    required final BuildContext context,
    required final TagGroupEntity group,
  }) async {
    final success = await showConfirmationDialog(
      context: context,
      message: 'Are you sure you want to delete this group? '
              'This action is irreversible.'
          .localized,
      confirmTitle: 'Yes'.localized,
      declineTitle: 'Cancel'.localized,
    );
    if (success) {
      final result = await service.deleteTagGroup(
        group: group,
      );
      if (result != null) {
        if (context.mounted) {
          await showErrorDialog(
            context: context,
            message: result.message,
          );
        }
      }
    }
  }

  Future<void> _deleteTag({
    required final BuildContext context,
    required final TagEntity tag,
  }) async {
    final id = tag.id;
    if (id != null) {
      await showDeleteTagDialog(
        context: context,
        id: id,
      );
    }
  }

  Future<void> _parentTapped({
    required final BuildContext context,
    required final TagGroupEntity group,
  }) async {
    final results = await context.basicPush<List<String>?>(
      TransactionTagsScreen(
        type: group.parent.type,
        title: 'Group Category'.localized,
        selected: [group.parent.name],
      ),
    );
    if (results != null && results.isNotEmpty && context.mounted) {
      await _update(
        context: context,
        group: group,
        parent: results.first,
      );
    }
  }

  Future<void> _editChildrenTapped({
    required final BuildContext context,
    required final TagGroupEntity group,
  }) async {
    final results = await context.basicPush<List<String>?>(
      TransactionTagsScreen(
        type: group.parent.type,
        multiselect: true,
        title: 'Edit Subcategories'.localized,
        selected: group.children.map((final e) => e.name).toList(),
      ),
    );
    if (results != null && results.isNotEmpty && context.mounted) {
      await _update(
        context: context,
        group: group,
        children: results,
      );
    }
  }

  Future<void> _childTapped({
    required final BuildContext context,
    required final TagGroupEntity group,
    required final TagEntity child,
  }) async {
    final success = await showConfirmationDialog(
      context: context,
      message: 'Are you sure you want to remove this category from the group?'
          .localized,
      confirmTitle: 'Yes'.localized,
      declineTitle: 'Cancel'.localized,
    );
    if (success && context.mounted) {
      final children = group.children.map((final e) => e.name).toList()
        ..removeWhere((final element) => element == child.name);
      await _update(
        context: context,
        group: group,
        children: children,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subcategories'.localized,
          style: context.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              unawaited(
                _addGroup(context: context),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
          ),
        ],
      ),
      body: RxBuilder(
        subject: service.groupsStream,
        builder: (final context, final value) {
          return ListView.separated(
            itemCount: service.groups.length,
            itemBuilder: (final context, final index) {
              final group = service.groups[index];
              return TagGroupListItem(
                parent: group.parent,
                children: group.children,
                onParentTap: () {
                  unawaited(
                    _parentTapped(
                      context: context,
                      group: group,
                    ),
                  );
                },
                onEditChildrenTap: () {
                  unawaited(
                    _editChildrenTapped(
                      context: context,
                      group: group,
                    ),
                  );
                },
                onChildTapped: (final child) {
                  unawaited(
                    _childTapped(
                      context: context,
                      group: group,
                      child: child,
                    ),
                  );
                },
                onChildLongTapped: (final child) {
                  unawaited(
                    _deleteTag(
                      context: context,
                      tag: child,
                    ),
                  );
                },
                onDelete: () {
                  unawaited(
                    _delete(context: context, group: group),
                  );
                },
              );
            },
            separatorBuilder: (final context, final index) {
              return Container(height: 15);
            },
          );
        },
      ),
    );
  }
}
