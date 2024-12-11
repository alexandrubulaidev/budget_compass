// ignore_for_file: inference_failure_on_untyped_parameter

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';

/// Subscribes to the [subject] and invokes the builder on new values.
/// On error it will invoke the [error] builder instead if it's not null.
class RxBuilder<T> extends StatefulWidget {
  const RxBuilder({
    required this.subject,
    required this.builder,
    this.error,
    super.key,
  });

  final Stream<T> subject;
  final Widget Function(BuildContext context, T value) builder;
  final Widget Function(BuildContext context, Exception? value)? error;

  @override
  State<RxBuilder<T>> createState() => _RxBuilderState<T>();
}

class _RxBuilderState<T> extends State<RxBuilder<T>> {
  StreamSubscription<T>? _subscription;
  late T _value;
  bool _initialized = false;
  Exception? _error;

  @override
  void initState() {
    super.initState();
    _subscription = widget.subject.listen(
      (final value) {
        setState(() {
          _initialized = true;
          _value = value;
        });
      },
      onError: (final error) {
        setState(() {
          _initialized = true;
          _error = error as Exception? ??
              Exception(
                'Unexpected Error'.localized,
              );
        });
      },
    );
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (!_initialized) {
      return Container();
    }
    final errorBuilder = widget.error;
    if (_error == null || errorBuilder == null) {
      return widget.builder(context, _value);
    }
    return errorBuilder(context, _error);
  }
}
