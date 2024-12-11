// ignore_for_file: no_default_cases

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_ext/list_ext.dart';

import '../../data/model/wallet_currency.dart';

extension WalletCurrencyExtension on WalletCurrency {
  String get userString {
    switch (this) {
      case WalletCurrency.usd:
        return 'USD';
      case WalletCurrency.eur:
        return 'EUR';
      case WalletCurrency.gbp:
        return 'GBP';
      case WalletCurrency.jpy:
        return 'JPY';
      case WalletCurrency.aud:
        return 'AUD';
      case WalletCurrency.cad:
        return 'CAD';
      case WalletCurrency.chf:
        return 'CHF';
      case WalletCurrency.cny:
        return 'CNY';
      case WalletCurrency.sek:
        return 'SEK';
      case WalletCurrency.nzd:
        return 'NZD';
      case WalletCurrency.krw:
        return 'KRW';
      case WalletCurrency.trY:
        return 'TRY';
      case WalletCurrency.inr:
        return 'INR';
      case WalletCurrency.rub:
        return 'RUB';
      case WalletCurrency.brl:
        return 'BRL';
      case WalletCurrency.ron:
        return 'RON';
      case WalletCurrency.mxn:
        return 'MXN';
      case WalletCurrency.hkd:
        return 'HKD';
      case WalletCurrency.sgd:
        return 'SGD';
      case WalletCurrency.zar:
        return 'ZAR';
      case WalletCurrency.aed:
        return 'AED';
      case WalletCurrency.sar:
        return 'SAR';
      case WalletCurrency.egp:
        return 'EGP';
      case WalletCurrency.thb:
        return 'THB';
      case WalletCurrency.idr:
        return 'IDR';
      case WalletCurrency.myr:
        return 'MYR';
      case WalletCurrency.clp:
        return 'CLP';
      case WalletCurrency.ars:
        return 'ARS';
      case WalletCurrency.pen:
        return 'PEN';
      case WalletCurrency.uyu:
        return 'UYU';
      case WalletCurrency.cop:
        return 'COP';
      case WalletCurrency.php:
        return 'PHP';
      case WalletCurrency.vnd:
        return 'VND';
      case WalletCurrency.ils:
        return 'ILS';
      case WalletCurrency.ngn:
        return 'NGN';
      case WalletCurrency.kwd:
        return 'KWD';
      case WalletCurrency.qar:
        return 'QAR';
      case WalletCurrency.omr:
        return 'OMR';
      case WalletCurrency.bhd:
        return 'BHD';
      case WalletCurrency.srd:
        return 'SRD';
      case WalletCurrency.kzt:
        return 'KZT';
      case WalletCurrency.uah:
        return 'UAH';
      case WalletCurrency.gel:
        return 'GEL';
      case WalletCurrency.jod:
        return 'JOD';
      case WalletCurrency.pln:
        return 'PLN';
      case WalletCurrency.czk:
        return 'CZK';
      case WalletCurrency.huf:
        return 'HUF';
      default:
        return '';
    }
  }

