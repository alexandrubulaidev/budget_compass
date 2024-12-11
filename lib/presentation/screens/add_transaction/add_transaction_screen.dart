import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/entities/transaction_entity.dart';
import '../../../domain/services.dart';
import '../../../domain/wallet/wallet_service.dart';
import '../../../utils/app_localizations.dart';
import '../../dialog/base/simple_dialog_helpers.dart';
import '../../extensions/context_extension.dart';
import '../../widgets/base/biz_input_field.dart';
import '../../widgets/base/rx_builder.dart';
import '../../widgets/keyboard/biz_keyboard.dart';
import '../../widgets/transaction/transaction_type_segment/transaction_type_segment.dart';
import '../../widgets/transaction/transaction_type_segment/transaction_type_segment_value.dart';
import 'add_transaction_screen_controller.dart';
import 'widgets/transaction_date_segment.dart';
import 'widgets/transaction_labels_segment.dart';
import 'widgets/transaction_tags_segment.dart';
import 'widgets/transaction_value_segment.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    this.transaction,
    super.key,
  });

  final TransactionEntity? transaction;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late AddTransactionScreenController _controller;
  final _visibilityController = KeyboardVisibilityController();
  StreamSubscription<bool>? _visibilitySubscription;
  bool _keyboardVisible = false;

  Future<void> _saveTransaction() async {
    final result = await _controller.saveTransaction();
    final context = this.context;
    if (!context.mounted) {
      return;
    }
    if (result == null) {
      if (context.mounted) {
        context.pop();
      }
    } else {
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          message: result.message,
        );
      }
    }
  }

  void _transactionTypeSelected(
    final TransactionTypeSegmentValue type,
  ) {
    _controller.updateTransactionType(type);
  }

  Future<void> _deleteTransaction() async {
    final transaction = _controller.transaction;
    if (transaction == null) {
      return;
    }
    final success = await showConfirmationDialog(
      context: context,
      message: 'Are you sure you want to delete this transaction? '
              'This action is irreversible.'
          .localized,
      confirmTitle: 'Yes'.localized,
      declineTitle: 'Cancel'.localized,
    );
    if (success) {
      final result = await Services.get<WalletService>().deleteTransaction(
        transaction: transaction,
      );
      final context = this.context;
      if (result != null) {
        if (context.mounted) {
          await showErrorDialog(
            context: context,
            message: result.message,
          );
        }
      } else {
        if (context.mounted) {
          context.pop();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = Services.register<AddTransactionScreenController>(
      AddTransactionScreenController(transaction: widget.transaction),
    );
    _visibilitySubscription = _visibilityController.onChange.listen(
      (final visible) async {
        _keyboardVisible = visible;
        if (!_keyboardVisible) {
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
        setState(() {});
      },
    );
    _controller.keyboardController.onSubmit = _saveTransaction;
  }

  @override
  void dispose() {
    super.dispose();
    unawaited(Services.unregister<AddTransactionScreenController>());
    unawaited(_visibilitySubscription?.cancel());
  }

  @override
  Widget build(final BuildContext context) {
    final content = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RxBuilder(
            subject: _controller.typeStream,
            builder: (final context, final value) {
              const values = [
                TransactionTypeSegmentValue.income,
                TransactionTypeSegmentValue.expense,
                // TransactionTypeSegmentValue.transfer,
              ];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: TransactionTypeSegment(
                  selectedIndex: values.indexOf(value),
                  values: values,
                  onChange: _transactionTypeSelected,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TransactionDateSegment(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 10,
              right: 15,
              left: 15,
            ),
            child: TransactionValueSegment(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 15,
            ),
            child: TransactionTagsSegment(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: BizInputField(
              minLines: 1,
              label: 'Notes'.localized,
              controller: _controller.notesController,
            ),
          ),
          TransactionLabelsSegment(),
        ],
      ),
    );
    final keyboard = BizKeyboard(
      controller: _controller.keyboardController,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          _controller.title,
          style: context.titleLarge,
        ),
        actions: [
          if (_controller.transaction != null)
            IconButton(
              onPressed: _deleteTransaction,
              icon: const FaIcon(
                FontAwesomeIcons.solidTrashCan,
                size: 20,
              ),
            ),
        ],
      ),
      body: OrientationBuilder(
        builder: (final context, final _) {
          final orientation = MediaQuery.of(context).orientation;
          if (orientation == Orientation.portrait) {
            return Column(
              children: [
                Expanded(
                  child: content,
                ),
                if (!_keyboardVisible) ...[
                  Container(
                    height: 1,
                    color: context.captionColor?.withAlpha(50),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 250,
                    ),
                    child: keyboard,
                  ),
                ],
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: content,
                ),
                Container(
                  width: 1,
                  color: context.captionColor?.withAlpha(50),
                ),
                if (!_keyboardVisible) ...[
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 3,
                    ),
                    child: keyboard,
                  ),
                ],
              ],
            );
          }
        },
      ),
    );
  }
}
