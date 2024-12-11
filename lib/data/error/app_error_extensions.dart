import '../../utils/app_localizations.dart';
import 'app_error.dart';

extension AppErrors on AppError {
  static AppError get login {
    return AppError(
      message: 'Please login first before accessing this section'.localized,
    );
  }
}
