import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/transaction.dart';
import '../model/transaction_label.dart';
import '../model/transaction_tag.dart';
import '../model/transaction_tag_group.dart';
import '../model/user.dart';
import '../model/wallet.dart';

class DatabaseException implements Exception {
  DatabaseException(this.message);
  final String message;
}

const kDatabaseFileName = 'biz-database';

Future<File> databaseFile() async {
  return File(await databaseFilePath());
}

Future<String> databaseFilePath() async {
  return '${(await databaseDirectory()).path}/$kDatabaseFileName.isar';
}

Future<Directory> databaseDirectory() async {
  return getApplicationDocumentsDirectory();
}

/// See QuickSave extension when adding new schemas
Future<Isar> createDatabase() async {
  final directory = await databaseDirectory();
  final isar = await Isar.open(
    [
      UserSchema,
      WalletSchema,
      TransactionSchema,
      TransactionLabelSchema,
      TransactionTagSchema,
      TransactionTagGroupSchema,
    ],
    directory: directory.path,
    name: kDatabaseFileName,
  );
  return isar;
}
