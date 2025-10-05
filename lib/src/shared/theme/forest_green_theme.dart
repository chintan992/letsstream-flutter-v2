import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Forest Green theme configuration - dark theme with green accents
class ForestGreenTheme {
  ForestGreenTheme._();

  /// Get the Forest Green theme using the theme composer
  static ThemeData get forestGreenTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.forestGreenPrimary,
      accentColor: AppColors.forestGreenAccent,
    );
    return ThemeComposer.compose(config);
  }
}
