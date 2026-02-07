import 'package:flutter/material.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color appBarIconBackground;
  final Color textSecondary;

  const AppThemeColors({
    required this.appBarIconBackground,
    required this.textSecondary,
  });

  @override
  AppThemeColors copyWith({
    Color? appBarIconBackground,
    Color? textSecondary,
  }) {
    return AppThemeColors(
      appBarIconBackground: appBarIconBackground ?? this.appBarIconBackground,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      appBarIconBackground:
          Color.lerp(appBarIconBackground, other.appBarIconBackground, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}
