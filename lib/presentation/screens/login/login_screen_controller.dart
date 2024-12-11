import '../../../data/error/app_error.dart';
import '../../../domain/services.dart';

class LoginScreenController implements BaseService {
  // AuthService get _service => Services.get<AuthService>();

  @override
  void onDispose() {}

  Future<AppError?> login({
    required final String username,
    required final String password,
  }) async {
    return null;
    // return _service.login(
    //   username: username,
    //   password: password,
    // );
  }

  Future<AppError?> register({
    required final String username,
    required final String email,
    required final String password,
  }) async {
    return null;
    // return _service.register(
    //   email: email,
    //   username: username,
    //   password: password,
    // );
  }
}
