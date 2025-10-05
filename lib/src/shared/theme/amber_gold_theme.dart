import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Amber Gold theme configuration - dark theme with golden accents
class AmberGoldTheme {
  AmberGoldTheme._();

  /// Get the Amber Gold theme using the theme composer
  static ThemeData get amberGoldTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.amberGoldPrimary,
      accentColor: AppColors.amberGoldAccent,
    );
    return ThemeComposer.compose(config);
  }
}
