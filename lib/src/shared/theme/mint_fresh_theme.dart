import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Mint Fresh theme - fresh mint green light theme
class MintFreshTheme {
  MintFreshTheme._();

  /// Get the Mint Fresh theme using the theme composer
  static ThemeData get mintFreshTheme {
    final config = ThemeConfig.light(
      primaryColor: AppColors.mintFreshPrimary,
      accentColor: AppColors.mintFreshAccent,
    );
    return ThemeComposer.compose(config);
  }
}

