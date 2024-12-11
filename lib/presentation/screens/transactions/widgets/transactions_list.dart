import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/entities/transaction_entity.dart';
import '../../../../domain/extensions/date_extension.dart';
import '../../../../utils/app_localizations.dart';
import '../../../app_theme.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/ink_tap.dart';
import '../../../widgets/transaction/transaction_list_total.dart';
import 'transactions_list_item.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    required this.transactions,
    required this.onTap,
    required this.onLongTap,
    this.padding,
    this.controller,
    super.key,
  });

  final ScrollController? controller;
  final List<TransactionEntity> transactions;
  final EdgeInsets? padding;
  final void Function(TransactionEntity transaction) onTap;
  final void Function(TransactionEntity transaction) onLongTap;

  @override
  Widget build(final BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 70,
          ),
          child: Text(
            'You have no transactions for this selection',
            textAlign: TextAlign.center,
            style: context.titleSmall?.apply(color: context.disabledColor),
          ),
        ),
      );
    }

    final totalValueWidget = Padding(
      padding: const EdgeInsets.only(
        right: kHorizontalPadding,
        left: kHorizontalPadding,
        bottom: kVerticalPadding,
      ),
      child: TransactionListTotal(
        transactions: transactions,
      ),
    );

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(
        vertical: kVerticalPadding / 2,
        // horizontal: kHorizontalPadding,
      ),
      itemCount: transactions.length,
      itemBuilder: (final context, final index) {
        final previous = index - 1 >= 0 ? transactions[index - 1] : null;
        final current = transactions[index];
        final previousDay = previous?.date.day;
        final currentDay = current.date.day;

        // transaction item widget

        final currentWidget = InkTap(
          onTap: () {
            onTap(current);
          },
          onLongTap: () {
            onLongTap(current);
          },
          borderRadius: BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding,
              vertical: kVerticalPadding / 2,
            ),
            child: TransactionListItem(
              item: current,
            ),
          ),
        );

        // date widget

        Widget? dateWidget;
        if (previousDay != currentDay) {
          final dateText = current.date.isToday
              ? 'Today'.localized.toUpperCase()
              : current.date.isYesterday
                  ? 'Yesterday'.localized.toUpperCase()
                  : DateFormat.d()
                      .add_MMM()
                      .addPattern(', ', '')
                      .add_y()
                      .format(current.date)
                      .toUpperCase();
          dateWidget = Padding(
            padding: const EdgeInsets.symmetric(
              // vertical: kVerticalPadding / 4,
              horizontal: kHorizontalPadding,
            ),
            child: Text(
              dateText,
              style: context.bodySmall?.apply(
                color: context.hintColor,
                fontWeightDelta: 2,
              ),
              textAlign: TextAlign.start,
            ),
          );
        }

        final children = [
          if (index == 0 && transactions.length > 1) ...[
            totalValueWidget,
          ],
          if (dateWidget != null) ...[
            dateWidget,
          ],
          currentWidget,
        ];

        if (children.length == 1) {
          return children.first;
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        }

        // if (previousDay == currentDay) {
        //   return currentWidget;
        // } else {
        //   return Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(
        //           // vertical: kVerticalPadding / 4,
        //           horizontal: kHorizontalPadding,
        //         ),
        //         child: Text(
        //           dateText,
        //           style: context.bodySmall?.apply(
        //             color: context.hintColor,
        //             fontWeightDelta: 2,
        //           ),
        //           textAlign: TextAlign.start,
        //         ),
        //       ),
        //       currentWidget,
        //     ],
        //   );
        // }
      },
    );
  }
}
