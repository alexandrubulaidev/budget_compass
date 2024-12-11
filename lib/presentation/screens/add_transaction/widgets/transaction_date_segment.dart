import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../application.dart';
import '../../../../domain/services.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/rx_builder.dart';
import '../add_transaction_screen_controller.dart';

class TransactionDateSegment extends StatelessWidget {
  TransactionDateSegment({super.key});

  final _controller = Services.get<AddTransactionScreenController>();

  Future<void> _pickTime(final BuildContext context) async {
    final date = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (final context, final child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (date != null) {
      _controller.updateTime(date);
    }
  }

  Future<void> _pickDate(final BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 50)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 50)),
    );
    if (date != null) {
      _controller.updateDate(date);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _controller.decrementDate,
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 20,
          ),
        ),
        Expanded(
          child: RxBuilder(
            subject: _controller.dateStream,
            builder: (final context, final value) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        unawaited(_pickDate(context));
                      },
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.solidCalendarDays,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat.yMMMd(Application.locale)
                                  .format(value),
                              style: context.titleMedium
                                  ?.apply(fontWeightDelta: 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        unawaited(_pickTime(context));
                      },
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.clock,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat.Hm(Application.locale).format(value),
                              style: context.titleMedium
                                  ?.apply(fontWeightDelta: 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        IconButton(
          onPressed: _controller.incrementDate,
          icon: const FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 20,
          ),
        ),
      ],
    );
  }
}