  String get symbolString {
    switch (this) {
      case WalletCurrency.usd:
        return r'$';
      case WalletCurrency.eur:
        return '€';
      case WalletCurrency.gbp:
        return '£';
      case WalletCurrency.jpy:
        return '¥';
      case WalletCurrency.aud:
        return r'$';
      case WalletCurrency.cad:
        return r'$';
      case WalletCurrency.chf:
        return 'CHF';
      case WalletCurrency.cny:
        return '¥';
      case WalletCurrency.sek:
        return 'kr';
      case WalletCurrency.nzd:
        return r'$';
      case WalletCurrency.krw:
        return '₩';
      case WalletCurrency.trY:
        return '₺';
      case WalletCurrency.inr:
        return '₹';
      case WalletCurrency.rub:
        return '₽';
      case WalletCurrency.brl:
        return r'R$';
      case WalletCurrency.ron:
        return 'RON';
      case WalletCurrency.mxn:
        return 'MXN';
      case WalletCurrency.hkd:
        return 'HKD';
      case WalletCurrency.sgd:
        return 'SGD';
      case WalletCurrency.zar:
        return 'ZAR';
      case WalletCurrency.aed:
        return 'AED';
      case WalletCurrency.sar:
        return 'SAR';
      case WalletCurrency.egp:
        return 'EGP';
      case WalletCurrency.thb:
        return 'THB';
      case WalletCurrency.idr:
        return 'IDR';
      case WalletCurrency.myr:
        return 'MYR';
      case WalletCurrency.clp:
        return 'CLP';
      case WalletCurrency.ars:
        return 'ARS';
      case WalletCurrency.pen:
        return 'PEN';
      case WalletCurrency.uyu:
        return 'UYU';
      case WalletCurrency.cop:
        return 'COP';
      case WalletCurrency.php:
        return 'PHP';
      case WalletCurrency.vnd:
        return '₫';
      case WalletCurrency.ils:
        return '₪';
      case WalletCurrency.ngn:
        return '₦';
      case WalletCurrency.kwd:
        return 'KWD';
      case WalletCurrency.qar:
        return 'QAR';
      case WalletCurrency.omr:
        return 'OMR';
      case WalletCurrency.bhd:
        return 'BHD';
      case WalletCurrency.srd:
        return 'SRD';
      case WalletCurrency.kzt:
        return 'KZT';
      case WalletCurrency.uah:
        return '₴';
      case WalletCurrency.gel:
        return 'GEL';
      case WalletCurrency.jod:
        return 'JOD';
      case WalletCurrency.pln:
        return 'zł';
      case WalletCurrency.czk:
        return 'Kč';
      case WalletCurrency.huf:
        return 'Ft';
      default:
        return '';
    }
  }

  String get friendlyString {
    switch (this) {
      case WalletCurrency.usd:
        return 'United States Dollar';
      case WalletCurrency.eur:
        return 'Euro';
      case WalletCurrency.gbp:
        return 'British Pound Sterling';
      case WalletCurrency.jpy:
        return 'Japanese Yen';
      case WalletCurrency.aud:
        return 'Australian Dollar';
      case WalletCurrency.cad:
        return 'Canadian Dollar';
      case WalletCurrency.chf:
        return 'Swiss Franc';
      case WalletCurrency.cny:
        return 'Chinese Yuan';
      case WalletCurrency.sek:
        return 'Swedish Krona';
      case WalletCurrency.nzd:
        return 'New Zealand Dollar';
      case WalletCurrency.krw:
        return 'South Korean Won';
      case WalletCurrency.trY:
        return 'Turkish Lira';
      case WalletCurrency.inr:
        return 'Indian Rupee';
      case WalletCurrency.rub:
        return 'Russian Ruble';
      case WalletCurrency.brl:
        return 'Brazilian Real';
      case WalletCurrency.ron:
        return 'Romanian Leu';
      case WalletCurrency.mxn:
        return 'Mexican Peso';
      case WalletCurrency.hkd:
        return 'Hong Kong Dollar';
      case WalletCurrency.sgd:
        return 'Singapore Dollar';
      case WalletCurrency.zar:
        return 'South African Rand';
      case WalletCurrency.aed:
        return 'United Arab Emirates Dirham';
      case WalletCurrency.sar:
        return 'Saudi Riyal';
      case WalletCurrency.egp:
        return 'Egyptian Pound';
      case WalletCurrency.thb:
        return 'Thai Baht';
      case WalletCurrency.idr:
        return 'Indonesian Rupiah';
      case WalletCurrency.myr:
        return 'Malaysian Ringgit';
      case WalletCurrency.clp:
        return 'Chilean Peso';
      case WalletCurrency.ars:
        return 'Argentine Peso';
      case WalletCurrency.pen:
        return 'Peruvian Nuevo Sol';
      case WalletCurrency.uyu:
        return 'Uruguayan Peso';
      case WalletCurrency.cop:
        return 'Colombian Peso';
      case WalletCurrency.php:
        return 'Philippine Peso';
      case WalletCurrency.vnd:
        return 'Vietnamese Dong';
      case WalletCurrency.ils:
        return 'Israeli New Shekel';
      case WalletCurrency.ngn:
        return 'Nigerian Naira';
      case WalletCurrency.kwd:
        return 'Kuwaiti Dinar';
      case WalletCurrency.qar:
        return 'Qatari Riyal';
      case WalletCurrency.omr:
        return 'Omani Rial';
      case WalletCurrency.bhd:
        return 'Bahraini Dinar';
      case WalletCurrency.srd:
        return 'Surinamese Dollar';
      case WalletCurrency.kzt:
        return 'Kazakhstani Tenge';
      case WalletCurrency.uah:
        return 'Ukrainian Hryvnia';
      case WalletCurrency.gel:
        return 'Georgian Lari';
      case WalletCurrency.jod:
        return 'Jordanian Dinar';
      case WalletCurrency.pln:
        return 'Polish Złoty';
      case WalletCurrency.czk:
        return 'Czech Koruna';
      case WalletCurrency.huf:
        return 'Hungarian Forint';
      default:
        return '';
    }
  }

