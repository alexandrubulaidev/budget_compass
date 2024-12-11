import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../app_theme.dart';
import '../../../extensions/context_extension.dart';
import '../../base/segmented_control.dart';
import 'transaction_type_segment_value.dart';

class TransactionTypeSegment extends StatelessWidget {
  /// To confirm segment change return true on [onChange]
  const TransactionTypeSegment({
    required this.onChange,
    required this.values,
    required this.selectedIndex,
    super.key,
  });

  final void Function(TransactionTypeSegmentValue type) onChange;
  final List<TransactionTypeSegmentValue> values;
  final int selectedIndex;

  Color get _borderColor => values[selectedIndex].color;
  Color get _activeColor => values[selectedIndex].color;

  void _onSelect(final TransactionTypeSegmentValue type) {
    onChange(type);
  }

  @override
  Widget build(final BuildContext context) {
    return SegmentControl(
      selectedIndex: selectedIndex,
      radius: kBorderRadius,
      normalTitleColor: context.primary,
      activeTitleColor: context.background,
      borderColor: _borderColor,
      activeBackgroundColor: _activeColor,
      normalBackgroundColor: context.background,
      count: values.length,
      tabBuilder: (final index, final selected) {
        final type = values[index];
        final color = selected ? context.background : context.primaryTextColor;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              type.icon,
              size: 15,
              color: color,
            ),
            const SizedBox(width: 5),
            Text(
              type.userString.toUpperCase(),
              textAlign: TextAlign.center,
              style: context.bodyMedium?.apply(
                color: color,
                fontWeightDelta: 2,
              ),
            ),
          ],
        );
      },
      selected: (final value) async {
        return _onSelect(values[value]);
      },
    );
  }
}
