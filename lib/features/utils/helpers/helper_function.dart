import 'package:flutter/material.dart';

class HelperFunction {
  // pilihan tema
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
