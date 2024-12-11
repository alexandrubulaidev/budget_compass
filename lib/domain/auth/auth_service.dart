// ignore_for_file: close_sinks

import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/user.dart';
import '../../data/repository/user/user_repository.dart';
import '../services.dart';
import '../wallet/tags_service.dart';
import '../wallet/wallet_service.dart';
import 'auth_state.dart';

class AuthService implements BaseService {
  AuthService() {
    _init();
  }

  UserRepository get _userRepo => Services.get<UserRepository>();

  final _state = BehaviorSubject.seeded(AuthState.uninitialized);
  Stream<AuthState> get stateStream => _state.stream;
  AuthState get state => _state.value;

  final _user = BehaviorSubject<User?>.seeded(null);
  Stream<User?> get userStream => _user.stream;

  /// This throws if user is not logged in!
  User get user => _user.value!;

  @override
  void onDispose() {}

  void _init() {
    unawaited(_checkSession());
  }

  Future<void> _checkSession() async {
    var user = await _userRepo.currentUser();
    user ??= await _userRepo.create(uid: const Uuid().v4());
    await _setSession(user);
  }

  Future<void> _setSession(final User? user) async {
    Fimber.d(
      'Session changed from '
      '${_user.value?.uid} to '
      '${user?.uid}',
    );
    _user.value = user;
    // reset the wallet repository

    if (user == null) {
      _state.value = AuthState.unauthenticated;
      unawaited(Services.unregister<TagsService>());
      unawaited(Services.unregister<WalletService>());
    } else {
      _state.value = AuthState.authenticated;
      Services.register<TagsService>(TagsService(user: user));
      Services.register<WalletService>(WalletService(user: user));
    }
  }
}
