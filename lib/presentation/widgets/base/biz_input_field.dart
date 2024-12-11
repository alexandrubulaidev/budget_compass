import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app_theme.dart';
import '../../extensions/context_extension.dart';
import 'ink_tap.dart';

class BizInputField extends StatelessWidget {
  const BizInputField({
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.controller,
    this.validator,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onPrefixTapped,
    this.onSuffixTapped,
    super.key,
  });

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String label;
  final String? Function(String? text)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onSuffixTapped;
  final void Function()? onPrefixTapped;

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.background,
        // isDense: true,
        alignLabelWithHint: true,
        hintText: label,
        suffixIcon: suffixIcon == null
            ? null
            : InkTap(
                onTap: onSuffixTapped,
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: FaIcon(
                        suffixIcon,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
        prefixIcon: prefixIcon == null
            ? null
            : InkTap(
                onTap: onPrefixTapped,
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: FaIcon(
                        prefixIcon,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
        contentPadding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          right: 15,
          left: 15,
        ),
        border: bizBorder(
          color: context.primaryColorLight,
        ),
        enabledBorder: bizBorder(
          color: context.primaryColorLight,
        ),
        disabledBorder: bizBorder(
          color: context.onSecondary,
        ),
        focusedBorder: bizBorder(
          color: context.primaryColor,
        ),
        errorBorder: bizBorder(
          color: context.errorColor,
        ),
      ),
      validator: validator,
      controller: controller,
    );
  }
}

InputBorder bizBorder({final Color? color}) {
  return OutlineInputBorder(
    borderSide: color == null
        ? BorderSide.none
        : BorderSide(
            color: color,
          ),
    borderRadius: BorderRadius.circular(
      kBorderRadius,
    ),
  );
}
