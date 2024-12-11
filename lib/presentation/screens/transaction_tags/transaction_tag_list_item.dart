// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/entities/tag_entity.dart';
import '../../../utils/app_localizations.dart';
import '../../app_theme.dart';
import '../../extensions/context_extension.dart';
import '../../widgets/base/ink_tap.dart';
import '../../widgets/tags/transaction_tag_icon.dart';

class TransactionTagListItem extends StatefulWidget {
  const TransactionTagListItem({
    required this.tag,
    this.selected = false,
    this.showUnselectedIcon = true,
    this.onSelect,
    this.onLongTap,
    super.key,
  });

  final bool selected;
  final bool showUnselectedIcon;
  final TagEntity tag;
  final void Function(bool selected)? onSelect;
  final void Function()? onLongTap;

  @override
  State<TransactionTagListItem> createState() => _TransactionTagListItemState();
}

class _TransactionTagListItemState extends State<TransactionTagListItem> {
  bool _selected = false;

  void _tapped() {
    if (widget.onSelect == null) {
      return;
    }
    setState(() {
      _selected = !_selected;
    });
    widget.onSelect?.call(_selected);
  }

  void _longTap() {
    widget.onLongTap?.call();
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(final BuildContext context) {
    final primaryIcon = Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.tag.color,
      ),
      child: Center(
        child: TransactionTagIcon(
          icon: widget.tag.icon,
          size: 12,
          color: context.background,
        ),
      ),
    );
    return InkTap(
      onTap: _tapped,
      onLongTap: _longTap,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kHorizontalPadding * 1.2,
        ),
        child: Row(
          children: [
            primaryIcon,
            const SizedBox(
              width: 12,
            ),
            Text(
              widget.tag.name.localized,
              style: context.titleMedium?.apply(
                color: _selected && !widget.showUnselectedIcon
                    ? context.primaryColor
                    : null,
              ),
            ),
            const Spacer(),
            Container(
              constraints: const BoxConstraints(minHeight: 45),
              child: widget.showUnselectedIcon
                  ? Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: _selected,
                      side: BorderSide(
                        color: context.hintColor,
                        width: 1.5,
                      ),
                      onChanged: (final value) {
                        _tapped();
                      },
                    )
                  : _selected
                      ? Center(
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            size: 20,
                            color: context.primary,
                          ),
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
