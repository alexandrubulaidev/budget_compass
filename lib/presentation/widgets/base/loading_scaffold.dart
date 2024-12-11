import 'package:flutter/material.dart';

import '../loading/biz_mono_loader.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key});

  @override
  Widget build(final BuildContext context) {
    return const Scaffold(
      body: Center(
        child: BizMonoLoader(
          size: 50,
        ),
      ),
    );
  }
}
