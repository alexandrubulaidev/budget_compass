import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../extensions/context_extension.dart';

class BizMonoLoader extends StatefulWidget {
  const BizMonoLoader({
    required this.size,
    super.key,
  });

  final double size;

  @override
  State<BizMonoLoader> createState() => _BizMonoLoaderState();
}

class _BizMonoLoaderState extends State<BizMonoLoader>
    with TickerProviderStateMixin {
  // Create a controller
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat(reverse: true);

  // Create an animation with value of type "double"
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCirc,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _animation,
        child: FaIcon(
          FontAwesomeIcons.compass,
          size: widget.size,
          color: context.primary,
        ),
      ),
    );
  }
}
