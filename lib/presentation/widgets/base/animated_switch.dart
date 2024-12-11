// ignore_for_file: avoid_positional_boolean_parameters

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AnimatedSwitch extends StatefulWidget {
  const AnimatedSwitch({
    required this.value,
    required this.onChange,
    this.activeColor,
    this.inactiveColor = Colors.grey,
    super.key,
  });

  final bool value;
  final void Function(bool value) onChange;
  final Color? activeColor;
  final Color inactiveColor;

  @override
  State<AnimatedSwitch> createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return AnimatedToggleSwitch<int>.dual(
      first: 0,
      second: 1,
      current: widget.value ? 1 : 0,
      onChanged: (final p0) {
        widget.onChange(p0 == 1);
      },
      colorBuilder: (final value) {
        return value == 1 ? Get.theme.primaryColor : Get.theme.disabledColor;
      },
      borderWidth: 1,
      borderColorBuilder: (final value) {
        return value == 1 ? Get.theme.primaryColor : Get.theme.disabledColor;
      },
      height: 25,
      dif: 0,
      indicatorSize: const Size(25, 25),
      iconRadius: 10,
      iconBuilder: (final value) {
        return FaIcon(
          value == 1 ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
          size: 15,
          color: Get.theme.scaffoldBackgroundColor,
        );
      },
    );
  }
}
