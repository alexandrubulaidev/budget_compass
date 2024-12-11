// ignore_for_file: inference_failure_on_untyped_parameter

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';

class MultiRxBuilder extends StatefulWidget {
  const MultiRxBuilder({
    required this.subjects,
    required this.builder,
    this.error,
    super.key,
  });

  final List<Stream<dynamic>> subjects;
  final Widget Function(BuildContext context, List<dynamic> values) builder;
  final Widget Function(BuildContext context, Exception? value)? error;

  @override
  State<MultiRxBuilder> createState() => _MultiRxBuilderState();
}

class _MultiRxBuilderState extends State<MultiRxBuilder> {
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final _values = <int, dynamic>{};
  Exception? _error;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.subjects.length; i++) {
      _subscriptions.add(
        widget.subjects[i].listen(
          (final value) {
            setState(() {
              _values[i] = value;
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
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (_values.values.length != widget.subjects.length) {
      return Container();
    }
    final errorBuilder = widget.error;
    if (_error == null || errorBuilder == null) {
      return widget.builder(context, _values.values.toList());
    }
    return errorBuilder(context, _error);
  }
}
