import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../domain/model/range_adjustment.dart';
import '../../../../domain/model/range_type.dart';
import '../../../../domain/model/transaction_range.dart';
import '../../../../domain/services.dart';
import '../../../../domain/wallet/wallet_service.dart';
import '../../../../utils/app_localizations.dart';
import '../../../dialog/base/single_picker_modal.dart';
import '../../../dialog/filter_dialog.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/iconed_icon.dart';
import '../../../widgets/base/ink_tap.dart';
import '../../../widgets/base/rx_builder.dart';

class RangeSelector extends StatelessWidget {
  const RangeSelector({
    super.key,
  });

  WalletService get service => Services.get<WalletService>();

  Future<void> _pickRange(final BuildContext context) async {
    showModalBottomSheetPicker<RangeType>(
      context: context,
      selectedItem: service.range.type,
      items: RangeType.values,
      transformer: (final item) => item.text,
      onChange: (final item) async {
        if (item == RangeType.custom) {
          final start = service.range.start;
          final end = service.range.end;
          final initial = start != null && end != null
              ? DateTimeRange(start: start, end: end)
              : null;
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 356 * 25)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 25)),
            currentDate: DateTime.now(),
            initialDateRange: initial,
            saveText: 'Done'.localized,
          );
          if (range == null) {
            return false;
          } else {
            service.updateRange(
              TransactionRange(
                type: item,
                start: range.start,
                end: range.end,
              ),
            );
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            return true;
          }
        } else {
          service.updateRange(
            TransactionRange(
              type: item,
              start: item.startDate,
              end: item.endDate,
              title: item.text,
            ),
          );
          Navigator.of(context).pop();
          return true;
        }
      },
    );
  }

  void _incrementRange() {
    service.adjustRange(
      adjustment: RangeAdjustment.increment,
    );
  }

  void _decrementRange() {
    service.adjustRange(
      adjustment: RangeAdjustment.decrement,
    );
  }

  Future<void> _filter(final BuildContext context) async {
    final result = await showFilterDialog(
      context: context,
      filter: service.filter,
    );
    if (result != null) {
      service.updateFilter(result);
    }
  }

  void _startSearch() {
    service.search('');
  }

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 20,
          ),
          onPressed: _decrementRange,
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 25,
            ),
            child: InkTap(
              onTap: () {
                unawaited(_pickRange(context));
              },
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: FaIcon(
                        FontAwesomeIcons.solidCalendarDays,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 5),
                    RxBuilder(
                      subject: service.rangeStream,
                      builder: (final context, final value) {
                        return Text(
                          service.range.title,
                          style: context.titleMedium?.apply(fontWeightDelta: 2),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 20,
          ),
          onPressed: _incrementRange,
        ),
        const SizedBox(width: 5),
        RxBuilder(
          subject: service.filterStream,
          builder: (final context, final value) {
            return IconButton(
              icon: IconedIcon(
                icon: FontAwesomeIcons.filter,
                size: 20,
                indicator:
                    value.hasData ? FontAwesomeIcons.circleExclamation : null,
                indicatorColor: context.primary,
              ),
              onPressed: () {
                unawaited(_filter(context));
              },
            );
          },
        ),
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 20,
          ),
          onPressed: _startSearch,
        ),
      ],
    );
  }
}
