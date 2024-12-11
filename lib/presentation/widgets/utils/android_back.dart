import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_move_task_back/flutter_move_task_back.dart';

class AndroidBack extends StatelessWidget {
  const AndroidBack({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
      onPopInvoked: (final _) {
        if (!kIsWeb) {
          if (Platform.isAndroid) {
            unawaited(FlutterMoveTaskBack.moveTaskToBack());
          }
        }
      },
    );
  }
}
