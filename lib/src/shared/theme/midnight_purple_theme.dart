import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'base_theme.dart';

/// Midnight Purple theme configuration
class MidnightPurpleTheme {
  MidnightPurpleTheme._();

  static ThemeData get midnightPurpleTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.midnightPurplePrimary,
        secondary: AppColors.midnightPurpleAccent,
        tertiary: AppColors.midnightPurpleAccent,
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
        primaryColor: AppColors.midnightPurplePrimary,
        textColor: AppColors.darkTextPrimary,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: BaseTheme.getElevatedButtonTheme(
        primaryColor: AppColors.midnightPurplePrimary,
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
        primaryColor: AppColors.midnightPurplePrimary,
        secondaryColor: AppColors.errorColor,
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
        primaryColor: AppColors.midnightPurplePrimary,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),
    );
  }
}
