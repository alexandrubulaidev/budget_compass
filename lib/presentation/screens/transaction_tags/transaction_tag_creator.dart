import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/entities/tag_entity.dart';
import '../../../data/model/transaction_type.dart';
import '../../../domain/services.dart';
import '../../../domain/wallet/tags_service.dart';
import '../../../utils/app_localizations.dart';
import '../../app_theme.dart';
import '../../dialog/base/simple_dialog.dart';
import '../../dialog/base/simple_dialog_helpers.dart';
import '../../extensions/context_extension.dart';
import '../../widgets/base/flat_bordered_button.dart';
import '../../widgets/transaction/transaction_type_segment/transaction_type_segment.dart';
import '../../widgets/transaction/transaction_type_segment/transaction_type_segment_value.dart';

class TransactionTagCreator extends StatefulWidget {
  const TransactionTagCreator({
    required this.color,
    required this.onCreate,
    required this.text,
    this.type,
    super.key,
  });

  final TransactionType? type;
  final Color color;
  final String text;
  final void Function(TagEntity tag) onCreate;

  @override
  State<TransactionTagCreator> createState() => _TransactionTagCreatorState();
}

class _TransactionTagCreatorState extends State<TransactionTagCreator> {
  TagsService get _service => Services.get<TagsService>();
  Color _selectedColor = Colors.grey;
  IconData _selectedIcon = FontAwesomeIcons.question;
  TransactionTypeSegmentValue _type = TransactionTypeSegmentValue.income;
  final _types = [
    TransactionTypeSegmentValue.income,
    TransactionTypeSegmentValue.expense,
    TransactionTypeSegmentValue.both,
  ];

  Future<void> _saveTag() async {
    if (_selectedIcon == FontAwesomeIcons.question) {
      final result = await showConfirmationDialog(
        context: context,
        title: 'Confirmation'.localized,
        message: 'You can set a custom icon for this tag '
                'by tapping the button on the right of the tag name. '
                'Are you sure you want to continue?'
            .localized,
        confirmTitle: 'Ok'.localized,
        declineTitle: 'Cancel'.localized,
      );
      if (!result) {
        return;
      }
    }
    final tag = TagEntity(
      name: widget.text,
      icon: _selectedIcon,
      color: _selectedColor,
      type: _type.transactionType,
    );
    final result = await _service.addTransactionTag(
      tag: tag,
    );
    await result.when(
      (final success) {
        widget.onCreate.call(success);
      },
      (final error) async {
        if (context.mounted) {
          await showErrorDialog(
            context: context,
            message: error.message,
          );
        }
      },
    );
  }

  Future<void> _selectTag() async {
    final icon = await FlutterIconPicker.showIconPicker(
      context,
      showTooltips: true,
      iconSize: 35,
      iconColor: context.captionColor,
      iconPickerShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      iconPackModes: [
        IconPack.cupertino,
        IconPack.material,
        IconPack.lineAwesomeIcons,
        IconPack.fontAwesomeIcons,
      ],
      title: Text(
        "Pick an icon for '${widget.text}'",
        style: context.titleLarge,
      ),
      closeChild: Text(
        'Cancel',
        style: context.bodyLarge,
      ),
    );
    if (icon != null) {
      _selectedIcon = icon;
    }
    setState(() {});
  }

  void _pickColor() {
    var pickedColor = _selectedColor;
    unawaited(
      showDialog(
        context: context,
        builder: (final context) {
          return SimpleAlertDialog(
            body: ColorPicker(
              pickerColor: _selectedColor,
              enableAlpha: false,
              onColorChanged: (final value) {
                pickedColor = value;
              },
            ),
            actions: [
              SimpleAction(
                text: 'Cancel',
                color: Theme.of(context).colorScheme.error,
              ),
              SimpleAction(
                text: 'Confirm',
                onTap: () {
                  setState(() {
                    _selectedColor = pickedColor;
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.color;
    _type = TransactionSegmentValueHelper.fromTransactionType(
      widget.type,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'New transaction tag',
                    style: context.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TransactionTypeSegment(
          selectedIndex: _types.indexOf(_type),
          values: _types,
          onChange: (final type) async {
            setState(() {
              _type = type;
            });
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Material(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(kBorderRadius),
              child: InkWell(
                onTap: _selectTag,
                child: Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: FaIcon(
                      _selectedIcon,
                      size: 15,
                      color: context.background,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                widget.text,
                style: context.titleMedium,
              ),
            ),
            Material(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(kBorderRadius),
              child: InkWell(
                onTap: _pickColor,
                child: SizedBox(
                  width: 75,
                  height: 35,
                  child: Center(
                    child: Text(
                      'Color'.localized,
                      style: context.bodyMedium?.apply(
                        color: context.background,
                        fontWeightDelta: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        FlatBorderedButton(
          text: 'SAVE CATEGORY'.localized,
          onTap: _saveTag,
        ),
      ],
    );
  }
}
