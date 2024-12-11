import 'dart:async';

import 'package:flutter/material.dart';

void showModalBottomSheetPicker<T>({
  required final BuildContext context,
  required final List<T> items,
  required final String Function(T item) transformer,
  required final Future<bool> Function(T item) onChange,
  final T? selectedItem,
}) {
  unawaited(
    showModalBottomSheet<void>(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      builder: (final context) {
        return SelectionPickerDialog(
          items: items,
          transformer: transformer,
          selectedItem: selectedItem,
          onChange: onChange,
        );
      },
    ),
  );
}

class SelectionPickerDialog<T> extends StatefulWidget {
  const SelectionPickerDialog({
    required this.items,
    required this.transformer,
    required this.onChange,
    this.selectedItem,
  });

  final List<T> items;
  final T? selectedItem;
  final String Function(T item) transformer;
  final Future<bool> Function(T item) onChange;

  @override
  State<SelectionPickerDialog<T>> createState() =>
      _SelectionPickerDialogState<T>();
}

class _SelectionPickerDialogState<T> extends State<SelectionPickerDialog<T>> {
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.items.map((final item) {
          final isSelected = (item == _selectedItem);
          final itemColor = isSelected
              ? theme.colorScheme.secondary
              : theme.textTheme.bodyMedium?.color;

          return ListTile(
            title: Text(
              widget.transformer.call(item),
              style: TextStyle(color: itemColor),
            ),
            trailing: isSelected ? Icon(Icons.check, color: itemColor) : null,
            onTap: () async {
              if (await widget.onChange(item)) {
                setState(() {
                  _selectedItem = item;
                });
              }
            },
          );
        }).toList(),
      ),
    );
    // return ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: widget.items.length,
    //   itemBuilder: (final BuildContext context, final int index) {
    //     final item = widget.items[index];
    //   },
    // );
  }
}
