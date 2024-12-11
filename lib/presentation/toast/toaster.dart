import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import 'simple_toast.dart';

Future<void> showToast({
  required final BuildContext context,
  required final String message,
  final bool error = false,
}) async {
  SimpleToast(
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: error ? context.errorColor : context.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: context.titleMedium?.apply(
          color: context.onPrimary,
          fontWeightDelta: 2,
        ),
      ),
    ),
  ).show(context: context);
}
