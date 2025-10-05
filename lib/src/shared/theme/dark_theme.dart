import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Classic dark theme configuration
class DarkTheme {
  DarkTheme._();

  /// Get the classic dark theme using the theme composer
  static ThemeData get darkTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accentColor,
    );
    return ThemeComposer.compose(config);
  }
}
