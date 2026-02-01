import 'package:flutter/material.dart';
import 'netflix_theme.dart';
import 'netflix_colors.dart';

/// Enum representing different predefined themes
/// Simplified to only support Netflix theme
enum AppThemeType {
  netflix('Netflix', 'Netflix-inspired dark theme with red accents');

  const AppThemeType(this.displayName, this.description);

  final String displayName;
  final String description;

  /// Get the theme data for this theme type
  ThemeData get themeData {
    return NetflixTheme.themeData;
  }

  /// Get the brightness of this theme
  Brightness get brightness => Brightness.dark;

  /// Get the primary color for this theme
  Color get primaryColor => NetflixColors.primaryRed;

  /// Get the accent color for this theme
  Color get accentColor => NetflixColors.primaryRed;
}

/// Extension to get theme type from string (for persistence)
extension AppThemeTypeExtension on AppThemeType {
  String get key => name;

  static AppThemeType fromKey(String key) {
    return AppThemeType.values.firstWhere(
      (theme) => theme.key == key,
      orElse: () => AppThemeType.netflix, // Default to Netflix
    );
  }
}
