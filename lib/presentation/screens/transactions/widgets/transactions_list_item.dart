// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/entities/transaction_entity.dart';
import '../../../../domain/extensions/num_extension.dart';
import '../../../../domain/extensions/transaction_type_extension.dart';
import '../../../../utils/app_localizations.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/keyboard/widgets/biz_keyboard_evaluator.dart';
import '../../../widgets/tags/list_tag_icon.dart';
import '../../../widgets/tags/tag_toggle_widget.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    required this.item,
    super.key,
  });

  final TransactionEntity item;

  @override
  Widget build(final BuildContext context) {
    final title = item.tagName;
    final description = item.description;
    final type = item.type;
    final value = item.value;
    // primary tag
    final icon = item.parentIcon ?? item.icon;
    final color = item.parentColor ?? item.color;
    // secondary tag
    final secondaryIcon = item.parentIcon == null ? null : item.icon;
    final secondaryColor = item.parentIcon == null ? null : item.color;
    final labels = item.labels;

    final text = labels.isNotEmpty
        ? Wrap(
            spacing: 2,
            runSpacing: 2,
            children: [
              for (final label in labels)
                TagToggleWidget(
                  borderRadius: 3,
                  borderWidth: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  selected: true,
                  color: context.hintColor.withAlpha(100),
                  name: label,
                  textStyle: context.bodyExtraSmall?.apply(
                    color: context.background,
                    fontWeightDelta: 2,
                  ),
                ),
            ],
          )
        : null;

    return Row(
      crossAxisAlignment: text != null && description != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        ListTagIcon(
          icon: icon,
          color: color,
          secondaryIcon: secondaryIcon,
          secondaryColor: secondaryColor,
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.localized,
              style: context.titleSmall,
            ),
            if (description != null) ...[
              Text(
                description,
                style: context.bodyExtraSmall?.apply(
                  color: context.hintColor,
                  fontWeightDelta: 2,
                ),
              ),
            ],
            if (text != null) ...[
              if (description != null)
                const SizedBox(
                  height: 2,
                ),
              text,
            ],
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            BizKeyboardEvaluator(
              currency: item.currency,
              keys: value.keys,
              color: type.color,
              elementSize: context.bodySmall?.fontSize ?? 15,
              smallDecimals: true,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
            const SizedBox(height: 3),
            Text(
              DateFormat.Hm().format(item.date),
              style: context.bodyExtraSmall?.apply(
                color: context.hintColor,
                fontWeightDelta: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
