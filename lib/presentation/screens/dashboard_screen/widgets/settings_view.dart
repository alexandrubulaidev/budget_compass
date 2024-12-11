import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';

import '../../../../data/db/database.dart';
import '../../../../data/model/wallet.dart';
import '../../../../data/model/wallet_currency.dart';
import '../../../../domain/extensions/wallet_currency_extension.dart';
import '../../../../domain/services.dart';
import '../../../../domain/wallet/wallet_service.dart';
import '../../../../utils/app_localizations.dart';
import '../../../../utils/dummy.dart';
import '../../../../utils/share.dart';
import '../../../dialog/base/simple_dialog_helpers.dart';
import '../../../extensions/context_extension.dart';
import '../../../modal/transaction_labels_sheet.dart';
import '../../../routing/routes.dart';
import '../../../widgets/base/ink_tap.dart';
import '../../transaction_tags/transaction_tags_screen.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    required this.wallet,
    super.key,
  });

  final Wallet wallet;

  Future<void> _updateCurrency(final WalletCurrency currency) async {
    await Services.get<WalletService>().updateCurrency(currency);
  }

  Future<void> _selectCurrency(final BuildContext context) async {
    final currencies = [...WalletCurrency.values]..sort(
        (final a, final b) => a.friendlyString.compareTo(b.friendlyString),
      );
    final height = context.size?.height;
    var adjustedHeight = 500.0;
    if (height != null) {
      adjustedHeight = height * 0.6;
    }
    await showMessageDialog(
      context: context,
      buttonTitle: 'Cancel'.localized,
      body: Container(
        constraints: BoxConstraints(
          maxHeight: adjustedHeight,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: currencies.map((final currency) {
              final selected = wallet.currency == currency;
              final style = context.bodyMedium?.apply(
                color: selected ? context.primary : null,
                fontWeightDelta: selected ? 2 : 0,
              );
              return InkTap(
                onTap: () {
                  context.pop();
                  _updateCurrency(currency);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        currency.friendlyString,
                        style: style,
                      ),
                      const Spacer(),
                      Text(
                        currency.stringValue.toUpperCase(),
                        style: style,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _backup() async {
    final original = await databaseFile();
    final temp = await getTemporaryDirectory();
    final backup = File('${temp.path}/backup.bak');
    await original.copy(backup.path);

    shareFile(file: backup);
  }

  Future<void> _restore(final BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['bak'],
    );
    if (result == null) {
      return;
    }
    final path = result.files.single.path;
    if (path == null) {
      if (context.mounted) {
        await showErrorDialog(
          context: context,
          message: 'Invalid backup file'.localized,
        );
      }
      return;
    }
    final content = await File(path).readAsBytes();
    final database = await databaseFile();
    await database.writeAsBytes(content);
    // restart app
    if (context.mounted) {
      unawaited(Restart.restartApp(webOrigin: '/'));
    }
  }

  Future<void> _roadmap(final BuildContext context) async {
    await const RoadmapScreenRoute().push<void>(context);
  }

  Future<void> _groupTags(final BuildContext context) async {
    await const TagGroupScreenRoute().push<void>(context);
  }

  Future<void> _tags(final BuildContext context) async {
    await context.basicPush<List<String>?>(
      TransactionTagsScreen(
        viewMode: true,
        title: 'Transaction Categories'.localized,
      ),
    );
  }

  Future<void> _labels(final BuildContext context) async {
    showTransactionLabelsSheet(
      context: context,
    );
  }

  void _dummyData() {
    unawaited(generateDummyData());
  }

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsTile(
            title: 'Currency'.localized,
            subtitle: wallet.currency.friendlyString,
            icon: const FaIcon(FontAwesomeIcons.circleDollarToSlot),
            onTap: () {
              unawaited(_selectCurrency(context));
            },
          ),
          ListTile(
            title: Text(
              'General Settings'.localized,
              style: context.titleMedium,
            ),
            subtitle: Text(
              'You can remove tags, labels, or groups from '
                      'the list by performing a long press on them.'
                  .localized,
              style: context.bodyExtraSmall?.apply(
                color: context.hintColor,
                fontWeightDelta: 1,
              ),
            ),
          ),
          SettingsTile(
            title: 'Categories'.localized,
            icon: const FaIcon(Icons.category),
            subtitle:
                'Organize transactions under predefined or custom categories'
                    .localized,
            onTap: () {
              unawaited(_tags(context));
            },
          ),
          SettingsTile(
            title: 'Category Groups'.localized,
            icon: const FaIcon(FontAwesomeIcons.layerGroup),
            subtitle:
                'Organize several categories within a main category'.localized,
            onTap: () {
              unawaited(_groupTags(context));
            },
          ),
          SettingsTile(
            title: 'Transaction Labels'.localized,
            icon: const FaIcon(FontAwesomeIcons.hashtag),
            subtitle: 'Labels you can use to tag any transaction'.localized,
            onTap: () {
              unawaited(_labels(context));
            },
          ),
          ListTile(
            title: Text(
              'Backup & Restore'.localized,
              style: context.titleMedium,
            ),
          ),
          SettingsTile(
            title: 'Backup'.localized,
            icon: const FaIcon(FontAwesomeIcons.fileArrowUp),
            subtitle: 'Export your data to a safe place'.localized,
            onTap: _backup,
          ),
          SettingsTile(
            title: 'Restore'.localized,
            icon: const FaIcon(FontAwesomeIcons.fileArrowDown),
            subtitle: 'Restore data from a file'.localized,
            onTap: () {
              unawaited(_restore(context));
            },
          ),
          ListTile(
            title: Text(
              'Other'.localized,
              style: context.titleMedium,
            ),
          ),
          SettingsTile(
            title: 'Roadmap'.localized,
            icon: const FaIcon(FontAwesomeIcons.listCheck),
            subtitle: 'Check what we have planned'.localized,
            onTap: () {
              unawaited(_roadmap(context));
            },
          ),
          if (kDebugMode)
            SettingsTile(
              title: 'Dummy Data'.localized,
              icon: const FaIcon(FontAwesomeIcons.dice),
              subtitle: 'Generate some random dummy data'.localized,
              onTap: _dummyData,
            ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String title;
  final FaIcon icon;
  final String subtitle;
  final void Function() onTap;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: context.bodySmall,
      ),
    );
  }
}
