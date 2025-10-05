import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Indigo Deep theme - deep indigo dark theme
class IndigoDeepTheme {
  IndigoDeepTheme._();

  /// Get the Indigo Deep theme using the theme composer
  static ThemeData get indigoDeepTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.indigoDeepPrimary,
      accentColor: AppColors.indigoDeepAccent,
    );
    return ThemeComposer.compose(config);
  }
}

