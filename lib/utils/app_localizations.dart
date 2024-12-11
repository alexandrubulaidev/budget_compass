// TODO - add localization
import 'dart:async';
import 'dart:convert';

import 'package:devicelocale/devicelocale.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_ext/list_ext.dart';
import 'package:rxdart/subjects.dart';
import 'package:sprintf/sprintf.dart';

import '../data/db/quick_store.dart';

// ignore: avoid_classes_with_only_static_members, TODO: fix.
class AppLocalizations {
  static const Locale defaultLocale = Locale('en', 'US');
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
  static final currentLocale = BehaviorSubject<Locale>.seeded(defaultLocale);

  static Map<String, String> _appStrings = {};
  static List<Locale> get supportedLocale =>
      [defaultLocale, const Locale('es', 'MX')];
  static Locale? Function(Locale?, Iterable<Locale>)
      get localeResolutionCallback => _localeResolutionCallback;

  static final Locale? Function(Locale?, Iterable<Locale>)
      // ignore: prefer_function_declarations_over_variables, TODO: fix.
      _localeResolutionCallback = (final locale, final supportedLocals) {
    for (final supportedLocale in supportedLocals) {
      if (supportedLocale.languageCode == locale?.languageCode &&
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }

    return AppLocalizations.defaultLocale; // Default app language is English
  };

  static Future<void> initialize() async {
    await checkSessionLocale();
  }

  static Future<void> checkSessionLocale() async {
    final locale = await deviceLocale();
    if (locale != null) {
      await load(locale: locale);
    }
  }

  static Future<Locale?> deviceLocale() async {
    final languageCode = QuickStore.read<String>('locale');

    return supportedLocale.firstWhereOrNull(
          (final element) =>
              element.languageCode.toLowerCase() == languageCode?.toLowerCase(),
        ) ??
        await Devicelocale.currentAsLocale;
  }

  static Future<void> updateLocale({required final Locale locale}) async {
    QuickStore.write('locale', locale.languageCode);
    await load(locale: locale);
  }

  static Future<AppLocalizations> load({required final Locale locale}) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/lang/${locale.languageCode}.json',
      );
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>? ??
          <String, dynamic>{};
      _appStrings = jsonMap.map(
        (final key, final dynamic value) => MapEntry(key, value.toString()),
      );
    } catch (e) {
      Fimber.d('assets/lang/${locale.languageCode}.json is missing');
    }
    if (currentLocale.value.languageCode != locale.languageCode) {
      currentLocale.add(locale);
    }

    return AppLocalizations();
  }

  static String translate(final String key) {
    final value = _appStrings[key];
    if (value != null) {
      return value;
    }

    return key;
  }

  static bool canTranslate(final String key) {
    final value = _appStrings[key];
    if (value == null) {
      return false;
    }

    return true;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(final Locale locale) => AppLocalizations.supportedLocale
      .map((final e) => e.languageCode.toLowerCase())
      .contains(locale.languageCode.toLowerCase());

  @override
  Future<AppLocalizations> load(final Locale locale) async {
    final deviceLocale = (await AppLocalizations.deviceLocale()) ?? locale;

    return AppLocalizations.load(locale: deviceLocale);
  }

  @override
  bool shouldReload(final LocalizationsDelegate<AppLocalizations> old) => true;
}

extension Localization on String {
  String get localized => AppLocalizations.translate(this);
}

extension StringUtils on String {
  String formatted(final dynamic args) {
    return sprintf(this, args);
  }
}
