// ignore_for_file: unused_import

import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_ext/list_ext.dart';

import '../../../../data/entities/tag_entity.dart';
import '../../../../domain/services.dart';
import '../../../../domain/wallet/tags_service.dart';
import '../../../../utils/app_localizations.dart';
import '../../../app_theme.dart';
import '../../../dialog/base/simple_dialog_helpers.dart';
import '../../../dialog/delete_label_dialog.dart';
import '../../../extensions/context_extension.dart';
import '../../../modal/transaction_labels_sheet.dart';
import '../../../widgets/base/ink_tap.dart';
import '../../../widgets/base/multi_rx_builder.dart';
import '../../../widgets/base/rx_builder.dart';
import '../../../widgets/tags/tag_toggle_widget.dart';
import '../../../widgets/tags/transaction_tag_icon.dart';
import '../../transaction_tags/transaction_tags_screen.dart';
import '../add_transaction_screen_controller.dart';
import '../model/selectable_label.dart';
import '../model/selectable_tag_entity.dart';

class TransactionLabelsSegment extends StatelessWidget {
  TransactionLabelsSegment({
    super.key,
  });

  final _controller = Services.get<AddTransactionScreenController>();

  Future<void> _selectLabel({
    required final BuildContext context,
    required final SelectableLabel label,
  }) async {
    _controller.toggleLabel(
      name: label.name,
      sort: false,
    );
  }

  Future<void> _showLabels({
    required final BuildContext context,
  }) async {
    showTransactionLabelsSheet(
      context: context,
      labels: _controller.rawLabels,
      selected: _controller.labels
          .where((final element) => element.selected)
          .map((final e) => e.name)
          .toList(),
      onSelect: (final label) {
        _controller.toggleLabel(
          name: label.name,
          sort: true,
        );
      },
    );
  }

  Future<void> _deleteLabel({
    required final BuildContext context,
    required final SelectableLabel label,
  }) async {
    await showDeleteLabelDialog(
      context: context,
      id: label.id,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: kVerticalPadding / 2,
        ),
        InkTap(
          onTap: () {
            unawaited(
              _showLabels(
                context: context,
              ),
            );
          },
          borderRadius: BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kVerticalPadding,
              horizontal: kHorizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    FaIcon(
                      FontAwesomeIcons.tag,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Labels'.localized,
                      style: context.bodyLarge,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 15,
                    color: context.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        MultiRxBuilder(
          subjects: [
            _controller.labelsStream,
          ],
          builder: (final context, final _) {
            if (_controller.labels.isEmpty) {
              return Container();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: kHorizontalPadding,
                vertical: 2,
              ),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _controller.labels
                    .map((final label) {
                      return TagToggleWidget(
                        onLongTap: () {
                          unawaited(
                            _deleteLabel(
                              context: context,
                              label: label,
                            ),
                          );
                        },
                        icon: FontAwesomeIcons.hashtag,
                        color: context.hintColor,
                        name: label.name,
                        iconSize: 15,
                        selected: label.selected,
                        onTap: () {
                          unawaited(
                            _selectLabel(
                              context: context,
                              label: label,
                            ),
                          );
                        },
                      );
                    })
                    .cast<Widget>()
                    .intersperse(const SizedBox(width: kHorizontalPadding / 2))
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
