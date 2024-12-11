// ignore_for_file: use_decorated_box

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_ext/list_ext.dart';

import '../../../../data/entities/transaction_entity.dart';
import '../../../../data/model/transaction_type.dart';
import '../../../../data/model/wallet_currency.dart';
import '../../../../domain/extensions/num_extension.dart';
import '../../../../domain/extensions/transaction_entity_list_helper.dart';
import '../../../../utils/app_localizations.dart';
import '../../../app_theme.dart';
import '../../../extensions/context_extension.dart';
import '../../../utilities.dart';
import '../../../widgets/base/app_expansion_panel_list.dart';
import '../../../widgets/keyboard/widgets/biz_keyboard_evaluator.dart';
import '../../../widgets/tags/list_tag_icon.dart';

class StatisticsCategoriesList extends StatelessWidget {
  const StatisticsCategoriesList({
    required this.transactions,
    required this.type,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final TransactionType type;

  List<TransactionEntity> _subcategoryForTag(final String tag) {
    final filtered = transactions.where(
      (final element) => element.tagName == tag || element.parentTagName == tag,
    );
    var results = <TransactionEntity>[];
    for (final e in filtered) {
      results.add(
        TransactionEntity(
          id: e.id,
          walletId: e.walletId,
          type: e.type,
          title: e.title,
          value: e.value,
          date: e.date,
          currency: e.currency,
          color: e.color,
          icon: e.icon,
          tagName: e.tagName,
        ),
      );
    }
    results = results.groupByTags()..sortBy((final e) => e.value);
    results = results.reversed.toList();

    return results;
  }

  @override
  Widget build(final BuildContext context) {
    var filtered = transactions
        .where((final element) => element.type == type)
        .map(
          (final e) => e.copyWith(
            tagName: e.parentTagName ?? e.tagName,
            icon: e.parentIcon ?? e.icon,
            color: e.parentColor ?? e.color,
          ),
        )
        .toList()
        .groupByTags()
      ..sortBy((final e) => e.value);
    filtered = filtered.reversed.toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 70,
          ),
          child: Text(
            'You have no %s for this selection'.localized.formatted([
              if (type == TransactionType.expense)
                'expenses'.localized
              else
                'income'.localized,
            ]),
            textAlign: TextAlign.center,
            style: context.titleSmall?.apply(color: context.disabledColor),
          ),
        ),
      );
    }

    final total = filtered.isEmpty
        ? 0.0
        : filtered
            .map((final e) => e.value)
            .reduce((final value, final element) => value + element);

    final expanded = <int, bool>{};

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: kVerticalPadding,
        // horizontal: kHorizontalPadding,
      ),
      child: StatefulBuilder(
        builder: (final context, final setState) {
          return AppExpansionPanelList(
            elevation: 0,
            expansionCallback: (final panelIndex, final isExpanded) {
              final group = filtered[panelIndex];
              if (group.parentIcon != null) {
                setState(() {
                  expanded[panelIndex] = !isExpanded;
                });
              }
            },
            dividerColor: Colors.transparent,
            children: [
              for (var index = 0; index < filtered.length; index++)
                AppExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: expanded[index] ?? false,
                  iconBuilder: (final child, final isExpanded) {
                    return null;
                  },
                  headerBuilder: (final context, final isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kHorizontalPadding,
                        vertical: kVerticalPadding / 4,
                      ),
                      child: StatisticsCategoryListItem(
                        barHeight: 8,
                        verticalSpacing: 3,
                        iconSize: 40,
                        currency: transactions.first.currency,
                        group: filtered[index],
                        total: total,
                      ),
                    );
                  },
                  body: Builder(
                    builder: (final context) {
                      final group = filtered[index];
                      final tag = group.tagName;

                      return Padding(
                        padding: const EdgeInsets.only(
                          left: kHorizontalPadding + 5,
                          right: kHorizontalPadding,
                          bottom: kVerticalPadding,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _subcategoryForTag(tag).map(
                            (final e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: StatisticsCategoryListItem(
                                  titleStyle: context.titleSmall,
                                  barHeight: 6,
                                  verticalSpacing: 0,
                                  iconSize: 35,
                                  currency: e.currency,
                                  group: e,
                                  total: group.value,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class StatisticsCategoryListItem extends StatelessWidget {
  const StatisticsCategoryListItem({
    required this.currency,
    required this.group,
    required this.total,
    required this.iconSize,
    required this.barHeight,
    required this.verticalSpacing,
    this.titleStyle,
    this.valueStyle,
    super.key,
  });

  final WalletCurrency currency;
  final TransactionEntity group;
  final double total;
  final double iconSize;
  final double barHeight;
  final double verticalSpacing;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        ListTagIcon(
          size: iconSize,
          icon: group.icon,
          color: group.color,
          secondaryIcon:
              group.parentIcon == null ? null : FontAwesomeIcons.plus,
          secondaryColor: context.primaryColor,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    group.tagName.localized,
                    style: titleStyle ?? context.titleMedium,
                  ),
                  BizKeyboardEvaluator(
                    currency: currency,
                    keys: group.value.keys,
                    color: context.primaryTextColor,
                    elementSize: valueStyle?.fontSize ??
                        context.bodySmall?.fontSize ??
                        15,
                    smallDecimals: true,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
              SizedBox(
                height: verticalSpacing,
              ),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: max(group.value / total, 0.02),
                      minHeight: barHeight,
                      color: group.color,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: context.disabledColor.withAlpha(
                        50,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    percent(
                      value: group.value,
                      total: total,
                    ),
                    style: valueStyle ??
                        context.bodySmall?.apply(
                          fontWeightDelta: 2,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
