import 'package:flutter/material.dart';

import '../utils/measured_size.dart';

class BizLoader extends StatefulWidget {
  const BizLoader({super.key});

  @override
  State<BizLoader> createState() => _BizLoaderState();
}

class _BizLoaderState extends State<BizLoader> with TickerProviderStateMixin {
  Size? _size;

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
    final measured = _size;
    return Stack(
      fit: StackFit.expand,
      children: [
        MeasuredSize(
          onChange: (final size) {
            if (_size == null || size.width != _size?.width) {
              setState(() {
                _size = size;
              });
            }
          },
          child: Image.asset(
            'assets/icon/icon_coin_without_compass.png',
          ),
        ),
        if (measured != null) ...[
          Center(
            child: SizedBox.square(
              dimension: measured.width * 0.55,
              child: RotationTransition(
                turns: _animation,
                child: Image.asset(
                  'assets/icon/icon_compass.png',
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