  IconData? get icon {
    switch (this) {
      case WalletCurrency.usd:
        return FontAwesomeIcons.dollarSign;
      case WalletCurrency.eur:
        return FontAwesomeIcons.euroSign;
      case WalletCurrency.gbp:
        return FontAwesomeIcons.sterlingSign;
      case WalletCurrency.jpy:
        return FontAwesomeIcons.yenSign;
      case WalletCurrency.aud:
        return FontAwesomeIcons.dollarSign;
      case WalletCurrency.cad:
        return FontAwesomeIcons.dollarSign;
      case WalletCurrency.chf:
        return FontAwesomeIcons.dollarSign;
      case WalletCurrency.cny:
        return FontAwesomeIcons.yenSign;
      case WalletCurrency.sek:
        return FontAwesomeIcons.k;
      case WalletCurrency.nzd:
        return FontAwesomeIcons.dollarSign;
      case WalletCurrency.trY:
        return FontAwesomeIcons.turkishLiraSign;
      case WalletCurrency.inr:
        return FontAwesomeIcons.rupeeSign;
      case WalletCurrency.rub:
        return FontAwesomeIcons.rubleSign;
      case WalletCurrency.brl:
        return FontAwesomeIcons.brazilianRealSign;
      // case WalletCurrency.ron:
      //   return FontAwesomeIcons.moneyBillWave;
      case WalletCurrency.mxn:
        return FontAwesomeIcons.pesoSign;
      // case WalletCurrency.hkd:
      //   return FontAwesomeIcons.dollarSign;
      // case WalletCurrency.sgd:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.zar:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.aed:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.sar:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.egp:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.thb:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.idr:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.myr:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.clp:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.ars:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.pen:
      //   return FontAwesomeIcons.moneyBillWave;
      case WalletCurrency.uyu:
        return FontAwesomeIcons.moneyBillWave;
      case WalletCurrency.cop:
        return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.php:
      //   return FontAwesomeIcons.moneyBillWave;
      case WalletCurrency.vnd:
        return FontAwesomeIcons.dongSign;
      case WalletCurrency.ils:
        return FontAwesomeIcons.shekelSign;
      case WalletCurrency.ngn:
        return FontAwesomeIcons.nairaSign;
      // case WalletCurrency.kwd:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.qar:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.omr:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.bhd:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.srd:
      //   return FontAwesomeIcons.moneyBillWave;
      case WalletCurrency.kzt:
        return FontAwesomeIcons.tengeSign;
      case WalletCurrency.uah:
        return FontAwesomeIcons.hryvniaSign;
      case WalletCurrency.gel:
        return FontAwesomeIcons.lariSign;
      case WalletCurrency.jod:
        return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.pln:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.czk:
      //   return FontAwesomeIcons.moneyBillWave;
      // case WalletCurrency.huf:
      //   return FontAwesomeIcons.moneyBillWave;
      default:
        return null;
    }
  }

  String get stringValue => toString().split('.').last;

  static WalletCurrency? fromString(final String? string) =>
      WalletCurrency.values.firstWhereOrNull(
        (final element) =>
            element.stringValue.toLowerCase() == string?.toLowerCase(),
      );
}
