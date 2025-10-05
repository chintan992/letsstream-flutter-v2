import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Blue Ocean theme configuration - dark theme with blue accents
class BlueOceanTheme {
  BlueOceanTheme._();

  /// Get the Blue Ocean theme using the theme composer
  static ThemeData get blueOceanTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.blueOceanPrimary,
      accentColor: AppColors.blueOceanAccent,
    );
    return ThemeComposer.compose(config);
  }
}
