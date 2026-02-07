import 'package:flutter/material.dart';

extension DarkMode on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
