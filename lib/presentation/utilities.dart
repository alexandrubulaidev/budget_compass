// ignore_for_file: unnecessary_lambdas

import 'dart:async';
import 'dart:io' as io;
import 'dart:ui' as ui show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../application.dart';
import '../data/model/wallet_currency.dart';
import '../domain/extensions/wallet_currency_extension.dart';
import 'app_theme.dart';

void dismissKeyboard(final BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void updateSystemControlsColor({
  required final BuildContext context,
  required final Color controls,
  required final Color statusbar,
}) {
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: controls,
      statusBarColor: statusbar,
      statusBarIconBrightness: brightness,
      systemNavigationBarIconBrightness: brightness,
    ),
  );
}

Future<bool> assetExists(final String path) async {
  try {
    await rootBundle.load(path);
    return true;
  } catch (exception) {
    return false;
  }
}

Future<bool> fileExists(final String path) async {
  try {
    // ignore: avoid_slow_async_io
    final exists = await io.File(path).exists();
    if (exists) {
      return true;
    } else {
      return false;
    }
  } catch (exception) {
    return false;
  }
}

bool isSmallScreen(final BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return screenSize.shortestSide < 600;
}

bool isPortrait(final BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return screenSize.width < screenSize.height;
}

Future<Uint8List> capturePng(final GlobalKey globalKey) async {
  final boundary =
      globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    return Uint8List(0);
  }
  final image = await boundary.toImage();
  final byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
      as Future<ByteData>);
  final pngBytes = byteData.buffer.asUint8List();
  return pngBytes;
}

DateTime? getNearestDate(
  final List<DateTime> dates,
  final DateTime targetDate,
) {
  DateTime? nearestDate;
  // int index = 0;
  var prevDiff = -1;
  final targetTS = targetDate.millisecondsSinceEpoch;
  for (var i = 0; i < dates.length; i++) {
    final date = dates[i];
    final currentDiff = (date.millisecondsSinceEpoch - targetTS).abs();
    if (prevDiff == -1 || currentDiff < prevDiff) {
      prevDiff = currentDiff;
      nearestDate = date;
      // index = i;
    }
  }
  return nearestDate;
}

Future<io.File?> saveAsset({
  required final String url,
  required final String name,
}) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return null;
  }

  final response = await http.get(uri);

  final file = io.File('${(await getTemporaryDirectory()).path}/$name.png');
  await file.writeAsBytes(response.bodyBytes);

  return file;
}

String numberShortForm(final num number) {
  return NumberFormat.compact(
    locale: Application.locale,
  ).format(number);
}

String formatValue({
  required final num value,
  required final WalletCurrency currency,
  final int? digits,
}) {
  return '${value < 0 ? '-' : ''}'
      '${currency.symbolString}'
      '${value.abs().toStringAsFixed(digits ?? Application.decimals)}';
}

String percent({
  required final double value,
  required final double total,
  final int digits = 1,
}) {
  return '${((value / total) * 100).toStringAsFixed(digits)}%';
}

void updateAndroidSystemBar() {
  final brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  final isDarkMode = brightness == Brightness.dark;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor:
          (isDarkMode ? appThemeDark : appThemeLight).colorScheme.surface,
    ),
  );
}
