import '../../model/user.dart';

abstract class UserRepository {
  Future<User> create({
    required final String uid,
  });

  Future<User?> currentUser();
}
