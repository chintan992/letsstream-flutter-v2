import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Emerald Night theme - rich emerald green dark theme
class EmeraldNightTheme {
  EmeraldNightTheme._();

  /// Get the Emerald Night theme using the theme composer
  static ThemeData get emeraldNightTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.emeraldNightPrimary,
      accentColor: AppColors.emeraldNightAccent,
    );
    return ThemeComposer.compose(config);
  }
}

