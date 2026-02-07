import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/core/configs/theme/app_theme.dart';

void main() {
  group(
    'AppTheme',
    () {
      test('lightTheme has correct Brightness', () {
        expect(AppTheme.lightTheme.brightness, equals(Brightness.light));
      });

      test('darkTheme has correct Brightness', () {
        expect(AppTheme.darkTheme.brightness, equals(Brightness.dark));
      });

      test('primary color is consistent', () {
        expect(AppTheme.lightTheme.primaryColor, AppColors.primary);
        expect(AppTheme.darkTheme.primaryColor, AppColors.primary);
      });
    },
  );
}
