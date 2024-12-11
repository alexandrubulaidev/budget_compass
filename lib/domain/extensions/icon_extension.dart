import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

extension IconDataString on IconData {
  String? get stringValue {
    try {
      return jsonEncode(serializeIcon(this));
    } catch (e) {
      return null;
    }
  }

  static IconData? fromString(final String string) {
    IconData? icon;
    try {
      icon = deserializeIcon(jsonDecode(string) as Map<String, dynamic>);
    } catch (e) {}
    return icon;
  }
}
