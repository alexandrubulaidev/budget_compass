import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/model/wallet.dart';
import '../../../app_theme.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/ink_tap.dart';
import '../../../widgets/loading/biz_loader.dart';

class WalletSelector extends StatelessWidget {
  const WalletSelector({
    required this.wallets,
    required this.selected,
    required this.onSelect,
    required this.onCreate,
    super.key,
  });

  final List<Wallet> wallets;
  final Wallet selected;
  final void Function(Wallet selected) onSelect;
  final void Function() onCreate;

  Future<void> _changeWallet({
    required final BuildContext context,
    required final Wallet wallet,
  }) async {
    onSelect(wallet);
  }

  Future<void> _createWallet({
    required final BuildContext context,
  }) async {
    onCreate();
  }

  @override
  Widget build(final BuildContext context) {
    MenuController? menuController;

    return Padding(
      padding: const EdgeInsets.only(
        top: kVerticalPadding / 2,
        left: kHorizontalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkTap(
              onTap: () {
                if (menuController?.isOpen ?? false) {
                  menuController?.close();
                } else {
                  menuController?.open();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    const SizedBox.square(
                      dimension: 30,
                      child: BizLoader(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MenuAnchor(
                      style: const MenuStyle(
                        elevation: WidgetStatePropertyAll(5),
                      ),
                      builder: (final context, final controller, final child) {
                        menuController = controller;
                        return Text(
                          selected.name,
                          style: context.titleLarge,
                        );
                      },
                      menuChildren: List<MenuItemButton>.generate(
                        wallets.length,
                        (final index) => MenuItemButton(
                          onPressed: () async {
                            await _changeWallet(
                              context: context,
                              wallet: wallets[index],
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                wallets[index].name,
                                style: context.titleMedium?.apply(
                                  color: selected.id == wallets[index].id
                                      ? context.primaryColor
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
            onPressed: () {
              unawaited(
                _createWallet(
                  context: context,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
