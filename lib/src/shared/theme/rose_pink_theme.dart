import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Rose Pink theme configuration - light theme with pink accents
class RosePinkTheme {
  RosePinkTheme._();

  /// Get the Rose Pink theme using the theme composer
  static ThemeData get rosePinkTheme {
    final config = ThemeConfig.light(
      primaryColor: AppColors.rosePinkPrimary,
      accentColor: AppColors.rosePinkAccent,
    );
    return ThemeComposer.compose(config);
  }
}
