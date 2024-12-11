import 'package:isar/isar.dart';

import '../../../domain/services.dart';
import '../../model/user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  Isar get database => Services.get<Isar>();

  @override
  Future<User?> currentUser() async {
    return database.users.filter().uidIsNotEmpty().findFirst();
  }

  @override
  Future<User> create({
    required final String uid,
  }) async {
    final user = User(
      uid: uid,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await database.writeTxn<void>(() {
      return database.users.put(user);
    });

    return user;
  }
}
