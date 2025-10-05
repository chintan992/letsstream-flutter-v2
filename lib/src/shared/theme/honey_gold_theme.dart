import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Honey Gold theme - warm golden light theme
class HoneyGoldTheme {
  HoneyGoldTheme._();

  /// Get the Honey Gold theme using the theme composer
  static ThemeData get honeyGoldTheme {
    final config = ThemeConfig.light(
      primaryColor: AppColors.honeyGoldPrimary,
      accentColor: AppColors.honeyGoldAccent,
    );
    return ThemeComposer.compose(config);
  }
}

