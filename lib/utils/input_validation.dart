import 'app_localizations.dart';

String? emailValidator(final String? email) {
  final error = 'Invalid Email'.localized;
  // Check if the email is null or empty
  if (email == null || email.isEmpty) {
    return error;
  }

  // Check for invalid characters in the email
  final invalidCharacters = RegExp('[^a-zA-Z0-9@._-]');
  if (invalidCharacters.hasMatch(email)) {
    return error;
  }

  // Check if the email contains exactly one @ symbol
  final atSymbolCount = email.split('@').length - 1;
  if (atSymbolCount != 1) {
    return error;
  }

  // Check if the email contains at least one dot (.) after the @ symbol
  final lastDotIndex = email.lastIndexOf('.');
  final atSymbolIndex = email.indexOf('@');
  if (lastDotIndex == -1 || lastDotIndex < atSymbolIndex) {
    return error;
  }

  // Check if the email starts or ends with a dot (.)
  if (email.startsWith('.') || email.endsWith('.')) {
    return error;
  }

  // Check if the email contains consecutive dots (.)
  if (email.contains('..')) {
    return error;
  }

  return null; // Email is valid
}

String? passwordValidator(final String? password) {
  String? errorMessage;

  // Check if the password has at least 8 characters
  if (password == null || password.length < 8) {
    errorMessage = 'Password should have at least 8 characters'.localized;
  }

  // Check if the password contains at least one uppercase letter
  else if (!password.contains(RegExp('[A-Z]'))) {
    errorMessage =
        'Password should contain at least one uppercase letter'.localized;
  }

  // Check if the password contains at least one lowercase letter
  else if (!password.contains(RegExp('[a-z]'))) {
    errorMessage =
        'Password should contain at least one lowercase letter'.localized;
  }

  // Check if the password contains at least one digit
  else if (!password.contains(RegExp('[0-9]'))) {
    errorMessage = 'Password should contain at least one digit'.localized;
  }

  // Check if the password contains at least one special character
  else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    errorMessage =
        'Password should contain at least one special character'.localized;
  }

  return errorMessage;
}

String? usernameValidator(final String? username) {
  if (username == null || username.isEmpty) {
    return 'Username cannot be empty';
  }

  // Check for invalid characters in the username
  final invalidCharacters = RegExp(r'[^\w@.-]');
  if (invalidCharacters.hasMatch(username)) {
    return 'Username contains invalid characters';
  }

  return null; // Username is valid
}
