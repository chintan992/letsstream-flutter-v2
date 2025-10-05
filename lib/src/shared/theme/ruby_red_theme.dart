import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_composer.dart';

/// Ruby Red theme - rich red/burgundy dark theme
class RubyRedTheme {
  RubyRedTheme._();

  /// Get the Ruby Red theme using the theme composer
  static ThemeData get rubyRedTheme {
    final config = ThemeConfig.dark(
      primaryColor: AppColors.rubyRedPrimary,
      accentColor: AppColors.rubyRedAccent,
    );
    return ThemeComposer.compose(config);
  }
}

