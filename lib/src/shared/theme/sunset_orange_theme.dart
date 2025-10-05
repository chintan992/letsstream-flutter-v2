import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Sunset Orange theme configuration - dark theme with orange accents
class SunsetOrangeTheme {
  SunsetOrangeTheme._();

  /// Get the Sunset Orange theme using the theme composer
  static ThemeData get sunsetOrangeTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.sunsetOrangePrimary,
      accentColor: AppColors.sunsetOrangeAccent,
    );
    return ThemeComposer.compose(config);
  }
}
