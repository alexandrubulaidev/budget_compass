// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../domain/services.dart';
import '../../../utils/app_localizations.dart';
import '../../dialog/base/simple_dialog_helpers.dart';
import '../../routing/routes.dart';
import '../../widgets/base/coin.dart';
import 'login_screen_controller.dart';
import 'widgets/login_form.dart';
import 'widgets/register_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = Services.register<LoginScreenController>(
    LoginScreenController(),
  );

  bool _isLogin = true;

  Future<void> _login({
    required final String username,
    required final String password,
  }) async {
    final result = await _controller.login(
      username: username,
      password: password,
    );
    if (result == null) {
      if (context.mounted) {
        const DashboardScreenRoute().replace(context);
      }
    } else {
      unawaited(
        showMessageDialog(
          context: context,
          buttonTitle: 'Ok'.localized,
          title: 'Failed'.localized,
          message: result.message,
        ),
      );
    }
  }

  Future<void> _register({
    required final String username,
    required final String email,
    required final String password,
  }) async {
    final result = await _controller.register(
      email: email,
      username: username,
      password: password,
    );
    if (result == null) {
      if (context.mounted) {
        const DashboardScreenRoute().replace(context);
      }
    } else {
      unawaited(
        showMessageDialog(
          context: context,
          buttonTitle: 'Ok'.localized,
          title: 'Failed'.localized,
          message: result.message,
        ),
      );
    }
  }

  void _showRegister() {
    setState(() {
      _isLogin = false;
    });
  }

  void _showLogin() {
    setState(() {
      _isLogin = true;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final coins = [
      Positioned(
        left: -20,
        top: -80,
        child: Transform.rotate(
          angle: pi * 0.44,
          child: const Coin(
            size: 200,
          ),
        ),
      ),
      Positioned(
        right: -80,
        top: -130,
        child: Transform.rotate(
          angle: pi * 0.14,
          child: const Coin(
            size: 350,
          ),
        ),
      ),
      Positioned(
        left: -20,
        bottom: -20,
        child: Transform.rotate(
          angle: pi * 0.15,
          child: const Coin(
            size: 120,
          ),
        ),
      ),
      Positioned(
        left: 100,
        bottom: 100,
        child: Transform.rotate(
          angle: pi * 0.35,
          child: const Coin(
            size: 70,
          ),
        ),
      ),
    ];

    final loginForm = LoginForm(
      onLogin: (final username, final password) async {
        unawaited(
          _login(
            username: username,
            password: password,
          ),
        );
      },
      onRegister: _showRegister,
    );

    final registerForm = RegisterForm(
      onLogin: _showLogin,
      onRegister: (final username, final email, final password) {
        unawaited(
          _register(
            username: username,
            email: email,
            password: password,
          ),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          ...coins,
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  // transitionBuilder: (child, animation) {
                  //   return SlideTransition(
                  //     position: Tween<Offset>(
                  //       begin: Offset(_isLogin ? -1 : 1, 0),
                  //       end: Offset(0, 0),
                  //     ).animate(animation),
                  //     child: child,
                  //   );
                  // },
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  child: _isLogin ? loginForm : registerForm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
