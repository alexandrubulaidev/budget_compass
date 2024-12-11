// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/entities/tag_entity.dart';
import '../../../../domain/services.dart';
import '../../../../utils/app_localizations.dart';
import '../../../app_theme.dart';
import '../../../dialog/delete_tag_dialog.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/ink_tap.dart';
import '../../../widgets/base/rx_builder.dart';
import '../../../widgets/tags/tag_toggle_widget.dart';
import '../../../widgets/tags/transaction_tag_icon.dart';
import '../../transaction_tags/transaction_tags_screen.dart';
import '../add_transaction_screen_controller.dart';
import '../model/selectable_tag_entity.dart';

class TransactionTagsSegment extends StatelessWidget {
  TransactionTagsSegment({
    super.key,
  });

  final _controller = Services.get<AddTransactionScreenController>();

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

  Future<void> _selectTags(final BuildContext context) async {
    final results = await Navigator.of(context).push<List<String>?>(
      MaterialPageRoute(
        builder: (final context) {
          return TransactionTagsScreen(
            type: _controller.transactionType,
            selected: _controller.tags
                .where((final element) => element.selected)
                .map((final element) => element.name)
                .toList(),
          );
        },
      ),
    );
    if (results != null && results.isNotEmpty) {
      _controller.toggleTag(
        name: results.first,
        sort: true,
        selected: true,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return RxBuilder<List<SelectableTagEntity>>(
      subject: _controller.tagsStream,
      builder: (final context, final tags) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          spacing: 8,
          children: [
            for (final tag in tags.sublist(0, min(6, tags.length))) ...[
              TagToggleWidget(
                iconSize: 15,
                color: tag.color,
                name: tag.name,
                icon: tag.icon,
                selected: tag.selected,
                onTap: () {
                  _controller.toggleTag(
                    name: tag.name,
                    sort: false,
                  );
                },
                onLongTap: () async {
                  await _deleteTag(
                    tag: tag,
                    context: context,
                  );
                },
              ),
            ],
            InkTap(
              onTap: () {
                unawaited(_selectTags(context));
              },
              borderRadius: BorderRadius.circular(kBorderRadius),
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Other'.localized,
                      style: context.bodyLarge,
                    ),
                    const SizedBox(width: 10),
                    const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
