import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'base_theme.dart';

/// Dark theme configuration
class DarkTheme {
  DarkTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        tertiary: AppColors.accentColor,
        surface: AppColors.darkSurface,
        surfaceContainerHighest: AppColors.darkSurfaceHighest,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar Theme
      appBarTheme: BaseTheme.getAppBarTheme(
        backgroundColor: Colors.transparent,
        textColor: AppColors.darkTextPrimary,
        iconColor: AppColors.darkTextPrimary,
      ),

      // Navigation Bar Theme
      navigationBarTheme: BaseTheme.getNavigationBarTheme(
        backgroundColor: AppColors.darkSurface,
        primaryColor: AppColors.primaryColor,
        textColor: AppColors.darkTextPrimary,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: BaseTheme.getElevatedButtonTheme(
        primaryColor: AppColors.primaryColor,
        isDark: true,
      ),

      // Text Theme
      textTheme: BaseTheme.getTextTheme(
        primaryTextColor: AppColors.darkTextPrimary,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),

      // Input Decoration Theme
      inputDecorationTheme: BaseTheme.getInputDecorationTheme(
        fillColor: AppColors.darkSurface,
        primaryColor: AppColors.primaryColor,
        secondaryColor: AppColors.secondaryColor,
        labelColor: AppColors.darkTextSecondary,
        hintColor: AppColors.darkTextSecondary.withValues(alpha: 0.6),
        isDark: true,
      ),

      // Divider Theme
      dividerTheme: BaseTheme.getDividerTheme(isDark: true),

      // Card Theme
      cardTheme: BaseTheme.getCardTheme(surfaceColor: AppColors.darkSurface),

      // TabBar Theme
      tabBarTheme: BaseTheme.getTabBarTheme(
        primaryColor: AppColors.primaryColor,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),
    );
  }
}
