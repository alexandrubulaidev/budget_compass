// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../data/entities/transaction_entity.dart';
import '../../../data/model/wallet.dart';
import '../../../domain/services.dart';
import '../../../domain/wallet/tags_service.dart';
import '../../../domain/wallet/wallet_service.dart';
import '../../../utils/app_localizations.dart';
import '../../dialog/base/simple_dialog_helpers.dart';
import '../../extensions/context_extension.dart';
import '../../routing/routes.dart';
import '../../toast/toaster.dart';
import '../../widgets/base/biz_input_field.dart';
import '../../widgets/base/loading_scaffold.dart';
import '../../widgets/base/multi_rx_builder.dart';
import '../../widgets/base/rx_builder.dart';
import '../../widgets/utils/android_back.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../statistics/statistics_screen.dart';
import '../transactions/widgets/transactions_list.dart';
import 'widgets/range_selector.dart';
import 'widgets/search_widget.dart';
import 'widgets/settings_view.dart';
import 'widgets/wallet_selector.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen();

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  WalletService get _walletService => Services.get<WalletService>();
  TagsService get _tagsService => Services.get<TagsService>();
  var _selectedIndex = 0;

  Future<void> _addTransaction() async {
    await const AddTransactionScreenRoute().push<void>(context);
  }

  Future<void> _showTransaction({
    required final TransactionEntity transaction,
  }) async {
    await context.basicPush<void>(
      AddTransactionScreen(
        transaction: transaction,
      ),
    );
  }

  Future<void> _deleteTransaction({
    required final TransactionEntity transaction,
  }) async {
    final success = await showConfirmationDialog(
      context: context,
      message:
          'Do you want to delete this transaction? This action is irreversible.'
              .localized,
      confirmTitle: 'Yes'.localized,
      declineTitle: 'Cancel'.localized,
    );
    if (success) {
      final result = await Services.get<WalletService>().deleteTransaction(
        transaction: transaction,
      );
      if (result != null) {
        final context = this.context;
        if (context.mounted) {
          await showErrorDialog(
            context: context,
            message: result.message,
          );
        }
      }
    }
  }

  Future<void> _changeWallet(final Wallet wallet) async {
    await showToast(
      message: 'Wallet changed'.localized,
      context: context,
    );
    await _walletService.setWallet(wallet);
  }

  Future<void> _createWallet() async {
    final controller = TextEditingController();
    final result = await showConfirmationDialog(
      context: context,
      title: 'Wallet Name'.localized,
      confirmTitle: 'Create'.localized,
      declineTitle: 'Cancel'.localized,
      body: BizInputField(
        label: 'Name'.localized,
        controller: controller,
      ),
    );
    if (result) {
      final createResult = await _walletService.createWallet(
        name: controller.text,
        swap: true,
      );
      createResult.when((final success) {
        showToast(
          message: 'Wallet created'.localized,
          context: context,
        );
      }, (final error) {
        showErrorDialog(
          context: context,
          message: error.message,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      unawaited(WakelockPlus.enable());
    }
  }

  @override
  Widget build(final BuildContext context) {
    return AndroidBack(
      child: RxBuilder<Wallet?>(
        subject: _walletService.walletStream,
        builder: (final context, final wallet) {
          if (wallet == null) {
            return const LoadingScaffold();
          }
          return Scaffold(
            appBar: _selectedIndex == 2
                ? null
                : AppBar(
                    title: const RangeSelector(),
                    titleSpacing: 0,
                  ),
            floatingActionButton: _selectedIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      unawaited(_addTransaction());
                    },
                    child: const Center(
                      child: FaIcon(FontAwesomeIcons.plus),
                    ),
                  )
                : null,
            body: Column(
              children: [
                if (_selectedIndex != 2) ...[
                  const SearchInput(),
                ],
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      MultiRxBuilder(
                        subjects: [
                          _walletService.transactionsStream,
                          _walletService.walletStream,
                        ],
                        builder: (final context, final value) {
                          Fimber.d('transaction list re-builded');
                          return TransactionsList(
                            transactions: _walletService.transactions,
                            onTap: (final transaction) {
                              unawaited(
                                _showTransaction(
                                  transaction: transaction,
                                ),
                              );
                            },
                            onLongTap: (final transaction) {
                              unawaited(
                                _deleteTransaction(
                                  transaction: transaction,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      MultiRxBuilder(
                        subjects: [
                          _walletService.transactionsStream,
                          _walletService.cashflowStartStream,
                          _tagsService.groupsStream,
                          _tagsService.labelsStream,
                        ],
                        builder: (final context, final value) {
                          return StatisticsScreen(
                            transactions: _walletService.transactions,
                            cashflowStart: _walletService.cashflowStart,
                            range: _walletService.range,
                          );
                        },
                      ),
                      MultiRxBuilder(
                        subjects: [
                          _walletService.walletStream,
                          _walletService.walletsStream,
                        ],
                        builder: (final context, final value) {
                          return Column(
                            children: [
                              SafeArea(
                                child: WalletSelector(
                                  wallets: _walletService.wallets,
                                  selected: _walletService.wallet,
                                  onSelect: (final wallet) async {
                                    await _changeWallet(wallet);
                                  },
                                  onCreate: _createWallet,
                                ),
                              ),
                              Expanded(
                                child: SettingsView(
                                  wallet: _walletService.wallet,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: false,
              backgroundColor: context.background,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.list),
                  label: 'Transactions',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.chartPie),
                  label: 'Statistics',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.wallet),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (final value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
