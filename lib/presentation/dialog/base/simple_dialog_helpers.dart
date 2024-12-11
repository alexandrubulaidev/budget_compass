import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../extensions/context_extension.dart';
import 'simple_dialog.dart';

Future<bool> showConfirmationDialog({
  required final BuildContext context,
  required final String confirmTitle,
  required final String declineTitle,
  final String? title,
  final String? message,
  final Widget? body,
  final bool barrierDismissible = false,
  final bool useSafeArea = true,
  final bool useRootNavigator = true,
}) async {
  final completer = Completer<bool>();
  unawaited(
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      builder: (final context) {
        return SimpleAlertDialog(
          title: title,
          message: message,
          body: body,
          actions: [
            SimpleAction(
              text: declineTitle,
              color: context.errorColor,
              onTap: () => completer.complete(false),
            ),
            SimpleAction(
              text: confirmTitle,
              onTap: () => completer.complete(true),
            ),
          ],
        );
      },
    ),
  );
  return completer.future;
}

Future<void> showErrorDialog({
  required final BuildContext context,
  final String? buttonTitle,
  final String? title,
  final String? message,
  final Widget? body,
  final bool barrierDismissible = false,
  final bool useSafeArea = true,
  final bool useRootNavigator = true,
}) {
  final completer = Completer<void>();
  unawaited(
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      builder: (final context) {
        return SimpleAlertDialog(
          title: title ?? 'Failed'.localized,
          message: message,
          body: body,
          actions: [
            SimpleAction(
              text: buttonTitle ?? 'Ok'.localized,
              onTap: completer.complete,
              color: context.errorColor,
            ),
          ],
        );
      },
    ),
  );
  return completer.future;
}

Future<void> showMessageDialog({
  required final BuildContext context,
  required final String buttonTitle,
  final String? title,
  final String? message,
  final Widget? body,
  final bool barrierDismissible = false,
  final bool useSafeArea = true,
  final bool useRootNavigator = true,
}) async {
  final completer = Completer<void>();
  unawaited(
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      builder: (final context) {
        return SimpleAlertDialog(
          title: title,
          message: message,
          body: body,
          actions: [
            SimpleAction(
              text: buttonTitle,
              onTap: completer.complete,
            ),
          ],
        );
      },
    ),
  );
  return completer.future;
}
