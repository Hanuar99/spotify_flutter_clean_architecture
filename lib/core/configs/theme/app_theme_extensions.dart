import 'package:flutter/material.dart';

import 'app_theme_colors.dart';

extension ThemeExt on BuildContext {
  AppThemeColors get colors => Theme.of(this).extension<AppThemeColors>()!;
}
