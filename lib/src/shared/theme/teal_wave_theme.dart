import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Teal Wave theme - teal/cyan dark theme
class TealWaveTheme {
  TealWaveTheme._();

  /// Get the Teal Wave theme using the theme composer
  static ThemeData get tealWaveTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.tealWavePrimary,
      accentColor: AppColors.tealWaveAccent,
    );
    return ThemeComposer.compose(config);
  }
}

