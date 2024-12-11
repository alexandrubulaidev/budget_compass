// ignore_for_file: no_default_cases, use_setters_to_change_properties

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:math_parser/math_parser.dart';
import 'package:rxdart/rxdart.dart';

import '../../../application.dart';
import '../../../data/model/transaction_type.dart';
import '../../../domain/extensions/list_split_extension.dart';
import '../../../domain/extensions/num_extension.dart';
import 'widgets/biz_keyboard_key.dart';

class BizKeyboardController {
  BizKeyboardController();

  void Function()? onSubmit;

  double? get total => _handleEquals();

  TransactionType get type => _type.value;
  Stream<TransactionType> get typeStream => _type.stream;
  final BehaviorSubject<TransactionType> _type = BehaviorSubject.seeded(
    TransactionType.income,
  );

  List<BizKeyboardKey> get operation => _operation.value;
  Stream<List<BizKeyboardKey>> get operationStream => _operation.stream;
  final BehaviorSubject<List<BizKeyboardKey>> _operation =
      BehaviorSubject.seeded([BizKeyboardKey.zero]);

  void dispose() {
    unawaited(_type.close());
    unawaited(_operation.close());
  }

  void setValue(final num value) {
    _operation.value = value.keys;
  }

  void updateTransactionType(final TransactionType type) {
    _type.value = type;
  }

  void onKeyPressed(final BizKeyboardKey button) {
    if (button.isNumber) {
      _handleNumberInput(button);
    } else if (button.isOperation) {
      _handleOperation(button);
    } else if (button == BizKeyboardKey.delete) {
      _handleDelete();
    } else if (button == BizKeyboardKey.check) {
      _handleCheckSign();
    } else if (button == BizKeyboardKey.trash) {
      _handleTrashIcon();
    } else if (button == BizKeyboardKey.decimal) {
      _handleDecimal();
    } else if (button == BizKeyboardKey.equals) {
      _handleEquals();
    }
  }

  double? _handleEquals() {
    var expression = '';
    for (final element in operation) {
      final stringValue = element.stringValue;
      if (stringValue != null) {
        expression += stringValue;
      }
    }

    num? result;
    try {
      result = MathNodeExpression.fromString(
        expression,
        variableNames: {},
      ).calc(MathVariableValues.none);
    } catch (e) {
      return null;
    }

    if (result.isFinite && result != 0) {
      _operation.add([
        ...result
            .toStringAsFixed(Application.decimals)
            .characters
            .map(BizKeyboardKeyExtension.fromString)
            .where((final e) => e != null)
            .cast<BizKeyboardKey>(),
      ]);

      return result.toDouble();
    }
    return null;
  }

  List<BizKeyboardKey>? _currentNumber() {
    if (operation.isNotEmpty && operation.last.isOperation) {
      return null;
    }
    final parts = operation.split((final element) => element.isOperation);
    if (parts.isNotEmpty) {
      return parts.last;
    }
    return null;
  }

  void _handleDecimal() {
    final last = _currentNumber();
    if (last == null) {
      _operation
          .add([...operation, BizKeyboardKey.zero, BizKeyboardKey.decimal]);
    } else {
      if (!last.contains(BizKeyboardKey.decimal)) {
        _operation.add([...operation, BizKeyboardKey.decimal]);
      }
    }
  }

  void _handleOperation(final BizKeyboardKey button) {
    final lastButton = operation.last;

    // remove decimal if it's last
    final current = _currentNumber();
    if (current != null &&
        current.isNotEmpty &&
        current.last == BizKeyboardKey.decimal) {
      _operation.add([...operation.sublist(0, operation.length - 1)]);
    }

    if (lastButton.isOperation) {
      // If the last button was an operation, replace it with the new operation.
      _operation.add([...operation.sublist(0, operation.length - 1), button]);
    } else {
      // Add the operation button to the current operation
      _operation.add([...operation, button]);
    }
  }

  void _handleNumberInput(final BizKeyboardKey button) {
    var current = _currentNumber();
    if (current == null) {
      _operation.add([...operation, button]);
    } else if (current.isZero) {
      if (button != BizKeyboardKey.zero) {
        _operation.add([...operation.sublist(0, operation.length - 1), button]);
      }
    } else {
      _operation.add([...operation, button]);
    }
    // updated
    current = _currentNumber();
    // check for more than two digits
    if (current != null) {
      final parts = current.split(
        (final element) => element == BizKeyboardKey.decimal,
      );
      if (parts.length > 1 && parts.last.length > Application.decimals) {
        _operation.add([...operation.sublist(0, operation.length - 1)]);
      }
    }
  }

  void _handleCheckSign() {
    // Do nothing when the check button is pressed
    // You can add your logic here if needed
    onSubmit?.call();
  }

  void _handleDelete() {
    if (operation.length > 1) {
      // Remove the last button from the operation list
      _operation.add([...operation.sublist(0, operation.length - 1)]);
    } else {
      // If the operation list only has one button left,
      // replace it with the zero button
      _operation.add([BizKeyboardKey.zero]);
    }
  }

  void _handleTrashIcon() {
    // Reset the operation to have only the zero button
    _operation.add([BizKeyboardKey.zero]);
  }
}

extension BizButtonListHelper on List<BizKeyboardKey> {
  bool get isZero {
    if (length == 1 && first == BizKeyboardKey.zero) {
      return true;
    }
    return false;
  }
}
