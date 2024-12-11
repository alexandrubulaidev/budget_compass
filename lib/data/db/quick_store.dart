// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:get_storage/get_storage.dart';

const kSelectedWallet = 'kSelectedWallet';

class QuickStore {
  static late GetStorage _storage;

  static Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  static void write(final String key, final dynamic value) {
    if (value == null) {
      delete(key);
    } else {
      unawaited(_storage.write(key, value));
    }
  }

  static T? read<T>(final String key) {
    return _storage.read<T>(key);
  }

  static void delete(final String key) {
    unawaited(_storage.remove(key));
  }
}
