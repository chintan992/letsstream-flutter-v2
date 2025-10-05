import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Coral Sunset theme - warm coral/peach light theme
class CoralSunsetTheme {
  CoralSunsetTheme._();

  /// Get the Coral Sunset theme using the theme composer
  static ThemeData get coralSunsetTheme {
    final config = ThemeConfig.light(
      primaryColor: AppColors.coralSunsetPrimary,
      accentColor: AppColors.coralSunsetAccent,
    );
    return ThemeComposer.compose(config);
  }
}

