import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/auth/auth_service.dart';
import '../../domain/auth/auth_state.dart';
import '../../domain/services.dart';
import '../routing/routes.dart';
import '../utilities.dart';
import '../widgets/loading/biz_loader.dart';

/// Screen containing log / fancy intro animation (later maybe).
/// This screen will show login / dashboard depending on AuthService
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Future<void> _waitForSession() async {
    await Services.get<AuthService>()
        .stateStream
        .firstWhere((final element) => element == AuthState.authenticated);
  }

  Future<void> _loadingAnimation() async {
    await Future<void>.delayed(
      const Duration(
        seconds: 1,
      ),
    );
  }

  Future<void> _contextInitialization() async {
    updateAndroidSystemBar();
  }

  void _navigateHome() {
    const DashboardScreenRoute().pushReplacement(context);
  }

  Future<void> _initialize() async {
    await _contextInitialization();
    // Will run in parallel until both are done
    await (_loadingAnimation(), _waitForSession()).wait;
    _navigateHome();
  }

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  @override
  Widget build(final BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox.square(
          dimension: 150,
          child: BizLoader(),
        ),
      ),
    );
  }
}
