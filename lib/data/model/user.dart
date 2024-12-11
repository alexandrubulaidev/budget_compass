import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  User({
    required this.createdAt,
    required this.uid,
  });

  Id id = Isar.autoIncrement;
  String uid;
  int createdAt;
}
