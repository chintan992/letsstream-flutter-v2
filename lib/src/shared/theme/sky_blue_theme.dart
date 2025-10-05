import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Sky Blue theme - soft blue light theme
class SkyBlueTheme {
  SkyBlueTheme._();

  /// Get the Sky Blue theme using the theme composer
  static ThemeData get skyBlueTheme {
    final config = ThemeConfig.light(
      primaryColor: AppColors.skyBluePrimary,
      accentColor: AppColors.skyBlueAccent,
    );
    return ThemeComposer.compose(config);
  }
}

