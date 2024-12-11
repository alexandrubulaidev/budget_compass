// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../extensions/context_extension.dart';
import '../../utilities.dart';
import '../../widgets/base/animated_switch.dart';
import '../../widgets/base/ink_tap.dart';
import '../../widgets/base/simple_toggle_button.dart';

class MultiSelectorItem {
  MultiSelectorItem({
    required this.title,
    this.selected = false,
    this.onTap,
  });

  String title;
  bool selected = false;
  ValueChanged<bool>? onTap;
}

class SwitchItem {
  SwitchItem({
    required this.message,
    required this.selected,
    this.onSwitch,
  });
  String message;
  bool selected;
  void Function(bool value)? onSwitch;
}

class SimpleAction {
  SimpleAction({
    required this.text,
    this.color,
    this.onTap,
    this.onTapData,
  });
  String text;
  Color? color;
  void Function()? onTap;
  void Function(List<String> inputData, List<bool> switchData)? onTapData;
}

class SimpleAlertDialog extends StatefulWidget {
  const SimpleAlertDialog({
    super.key,
    this.actions = const [],
    this.title,
    this.message,
    this.inputs,
    this.selectors,
    this.body,
    this.switches,
    this.padding,
    this.dismissOnActionTap = true,
  });

  final List<SimpleAction> actions;
  final String? title;
  final String? message;
  final List<String>? inputs;
  final List<MultiSelectorItem>? selectors;
  final List<SwitchItem>? switches;
  final Widget? body;
  final bool dismissOnActionTap;
  final EdgeInsets? padding;

  @override
  State<SimpleAlertDialog> createState() => _SimpleAlertDialogState();
}

class _SimpleAlertDialogState extends State<SimpleAlertDialog> {
  List<TextEditingController> inputControllers = [];

  @override
  void initState() {
    if (widget.inputs != null) {
      inputControllers = [];
      for (final _ in widget.inputs!) {
        inputControllers.add(TextEditingController());
      }
    }
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final actionsWidgets = <Widget>[
      for (int index = 0; index < widget.actions.length; index++) ...[
        Flexible(
          child: InkTap(
            color: widget.actions[index].color ?? context.primary,
            borderRadius: BorderRadius.zero,
            onTap: () {
              if (widget.dismissOnActionTap) {
                Navigator.of(context).pop();
              }
              widget.actions[index].onTap?.call();
              widget.actions[index].onTapData?.call(
                inputControllers.map((final e) => e.text).toList(),
                widget.switches?.map((final e) => e.selected).toList() ?? [],
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  left: 8,
                  right: 8,
                ),
                child: Text(
                  widget.actions[index].text,
                  textAlign: TextAlign.center,
                  style: context.titleMedium?.apply(
                    color: context.dialogBackgroundColor,
                    fontWeightDelta: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        // if (index != widget.actions.length - 1)
        //   const SizedBox(
        //     width: 20,
        //     height: 10,
        //   ),
      ],
    ];

    return AdaptiveDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: widget.padding ?? const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.title != null)
                  Text(
                    widget.title!,
                    textAlign: TextAlign.center,
                    style: context.titleLarge,
                  ),
                if (widget.message != null) ...[
                  if (widget.title != null)
                    const SizedBox(
                      height: 5,
                    ),
                  Text(
                    widget.message!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                ],
                if (widget.title != null || widget.message != null)
                  const SizedBox(
                    height: 5,
                  ),
                if (widget.inputs != null)
                  for (final input in widget.inputs!) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller:
                            inputControllers[widget.inputs!.indexOf(input)],
                        onChanged: (final value) {},
                        decoration: InputDecoration(
                          isDense: true,
                          alignLabelWithHint: true,
                          labelText: input,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            fontSize: context.bodyLarge!.fontSize,
                            color: context.bodySmall!.color,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.bodySmall!.color!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                if (widget.body != null) widget.body!,
                if (widget.switches != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final item in widget.switches!)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.message,
                                  style: context.bodySmall!
                                      .apply(fontSizeDelta: 1),
                                ),
                              ),
                              AnimatedSwitch(
                                value: item.selected,
                                onChange: (final value) {
                                  item.onSwitch?.call(value);
                                  setState(() {
                                    item.selected = value;
                                  });
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                if (widget.selectors != null)
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      for (final selector in widget.selectors!)
                        SimpleToggleButton(
                          isSelected: selector.selected,
                          text: selector.title,
                          onChanged: (final value) {
                            setState(() {
                              selector.selected = value;
                            });
                            selector.onTap!(value);
                          },
                        ),
                    ],
                  ),
              ],
            ),
          ),
          if (widget.actions.length > 2)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: actionsWidgets,
            )
          else
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actionsWidgets,
              ),
            ),
        ],
      ),
    );
  }
}

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: isSmallScreen(context) ? double.infinity : 300,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)),
          color: context.dialogBackgroundColor,
        ),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
