import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Crimson Night theme - deep crimson dark theme
class CrimsonNightTheme {
  CrimsonNightTheme._();

  /// Get the Crimson Night theme using the theme composer
  static ThemeData get crimsonNightTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.crimsonNightPrimary,
      accentColor: AppColors.crimsonNightAccent,
    );
    return ThemeComposer.compose(config);
  }
}

