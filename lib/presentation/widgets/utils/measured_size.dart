import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef OnWidgetSizeChange = void Function(Size size);

/// [MeasuredSize] Calculated the size of it's child in runtime.
/// Simply wrap your widget with [MeasuredSize] and listen to size changes
/// with [onChange].
class MeasuredSize extends StatefulWidget {
  const MeasuredSize({
    required this.onChange,
    required this.child,
    super.key,
  });

  /// Widget to calculate it's size.
  final Widget child;

  /// [onChange] will be called when the [Size] changes.
  /// [onChange] will return the value ONLY once if it didn't change, and it
  /// will NOT return a value if it's equals to [Size.zero]
  final OnWidgetSizeChange onChange;

  @override
  // ignore: library_private_types_in_public_api, TODO: fix.
  _MeasuredSizeState createState() => _MeasuredSizeState();
}

class _MeasuredSizeState extends State<MeasuredSize> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  GlobalKey<State<StatefulWidget>> widgetKey = GlobalKey();
  Size? oldSize;

  Future<void> postFrameCallback(final dynamic _) async {
    final context = widgetKey.currentContext;
    if (context == null) {
      return;
    }
    await Future<void>.delayed(
      const Duration(milliseconds: 100),
    );
    if (context.mounted) {
      final newSize = context.size ?? Size.zero;
      if (newSize == Size.zero) {
        return;
      }
      if (oldSize == newSize) {
        return;
      }
      oldSize = newSize;
      widget.onChange(newSize);
    }
  }
}
