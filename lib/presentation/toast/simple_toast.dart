import 'dart:async';

import 'package:flutter/material.dart';

class SimpleToast extends StatefulWidget {
  const SimpleToast({
    required this.child,
    this.animationDuration = const Duration(milliseconds: 500),
    this.toastDuration = const Duration(seconds: 2),
    this.onDismiss,
  });

  final Widget child;
  final Duration animationDuration;
  final Duration toastDuration;
  final VoidCallback? onDismiss;

  @override
  State<SimpleToast> createState() => _SimpleToastState();

  void show({
    required final BuildContext context,
  }) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (final context) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: SimpleToast(
                animationDuration: animationDuration,
                onDismiss: () {
                  overlayEntry?.remove();
                },
                child: child,
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(overlayEntry);
  }
}

class _SimpleToastState extends State<SimpleToast>
    with TickerProviderStateMixin {
  late Animation<Offset> offsetAnimation;
  late AnimationController slideController;
  late BoxDecoration toastDecoration;
  Timer? autoDismissTimer;

  void _startDismissTimer() {
    autoDismissTimer = Timer(widget.toastDuration, () async {
      await slideController.reverse();
      widget.onDismiss?.call();
    });
  }

  void _initAnimation() {
    slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: slideController,
        curve: Curves.ease,
      ),
    );
    slideController.forward();
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _startDismissTimer();
  }

  @override
  void dispose() {
    autoDismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: widget.child,
    );
  }
}
