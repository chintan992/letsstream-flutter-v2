import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Midnight Purple theme configuration - dark theme with purple accents
class MidnightPurpleTheme {
  MidnightPurpleTheme._();

  /// Get the Midnight Purple theme using the theme composer
  static ThemeData get midnightPurpleTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.midnightPurplePrimary,
      accentColor: AppColors.midnightPurpleAccent,
    );
    return ThemeComposer.compose(config);
  }
}
