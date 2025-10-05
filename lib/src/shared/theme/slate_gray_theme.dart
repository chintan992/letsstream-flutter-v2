import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Slate Gray theme - cool gray/slate dark theme
class SlateGrayTheme {
  SlateGrayTheme._();

  /// Get the Slate Gray theme using the theme composer
  static ThemeData get slateGrayTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.slateGrayPrimary,
      accentColor: AppColors.slateGrayAccent,
    );
    return ThemeComposer.compose(config);
  }
}

