import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Deep Ocean theme - deep blue/navy dark theme
class DeepOceanTheme {
  DeepOceanTheme._();

  /// Get the Deep Ocean theme using the theme composer
  static ThemeData get deepOceanTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.deepOceanPrimary,
      accentColor: AppColors.deepOceanAccent,
    );
    return ThemeComposer.compose(config);
  }
}

