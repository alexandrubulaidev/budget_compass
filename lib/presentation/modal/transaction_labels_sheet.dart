import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/model/transaction_label.dart';
import '../../domain/services.dart';
import '../../domain/wallet/tags_service.dart';
import '../../utils/app_localizations.dart';
import '../app_theme.dart';
import '../dialog/base/simple_dialog_helpers.dart';
import '../dialog/delete_label_dialog.dart';
import '../extensions/context_extension.dart';
import '../widgets/base/biz_input_field.dart';
import '../widgets/tags/tag_toggle_widget.dart';

void showTransactionLabelsSheet({
  required final BuildContext context,
  final List<TransactionLabel>? labels,
  final List<String>? selected,
  final void Function(TransactionLabel label)? onSelect,
}) {
  unawaited(
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true,
      context: context,
      builder: (final context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 8,
              ),
              child: SelectableLabelsWidget(
                labels: labels,
                selected: selected,
                onSelect: onSelect,
              ),
            ),
          ),
        );
      },
    ),
  );
}

class SelectableLabelsWidget extends StatefulWidget {
  const SelectableLabelsWidget({
    this.labels,
    this.selected,
    this.onSelect,
    super.key,
  });

  final List<TransactionLabel>? labels;
  final List<String>? selected;
  final void Function(TransactionLabel label)? onSelect;

  @override
  State<SelectableLabelsWidget> createState() => _SelectableLabelsWidgetState();
}

class _SelectableLabelsWidgetState extends State<SelectableLabelsWidget> {
  final List<TransactionLabel> _labels = [];
  final List<String> _selected = [];

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSaveButton = false;

  final _service = Services.get<TagsService>();

  @override
  void initState() {
    super.initState();
    // init data
    _labels.addAll(widget.labels ?? _service.labels);
    _selected.addAll(widget.selected ?? []);
    // text listener
    _controller.addListener(() {
      setState(() {
        _showSaveButton = _controller.text != '';
      });
    });
  }

  Future<void> _addLabel({
    required final BuildContext context,
    required final String text,
  }) async {
    final result = await _service.createLabel(
      label: TransactionLabel(
        name: text,
      ),
    );
    result.when((final success) {
      _labels.add(success);
      Future<void>.delayed(const Duration(milliseconds: 100), () {
        _labelSelected(
          context: context,
          label: success,
        );
      });
      _controller.text = '';
    }, (final error) {
      showErrorDialog(
        context: context,
        message: error.message,
      );
    });
  }

  Future<void> _removeLabel({
    required final BuildContext context,
    required final TransactionLabel label,
  }) async {
    _focusNode.unfocus();
    final success = await showDeleteLabelDialog(
      context: context,
      id: label.id,
    );
    if (success) {
      _labels.remove(label);
      setState(() {});
    }
  }

  void _labelSelected({
    required final BuildContext context,
    required final TransactionLabel label,
  }) {
    if (widget.onSelect != null) {
      if (_selected.contains(label.name)) {
        _selected.remove(label.name);
      } else {
        _selected.add(label.name);
      }
      widget.onSelect?.call(label);
    }
    setState(() {});
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kVerticalPadding,
          horizontal: kHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    widget.onSelect == null
                        ? 'Your transaction labels'.localized
                        : 'Tag this transaction with one or more labels'
                            .localized,
                    style: context.titleMedium?.apply(
                      color: context.hintColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Long press to delete any labels'.localized,
                    style: context.bodySmall?.apply(
                      color: context.hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    top: 5,
                  ),
                  child: Wrap(
                    spacing: kHorizontalPadding / 2,
                    runSpacing: kHorizontalPadding / 2,
                    children: <Widget>[
                      for (final label in _labels) ...[
                        TagToggleWidget(
                          selected: _selected.contains(label.name),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 5,
                          ),
                          onTap: () {
                            _labelSelected(
                              context: context,
                              label: label,
                            );
                          },
                          onLongTap: () {
                            unawaited(
                              _removeLabel(
                                context: context,
                                label: label,
                              ),
                            );
                          },
                          icon: FontAwesomeIcons.hashtag,
                          name: label.name,
                          color: context.hintColor,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(
                  height: kVerticalPadding,
                ),
                Divider(
                  color: context.hintColor.withAlpha(25),
                ),
                const SizedBox(
                  height: kVerticalPadding,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: BizInputField(
                    focusNode: _focusNode,
                    controller: _controller,
                    label: 'Type a new label'.localized,
                  ),
                ),
                if (_showSaveButton)
                  TextButton(
                    onPressed: () {
                      unawaited(
                        _addLabel(
                          context: context,
                          text: _controller.text,
                        ),
                      );
                    },
                    child: Text(
                      'SAVE'.localized,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
