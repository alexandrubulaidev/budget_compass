import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleToggleButton extends StatefulWidget {
  const SimpleToggleButton({
    required this.text,
    this.isSelected = false,
    this.onChanged,
    super.key,
  });

  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final String text;

  @override
  State<SimpleToggleButton> createState() => _SimpleToggleButtonState();
}

class _SimpleToggleButtonState extends State<SimpleToggleButton> {
  bool _selected = false;

  @override
  void initState() {
    _selected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = !_selected;
        });
        widget.onChanged?.call(_selected);
      },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _selected
                ? Get.theme.colorScheme.primary
                : Get.theme.disabledColor,
            borderRadius: BorderRadius.circular(200),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
            child: Text(
              widget.text,
              style: Get.textTheme.bodyLarge!.apply(
                color: Get.theme.scaffoldBackgroundColor,
                fontWeightDelta: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
