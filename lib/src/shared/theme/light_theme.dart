import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Classic light theme configuration
class LightTheme {
  LightTheme._();

  /// Get the classic light theme using the theme composer
  static ThemeData get lightTheme {
    final config = ThemeConfig.light(
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accentColor,
    );
    return ThemeComposer.compose(config);
  }
}
