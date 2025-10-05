import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Violet Dusk theme - rich violet dark theme
class VioletDuskTheme {
  VioletDuskTheme._();

  /// Get the Violet Dusk theme using the theme composer
  static ThemeData get violetDuskTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.violetDuskPrimary,
      accentColor: AppColors.violetDuskAccent,
    );
    return ThemeComposer.compose(config);
  }
}

