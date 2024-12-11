// ignore_for_file: implicit_dynamic_parameter

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/extensions/staggered_stream.dart';
import '../../../utils/app_localizations.dart';

/// Subscribes to the [subject] and invokes the builder on new values.
/// On error it will invoke the [error] builder instead if it's not null.
/// Stagger will make sure the builder isn't invoked more than
/// once every [stagger] duration.
class SubjectBuilder<T> extends StatefulWidget {
  const SubjectBuilder({
    required this.subject,
    required this.builder,
    this.error,
    this.stagger,
    super.key,
  });

  final Duration? stagger;
  final BehaviorSubject<T?> subject;
  final Widget Function(BuildContext context, T? value) builder;
  final Widget Function(BuildContext context, Exception? value)? error;

  @override
  State<SubjectBuilder<T>> createState() => _SubjectBuilderState<T>();
}

class _SubjectBuilderState<T> extends State<SubjectBuilder<T>> {
  StreamSubscription<T?>? _subscription;
  T? _value;
  Exception? _error;

  @override
  void initState() {
    super.initState();
    _value = widget.subject.value;

    final stagger = widget.stagger;
    Stream<T?> stream = widget.subject;
    if (stagger != null) {
      stream = stream.stagger(stagger);
    }
    _subscription = stream.listen(
      (final value) {
        setState(() {
          _value = value;
        });
      },
      onError: (final error) {
        setState(() {
          _error = widget.subject.errorOrNull as Exception? ??
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
    final errorBuilder = widget.error;
    if (_error == null || errorBuilder == null) {
      return widget.builder(context, _value);
    }

    return errorBuilder(context, _error);
  }
}
