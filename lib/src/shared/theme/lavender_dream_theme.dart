import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Lavender Dream theme - soft purple/lavender light theme
class LavenderDreamTheme {
  LavenderDreamTheme._();

  /// Get the Lavender Dream theme using the theme composer
  static ThemeData get lavenderDreamTheme {
    final config = ThemeConfig.light(
      primaryColor: AppColors.lavenderDreamPrimary,
      accentColor: AppColors.lavenderDreamAccent,
    );
    return ThemeComposer.compose(config);
  }
}

