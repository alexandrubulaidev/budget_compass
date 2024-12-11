import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/app_localizations.dart';
import '../../../../utils/input_validation.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/biz_input_field.dart';
import '../../../widgets/base/button_container.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    required this.onLogin,
    required this.onRegister,
    super.key,
  });

  final void Function(
    String username,
    String password,
  ) onLogin;

  final void Function() onRegister;

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  void _login() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid) {
      onLogin(_username.text, _password.text);
    }
  }

  void _register() {
    onRegister();
  }

  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: ButtonContainer(
        buttonText: 'Login'.localized,
        onButtonTap: _login,
        child: Column(
          children: [
            // Text(
            //   'Hello There!',
            //   style: context.headlineLarge,
            // ),
            // const SizedBox(height: 30),
            BizInputField(
              label: 'Username'.localized,
              keyboardType: TextInputType.text,
              prefixIcon: FontAwesomeIcons.solidUser,
              validator: (final text) {
                if (text?.trim() == '') {
                  return 'Invalid Username'.localized;
                }
                return null;
              },
              controller: _username,
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
            TextButton(
              onPressed: _register,
              child: Text(
                'Create Account'.localized,
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
