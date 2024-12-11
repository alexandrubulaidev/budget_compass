import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/services.dart';
import '../../domain/wallet/tags_service.dart';
import '../../utils/app_localizations.dart';
import 'base/simple_dialog_helpers.dart';

/// This will ask the user to delete the label AND delete it on confirm.
/// Returns true when label was deleted.
Future<bool> showDeleteTagDialog({
  required final BuildContext context,
  required final int id,
}) async {
  final completer = Completer<bool>();
  unawaited(
    showConfirmationDialog(
      context: context,
      message: 'Are you sure you want to delete this category? '
              'This action is irreversible and it will also remove it '
              'from all of your transactions.'
          .localized,
      confirmTitle: 'Yes'.localized,
      declineTitle: 'Cancel'.localized,
    ).then((final result) async {
      if (result) {
        final service = Services.get<TagsService>();
        final result = await service.deleteTag(
          id: id,
        );
        if (result == null) {
          completer.complete(true);
        } else {
          if (context.mounted) {
            await showErrorDialog(
              context: context,
              message: result.message,
            );
          }
          completer.complete(false);
        }
      } else {
        completer.complete(false);
      }
    }),
  );
  return completer.future;
}
