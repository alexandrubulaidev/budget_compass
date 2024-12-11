// ignore_for_file: inference_failure_on_untyped_parameter

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';

class RxBuilder2<T, E> extends StatefulWidget {
  const RxBuilder2({
    required this.subject1,
    required this.subject2,
    required this.builder,
    this.error,
    super.key,
  });

  final Stream<T> subject1;
  final Stream<E> subject2;
  final Widget Function(BuildContext context, T value1, E value2) builder;
  final Widget Function(BuildContext context, Exception? value)? error;

  @override
  State<RxBuilder2<T, E>> createState() => _RxBuilder2State<T, E>();
}

class _RxBuilder2State<T, E> extends State<RxBuilder2<T, E>> {
  StreamSubscription<T>? _subscription1;
  StreamSubscription<E>? _subscription2;
  late T _value1;
  late E _value2;
  Exception? _error;

  @override
  void initState() {
    super.initState();

    _subscription1 = widget.subject1.listen(
      (final value) {
        setState(() {
          _value1 = value;
        });
      },
      onError: (final error) {
        setState(() {
          _error = error as Exception? ??
              Exception(
                'Unexpected Error'.localized,
              );
        });
      },
    );

    _subscription2 = widget.subject2.listen(
      (final value) {
        setState(() {
          _value2 = value;
        });
      },
      onError: (final error) {
        setState(() {
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
    unawaited(_subscription1?.cancel());
    unawaited(_subscription2?.cancel());
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final errorBuilder = widget.error;
    if (_error == null || errorBuilder == null) {
      return widget.builder(context, _value1, _value2);
    }
    return errorBuilder(context, _error);
  }
}
