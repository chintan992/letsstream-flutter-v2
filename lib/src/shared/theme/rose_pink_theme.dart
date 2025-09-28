import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'base_theme.dart';

/// Rose Pink theme configuration
class RosePinkTheme {
  RosePinkTheme._();

  static ThemeData get rosePinkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.rosePinkPrimary,
        secondary: AppColors.rosePinkAccent,
        tertiary: AppColors.rosePinkAccent,
        surface: AppColors.lightSurface,
        surfaceContainerHighest: AppColors.lightSurfaceHighest,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,

      // AppBar Theme
      appBarTheme: BaseTheme.getAppBarTheme(
        backgroundColor: Colors.transparent,
        textColor: AppColors.lightTextPrimary,
        iconColor: AppColors.lightTextPrimary,
      ),

      // Navigation Bar Theme
      navigationBarTheme: BaseTheme.getNavigationBarTheme(
        backgroundColor: AppColors.lightSurface,
        primaryColor: AppColors.rosePinkPrimary,
        textColor: AppColors.lightTextPrimary,
        secondaryTextColor: AppColors.lightTextSecondary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: BaseTheme.getElevatedButtonTheme(
        primaryColor: AppColors.rosePinkPrimary,
        isDark: false,
      ),

      // Text Theme
      textTheme: BaseTheme.getTextTheme(
        primaryTextColor: AppColors.lightTextPrimary,
        secondaryTextColor: AppColors.lightTextSecondary,
      ),

      // Input Decoration Theme
      inputDecorationTheme: BaseTheme.getInputDecorationTheme(
        fillColor: const Color(0xFFF8F9FA),
        primaryColor: AppColors.rosePinkPrimary,
        secondaryColor: AppColors.errorColor,
        labelColor: AppColors.lightTextSecondary,
        hintColor: AppColors.lightTextSecondary.withValues(alpha: 0.6),
        isDark: false,
      ),

      // Divider Theme
      dividerTheme: BaseTheme.getDividerTheme(isDark: false),

      // Card Theme
      cardTheme: BaseTheme.getCardTheme(surfaceColor: AppColors.lightSurface),

      // TabBar Theme
      tabBarTheme: BaseTheme.getTabBarTheme(
        primaryColor: AppColors.rosePinkPrimary,
        secondaryTextColor: AppColors.lightTextSecondary,
      ),
    );
  }
}
