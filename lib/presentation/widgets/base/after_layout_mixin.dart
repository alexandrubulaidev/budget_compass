import 'dart:async';

import 'package:flutter/widgets.dart';

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) {
      afterFirstLayout(context);
    }
  }

  FutureOr<void> afterFirstLayout(final BuildContext context);
}
