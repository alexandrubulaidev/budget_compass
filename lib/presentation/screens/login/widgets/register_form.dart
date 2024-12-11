import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/app_localizations.dart';
import '../../../../utils/input_validation.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/biz_input_field.dart';
import '../../../widgets/base/button_container.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({
    required this.onLogin,
    required this.onRegister,
    super.key,
  });

  final void Function(
    String username,
    String email,
    String password,
  ) onRegister;

  final void Function() onLogin;

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _retypePassword = TextEditingController();

  void _register() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid) {
      onRegister(
        _username.text,
        _email.text,
        _password.text,
      );
    }
  }

  void _login() {
    onLogin();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: ButtonContainer(
        buttonText: 'Register'.localized,
        onButtonTap: _register,
        child: Column(
          children: [
            BizInputField(
              label: 'Username'.localized,
              prefixIcon: FontAwesomeIcons.solidUser,
              validator: usernameValidator,
              controller: _username,
            ),
            const SizedBox(height: 10),
            BizInputField(
              label: 'Email Address'.localized,
              prefixIcon: FontAwesomeIcons.solidEnvelope,
              keyboardType: TextInputType.emailAddress,
              validator: emailValidator,
              controller: _email,
            ),
            const SizedBox(height: 10),
            BizInputField(
              label: 'Password'.localized,
              prefixIcon: FontAwesomeIcons.key,
              obscureText: true,
              validator: passwordValidator,
              controller: _password,
            ),
            const SizedBox(height: 10),
            BizInputField(
              label: 'Retype Password'.localized,
              prefixIcon: FontAwesomeIcons.key,
              obscureText: true,
              validator: passwordValidator,
              controller: _retypePassword,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _login,
              child: Text(
                'Login'.localized,
                style: context.bodyMedium?.apply(
                  color: context.primaryColor,
                  fontWeightDelta: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
