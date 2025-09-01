import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Enum representing different predefined themes
enum AppThemeType {
  classicDark('Classic Dark', 'Dark theme with purple accents'),
  classicLight('Classic Light', 'Light theme with purple accents'),
  blueOcean('Blue Ocean', 'Dark theme with blue accents'),
  sunsetOrange('Sunset Orange', 'Dark theme with orange accents'),
  forestGreen('Forest Green', 'Dark theme with green accents'),
  midnightPurple('Midnight Purple', 'Dark theme with deep purple accents'),
  rosePink('Rose Pink', 'Light theme with pink accents'),
  amberGold('Amber Gold', 'Dark theme with golden accents');

  const AppThemeType(this.displayName, this.description);

  final String displayName;
  final String description;

  /// Get the theme data for this theme type
  ThemeData get themeData {
    switch (this) {
      case AppThemeType.classicDark:
        return AppTheme.darkTheme;
      case AppThemeType.classicLight:
        return AppTheme.lightTheme;
      case AppThemeType.blueOcean:
        return AppTheme.blueOceanTheme;
      case AppThemeType.sunsetOrange:
        return AppTheme.sunsetOrangeTheme;
      case AppThemeType.forestGreen:
        return AppTheme.forestGreenTheme;
      case AppThemeType.midnightPurple:
        return AppTheme.midnightPurpleTheme;
      case AppThemeType.rosePink:
        return AppTheme.rosePinkTheme;
      case AppThemeType.amberGold:
        return AppTheme.amberGoldTheme;
    }
  }

  /// Get the brightness of this theme
  Brightness get brightness {
    switch (this) {
      case AppThemeType.classicLight:
      case AppThemeType.rosePink:
        return Brightness.light;
      default:
        return Brightness.dark;
    }
  }

  /// Get the primary color for this theme
  Color get primaryColor {
    switch (this) {
      case AppThemeType.classicDark:
      case AppThemeType.classicLight:
        return const Color(0xFF6B5B95);
      case AppThemeType.blueOcean:
        return const Color(0xFF2196F3);
      case AppThemeType.sunsetOrange:
        return const Color(0xFFFF9800);
      case AppThemeType.forestGreen:
        return const Color(0xFF4CAF50);
      case AppThemeType.midnightPurple:
        return const Color(0xFF9C27B0);
      case AppThemeType.rosePink:
        return const Color(0xFFE91E63);
      case AppThemeType.amberGold:
        return const Color(0xFFFFC107);
    }
  }

  /// Get the accent color for this theme
  Color get accentColor {
    switch (this) {
      case AppThemeType.classicDark:
      case AppThemeType.classicLight:
        return const Color(0xFF4ECDC4);
      case AppThemeType.blueOcean:
        return const Color(0xFF00BCD4);
      case AppThemeType.sunsetOrange:
        return const Color(0xFFFF5722);
      case AppThemeType.forestGreen:
        return const Color(0xFF8BC34A);
      case AppThemeType.midnightPurple:
        return const Color(0xFFBA68C8);
      case AppThemeType.rosePink:
        return const Color(0xFFFFC0CB);
      case AppThemeType.amberGold:
        return const Color(0xFFFFD54F);
    }
  }
}

/// Extension to get theme type from string (for persistence)
extension AppThemeTypeExtension on AppThemeType {
  String get key => name;

  static AppThemeType fromKey(String key) {
    return AppThemeType.values.firstWhere(
      (theme) => theme.key == key,
      orElse: () => AppThemeType.classicDark, // Default fallback
    );
  }
}
