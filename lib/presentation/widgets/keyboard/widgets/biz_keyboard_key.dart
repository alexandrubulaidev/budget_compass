// ignore_for_file: no_default_cases

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum BizKeyboardKey {
  divide,
  seven,
  eight,
  nine,
  delete,
  multiply,
  four,
  five,
  six,
  subtract,
  one,
  two,
  three,
  empty,
  add,
  trash,
  zero,
  decimal,
  check,
  comma,
  equals,
  space,
}

extension BizKeyboardKeyExtension on BizKeyboardKey {
  IconData? get icon {
    switch (this) {
      case BizKeyboardKey.divide:
        return FontAwesomeIcons.divide;
      case BizKeyboardKey.seven:
        return FontAwesomeIcons.seven;
      case BizKeyboardKey.eight:
        return FontAwesomeIcons.eight;
      case BizKeyboardKey.nine:
        return FontAwesomeIcons.nine;
      case BizKeyboardKey.delete:
        return FontAwesomeIcons.deleteLeft;
      case BizKeyboardKey.multiply:
        return FontAwesomeIcons.xmark;
      case BizKeyboardKey.four:
        return FontAwesomeIcons.four;
      case BizKeyboardKey.five:
        return FontAwesomeIcons.five;
      case BizKeyboardKey.six:
        return FontAwesomeIcons.six;
      case BizKeyboardKey.empty:
        return null;
      case BizKeyboardKey.subtract:
        return FontAwesomeIcons.minus;
      case BizKeyboardKey.one:
        return FontAwesomeIcons.one;
      case BizKeyboardKey.two:
        return FontAwesomeIcons.two;
      case BizKeyboardKey.three:
        return FontAwesomeIcons.three;
      case BizKeyboardKey.add:
        return FontAwesomeIcons.plus;
      case BizKeyboardKey.trash:
        return FontAwesomeIcons.solidTrashCan;
      case BizKeyboardKey.zero:
        return FontAwesomeIcons.zero;
      case BizKeyboardKey.check:
        return FontAwesomeIcons.check;
      case BizKeyboardKey.equals:
        return FontAwesomeIcons.equals;
      default:
        return null; // Handle the rest of the placeholders or return null
    }
  }

  bool get isOperation {
    return this == BizKeyboardKey.divide ||
        this == BizKeyboardKey.multiply ||
        this == BizKeyboardKey.subtract ||
        this == BizKeyboardKey.add;
  }

  bool get isNumber {
    return this == BizKeyboardKey.zero ||
        this == BizKeyboardKey.one ||
        this == BizKeyboardKey.two ||
        this == BizKeyboardKey.three ||
        this == BizKeyboardKey.four ||
        this == BizKeyboardKey.five ||
        this == BizKeyboardKey.six ||
        this == BizKeyboardKey.seven ||
        this == BizKeyboardKey.eight ||
        this == BizKeyboardKey.nine;
  }

  String? get stringValue {
    switch (this) {
      case BizKeyboardKey.divide:
        return '/';
      case BizKeyboardKey.seven:
        return '7';
      case BizKeyboardKey.eight:
        return '8';
      case BizKeyboardKey.nine:
        return '9';
      case BizKeyboardKey.multiply:
        return '*';
      case BizKeyboardKey.four:
        return '4';
      case BizKeyboardKey.five:
        return '5';
      case BizKeyboardKey.six:
        return '6';
      case BizKeyboardKey.subtract:
        return '-';
      case BizKeyboardKey.one:
        return '1';
      case BizKeyboardKey.two:
        return '2';
      case BizKeyboardKey.three:
        return '3';
      case BizKeyboardKey.add:
        return '+';
      case BizKeyboardKey.zero:
        return '0';
      case BizKeyboardKey.decimal:
        return '.';
      default:
        return null;
    }
  }

  static BizKeyboardKey? fromString(final String string) {
    switch (string) {
      case '0':
        return BizKeyboardKey.zero;
      case '1':
        return BizKeyboardKey.one;
      case '2':
        return BizKeyboardKey.two;
      case '3':
        return BizKeyboardKey.three;
      case '4':
        return BizKeyboardKey.four;
      case '5':
        return BizKeyboardKey.five;
      case '6':
        return BizKeyboardKey.six;
      case '7':
        return BizKeyboardKey.seven;
      case '8':
        return BizKeyboardKey.eight;
      case '9':
        return BizKeyboardKey.nine;
      case '/':
        return BizKeyboardKey.divide;
      case '-':
        return BizKeyboardKey.subtract;
      case '+':
        return BizKeyboardKey.add;
      case 'x':
        return BizKeyboardKey.multiply;
      case '.':
        return BizKeyboardKey.decimal;
      default:
        return null;
    }
  }
}
