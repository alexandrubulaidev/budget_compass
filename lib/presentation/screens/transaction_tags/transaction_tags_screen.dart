// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_ext/list_ext.dart';

import '../../../data/entities/tag_entity.dart';
import '../../../data/model/transaction_type.dart';
import '../../../domain/services.dart';
import '../../../domain/wallet/tags_service.dart';
import '../../../utils/app_localizations.dart';
import '../../dialog/delete_tag_dialog.dart';
import '../../extensions/context_extension.dart';
import '../../widgets/base/biz_input_field.dart';
import 'transaction_tag_creator.dart';
import 'transaction_tag_list_item.dart';

// enum TagScreenMode { save, view }

class TransactionTagsScreen extends StatefulWidget {
  const TransactionTagsScreen({
    this.multiselect = false,
    this.title,
    this.type,
    this.savingMode = false,
    this.viewMode = false,
    this.selected = const [],
    this.excluded = const [],
    super.key,
  });

  final bool viewMode;
  final bool savingMode;
  final bool multiselect;
  final String? title;
  final List<String> selected;
  final List<String> excluded;
  final TransactionType? type;

  @override
  State<TransactionTagsScreen> createState() => _TransactionTagsScreenState();
}

class _TransactionTagsScreenState extends State<TransactionTagsScreen> {
  TagsService get _service => Services.get<TagsService>();

  StreamSubscription<List<TagEntity>>? _tagsSubscription;

  final List<String> _selected = [];
  final List<TagEntity> _results = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // delete tag

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

  // new tag logic

  void _tagTapped({
    required final TagEntity tag,
    required final bool selected,
  }) {
    if (widget.viewMode) {
      return;
    }
    if (widget.multiselect || widget.savingMode) {
      if (selected) {
        _selected.add(tag.name);
      } else {
        _selected.remove(tag.name);
      }
      setState(() {});
    } else {
      Navigator.of(context).pop([tag.name]);
    }
  }

  void _tagAdded({
    required final TagEntity tag,
  }) {
    _searchFocus.unfocus();
    _searchController.text = '';
    _tagTapped(
      tag: tag,
      selected: true,
    );
  }

  // init / refresh

  Future<void> _refresh() async {
    _search('');
  }

  void _search(final String text) {
    final tags = _service.tags.where(
      (final element) => element.isFor(widget.type),
    );
    _results.clear();
    if (text.trim() == '') {
      _results.addAll(tags);
      _runExclusion();
    } else {
      _results.addAll(
        tags.where(
          (final element) => element.name.toLowerCase().contains(text),
        ),
      );
      _runExclusion();
      _results.sortByDescending((final e) => e.weight);
    }
    setState(() {});
  }

  void _runExclusion() {
    _results.removeWhere((final element) {
      return widget.excluded.contains(element.name);
    });
  }

  Future<void> _init() async {
    // selected tags
    _selected.addAll(widget.selected);

    // search
    _searchController.addListener(() {
      _search(_searchController.text);
    });

    // listen for new tags
    _tagsSubscription = _service.tagsStream.skip(1).listen((final event) {
      _search(_searchController.text);
    });

    // get available tags
    await _refresh();
  }

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    unawaited(_tagsSubscription?.cancel());
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(widget.savingMode ? null : _selected);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? 'Category'.localized,
            style: context.titleLarge,
          ),
          actions: [
            if (widget.savingMode && _selected.isNotEmpty)
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(_selected);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.check,
                  size: 20,
                ),
              ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: BizInputField(
                focusNode: _searchFocus,
                label: 'Search or add a category'.localized,
                suffixIcon: FontAwesomeIcons.magnifyingGlass,
                textInputAction: TextInputAction.search,
                controller: _searchController,
              ),
            ),
            const SizedBox(height: 10),
            // if (widget.viewMode) ...[
            //   Padding(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: kHorizontalPadding,
            //     ),
            //     child: TransactionTypeSegment(
            //       selectedIndex: 2,
            //       values: [
            //         TransactionTypeSegmentValue.income,
            //         TransactionTypeSegmentValue.expense,
            //         TransactionTypeSegmentValue.both,
            //       ],
            //       onChange: (final type) async {
            //         setState(() {
            //           // _type = type;
            //         });
            //       },
            //     ),
            //   ),
            // ],
            if (_results.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 18,
                ),
                child: TransactionTagCreator(
                  type: widget.type,
                  color: context.primary,
                  text: _searchController.text,
                  onCreate: (final tag) {
                    _tagAdded(tag: tag);
                  },
                ),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (final context, final index) {
                    final tag = _results[index];
                    return TransactionTagListItem(
                      showUnselectedIcon: widget.multiselect,
                      key: ValueKey(tag.name),
                      tag: tag,
                      selected: _selected.contains(tag.name),
                      onSelect: widget.viewMode
                          ? null
                          : (final selected) {
                              _tagTapped(
                                tag: tag,
                                selected: selected,
                              );
                            },
                      onLongTap: widget.viewMode
                          ? null
                          : () async {
                              await _deleteTag(
                                tag: tag,
                              );
                            },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
