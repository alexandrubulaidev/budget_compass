// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:get_it/get_it.dart';

/// A lightweight service locator class.
/// Inspired by get_it with the addition of tag
class Services {
  static final _getIt = GetIt.instance;

  /// Registers a service or returns the already registered service.
  /// Multiple instances of the same services can be achieved by
  /// supplying a unique [tag] for each.
  /// When [overwrite] is true it will replace the existing service (if any).
  static T register<T extends Object>(
    final Object object, {
    final String? tag,
    final bool overwrite = false,
  }) {
    final existing = tryGet<T>(tag);
    if (existing != null) {
      if (overwrite) {
        Fimber.d('existing & replacing: true ${object.runtimeType}');
        unawaited(unregister<T>(tag));
      } else {
        Fimber.d('existing & replacing: false ${object.runtimeType}');
        disposeService(object);
        return existing;
      }
    }

    Fimber.d('registered ${object.runtimeType}');
    _getIt.registerSingleton<T>(
      object as T,
      instanceName: tag,
      dispose: (final param) {
        disposeService(object);
      },
    );
    return object;
  }

  /// Get service by type and [tag].
  /// Note that supplying [tag] will look for a service
  /// of type [T] with that specific [tag] !!
  static T get<T extends Object>([final String? tag]) {
    try {
      return _getIt.get<T>(
        instanceName: tag,
      );
    } catch (_) {
      throw ServiceNotFoundException('singleton:$T');
    }
  }

  static T? tryGet<T extends Object>([final String? key]) {
    try {
      return get<T>(key);
    } catch (_) {}

    return null;
  }

  static Future<void> unregister<T extends Object>([final String? tag]) async {
    final instance = tryGet<T>();
    if (instance == null) {
      return;
    }
    _getIt.unregister(instance: instance);
    Fimber.d('unregistered ${instance.runtimeType}');
  }

  static void disposeService(final Object object) {
    if (object is BaseService) {
      Fimber.d('disposed ${object.runtimeType}');
      object.onDispose();
    }
  }
}

class ServiceNotFoundException implements Exception {
  ServiceNotFoundException(this.message);
  final String message;
}

class ServiceInvalidException implements Exception {
  ServiceInvalidException(this.message);
  final String message;
}

abstract class BaseService {
  void onDispose();
}
