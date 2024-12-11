import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../data/entities/tag_entity.dart';
import '../../data/model/transaction_label.dart';
import '../../domain/model/transaction_filter.dart';
import '../../domain/services.dart';
import '../../domain/wallet/tags_service.dart';
import '../app_theme.dart';
import '../extensions/context_extension.dart';
import '../modal/transaction_labels_sheet.dart';
import '../screens/transaction_tags/transaction_tags_screen.dart';
import '../widgets/base/ink_tap.dart';
import '../widgets/tags/tag_toggle_widget.dart';
import 'base/simple_dialog.dart';
import 'delete_label_dialog.dart';
import 'delete_tag_dialog.dart';

Future<TransactionFilter?> showFilterDialog({
  required final BuildContext context,
  required final TransactionFilter? filter,
}) {
  final completer = Completer<TransactionFilter?>();
  final result = filter?.copy() ?? TransactionFilter();
  unawaited(
    showDialog(
      context: context,
      builder: (final context) {
        return SimpleAlertDialog(
          body: Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: FilterDialog(
              filter: result,
              onClear: () {
                result.clear();
                context.pop();
                completer.complete(result);
              },
              onSearch: context.pop,
            ),
          ),
          actions: [
            SimpleAction(
              text: 'Cancel',
              color: context.errorColor,
              onTap: () => completer.complete(null),
            ),
            SimpleAction(
              text: 'Apply',
              onTap: () => completer.complete(result),
            ),
          ],
        );
      },
    ),
  );
  return completer.future;
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    required this.filter,
    required this.onClear,
    required this.onSearch,
    super.key,
  });

  final TransactionFilter filter;
  final void Function() onClear;
  final void Function() onSearch;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final _service = Services.get<TagsService>();

  final _tags = <TagEntity>[];
  final _selectedTags = <String>[];

  final _labels = <TransactionLabel>[];
  final _selectedLabels = <String>[];

  final _subscriptions = <StreamSubscription<dynamic>>[];

  // object sent by reference !!
  void updateFilter() {
    widget.filter.tags.clear();
    widget.filter.tags.addAll(_selectedTags);
    widget.filter.labels.clear();
    widget.filter.labels.addAll(_selectedLabels);
  }

  // tags

  Future<void> _deleteTag({
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

  void _tagSelected(final String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    setState(() {});
    updateFilter();
  }

  Future<void> _selectTags() async {
    final results = await Navigator.of(context).push<List<String>?>(
      MaterialPageRoute(
        builder: (final context) {
          return TransactionTagsScreen(
            multiselect: true,
            savingMode: true,
            selected: _selectedTags,
          );
        },
      ),
    );
    if (results != null) {
      _selectedTags.clear();
      _selectedTags.addAll(results);
      _sortTags();

      setState(() {});
      updateFilter();
    }
  }

  void _sortTags() {
    // sort - ugly, but im lazy
    final selected = _tags
        .where((final element) => _selectedTags.contains(element.name))
        .toList();
    _tags.removeWhere((final tag) => _selectedTags.contains(tag.name));
    _tags.insertAll(0, selected);
  }

  // labels

  Future<void> _deleteLabel({
    required final TransactionLabel label,
  }) async {
    await showDeleteLabelDialog(
      context: context,
      id: label.id,
    );
  }

  Future<void> _labelSelected(final String label) async {
    if (_selectedLabels.contains(label)) {
      _selectedLabels.remove(label);
    } else {
      _selectedLabels.add(label);
    }
    setState(() {});
    updateFilter();
  }

  Future<void> _selectLabels() async {
    showTransactionLabelsSheet(
      context: context,
      selected: _selectedLabels,
      onSelect: (final label) {
        _labelSelected(label.name);
        _sortLabels();

        setState(() {});
        updateFilter();
      },
    );
  }

  void _sortLabels() {
    // sort - ugly, but im lazy
    final selected = _labels
        .where((final element) => _selectedLabels.contains(element.name))
        .toList();
    _labels.removeWhere(
      (final label) => _selectedLabels.contains(label.name),
    );
    _labels.insertAll(0, selected);
  }

  @override
  void initState() {
    super.initState();

    // init
    _selectedTags.addAll(widget.filter.tags);
    _selectedLabels.addAll(widget.filter.labels);

    // listen - will fire immediately
    _subscriptions.add(
      _service.tagsStream.listen((final event) {
        _tags.clear();
        _tags.addAll(event);
        _sortTags();
        setState(() {});
      }),
    );
    _subscriptions.add(
      _service.labelsStream.listen((final event) {
        _labels.clear();
        _labels.addAll(event);
        _sortLabels();
        setState(() {});
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final element in _subscriptions) {
      unawaited(element.cancel());
    }
  }

  @override
  Widget build(final BuildContext context) {
    // final text = widget.filter.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Text(
                  'Filter',
                  style: context.titleLarge,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  widget.onClear();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.solidTrashCan,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        MoreDetailsRow(
          text: 'More Categories',
          icon: FontAwesomeIcons.layerGroup,
          padding: const EdgeInsets.symmetric(
            vertical: kVerticalPadding,
          ),
          onTap: () async {
            await _selectTags();
          },
        ),
        SizedBox(
          width: double.maxFinite,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            spacing: 8,
            children: [
              for (final tag in _tags.sublist(0, min(6, _tags.length))) ...[
                TagToggleWidget(
                  iconSize: 15,
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 5,
                  ),
                  color: tag.color,
                  name: tag.name,
                  icon: tag.icon,
                  selected: _selectedTags.contains(tag.name),
                  onTap: () {
                    _tagSelected(
                      tag.name,
                    );
                  },
                  onLongTap: () {
                    unawaited(
                      _deleteTag(
                        tag: tag,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(
          height: kVerticalPadding,
        ),
        MoreDetailsRow(
          text: 'More Labels',
          icon: FontAwesomeIcons.hashtag,
          padding: const EdgeInsets.symmetric(
            vertical: kVerticalPadding,
          ),
          onTap: () async {
            await _selectLabels();
          },
        ),
        SizedBox(
          width: double.maxFinite,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            spacing: 8,
            children: [
              for (final label
                  in _labels.sublist(0, min(6, _labels.length))) ...[
                TagToggleWidget(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 5,
                  ),
                  onLongTap: () {
                    unawaited(
                      _deleteLabel(
                        label: label,
                      ),
                    );
                  },
                  icon: FontAwesomeIcons.hashtag,
                  color: context.hintColor,
                  name: label.name,
                  iconSize: 15,
                  selected: _selectedLabels.contains(label.name),
                  onTap: () {
                    unawaited(
                      _labelSelected(
                        label.name,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        // if (text != null) ...[
        //   const SizedBox(
        //     height: kVerticalPadding,
        //   ),
        //   MoreDetailsRow(
        //     text: '"$text"',
        //     icon: FontAwesomeIcons.magnifyingGlass,
        //     padding: const EdgeInsets.symmetric(
        //       vertical: kVerticalPadding,
        //     ),
        //     onTap: () {
        //       widget.onSearch();
        //     },
        //   ),
        // ],
      ],
    );
  }
}

class MoreDetailsRow extends StatelessWidget {
  const MoreDetailsRow({
    required this.text,
    required this.icon,
    required this.onTap,
    this.padding,
    super.key,
  });

  final void Function() onTap;
  final String text;
  final IconData icon;
  final EdgeInsets? padding;

  @override
  Widget build(final BuildContext context) {
    return InkTap(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: kVerticalPadding,
              horizontal: kHorizontalPadding,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox.square(
                  dimension: 25,
                  child: Center(
                    child: FaIcon(
                      icon,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  text,
                  style: context.titleMedium,
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
    );
  }
}
