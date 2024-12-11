import '../../utils/app_localizations.dart';

class AppError implements Exception {
  AppError({required this.message});

  final String message;
}

class UnexpectedError extends AppError {
  UnexpectedError()
      : super(
          message: 'An unexpected error ocurred'.localized,
        );
}

class ServerParsingError extends AppError {
  ServerParsingError()
      : super(
          message: "There was a problem understanding the server's response"
              .localized,
        );
}

class OfflineError extends AppError {
  OfflineError()
      : super(
          message:
              'Please check your internet connection then try again'.localized,
        );
}

class NoWalletError extends AppError {
  NoWalletError()
      : super(
          message: 'You have no wallet selected. Please select a wallet first.'
              .localized,
        );
}
