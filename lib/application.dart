// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'data/db/database.dart';
import 'data/db/quick_store.dart';
import 'data/model/wallet_currency.dart';
import 'data/repository/user/user_repository.dart';
import 'data/repository/user/user_repository_impl.dart';
import 'domain/auth/auth_service.dart';
import 'domain/extensions/wallet_currency_extension.dart';
import 'domain/services.dart';
import 'firebase_options.dart';
import 'presentation/utilities.dart';
import 'utils/app_localizations.dart';

class Application {
  static WalletCurrency _currency = WalletCurrency.eur;
  static bool _isFirstRun = false;

  static WalletCurrency get defaultCurrency => _currency;
  static String get locale => Intl.systemLocale;
  static int get decimals => 2;
  static bool get isFirstRun => _isFirstRun;

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    // ignore: deprecated_member_use
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      // This callback is called every time the brightness changes.
      updateAndroidSystemBar();
    };

    final format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    _currency = WalletCurrencyExtension.fromString(format.currencyName) ??
        WalletCurrency.eur;

    // quick key value store
    await QuickStore.init();

    // is first run?
    const key = 'isFirstRun';
    _isFirstRun = QuickStore.read<bool>(key) ?? true;
    if (_isFirstRun) {
      QuickStore.write(key, false);
    }

    // locale
    await AppLocalizations.initialize();

    // core services
    await _registerServices();
  }

  static Future<void> _registerServices() async {
    // logging
    Fimber.plantTree(DebugTree.elapsed());

    // core
    await QuickStore.init();
    Services.register<Isar>(await createDatabase());

    // repositories
    // Services.register<WalletRepository>(WalletRepositoryImpl());
    Services.register<UserRepository>(UserRepositoryImpl());

    // services
    Services.register<AuthService>(AuthService());
  }
}
