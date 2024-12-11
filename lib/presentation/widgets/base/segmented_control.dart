// ignore_for_file: avoid_positional_boolean_parameters, use_decorated_box

import 'package:flutter/material.dart';

class SegmentControl extends StatelessWidget {
  const SegmentControl({
    required this.tabBuilder,
    required this.count,
    required this.selected,
    this.height = 40,
    this.selectedIndex = 0,
    this.borderWidth = 1,
    this.width = double.infinity,
    this.normalBackgroundColor = Colors.white,
    this.activeBackgroundColor = Colors.blue,
    this.normalTitleColor = Colors.blue,
    this.activeTitleColor = Colors.white,
    this.normalTitleStyle = const TextStyle(fontSize: 16, color: Colors.blue),
    this.activeTitleStyle = const TextStyle(fontSize: 18, color: Colors.white),
    this.radius = 0,
    this.borderColor = Colors.blue,
    this.selectNone = false,
  });
  final double height;
  final double width;
  final int count;
  final int selectedIndex;
  final Widget Function(int index, bool selected) tabBuilder;
  final void Function(int) selected;
  final Color normalBackgroundColor;
  final Color activeBackgroundColor;
  final Color normalTitleColor;
  final Color activeTitleColor;
  final TextStyle normalTitleStyle;
  final TextStyle activeTitleStyle;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final bool selectNone;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 1),
          child: Row(
            children: <Widget>[
              for (int i = 0; i < count; i++)
                // for (var tabName in widget.tabs)
                ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      selected(i);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: (i == selectedIndex && !selectNone)
                            ? activeBackgroundColor
                            : normalBackgroundColor,
                      ),
                      child: Center(
                        child: tabBuilder(i, selectedIndex == i),
                      ),
                    ),
                  ),
                ),
                if (i != count - 1)
                  Container(
                    width: 1,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: activeBackgroundColor,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
