import 'package:flutter/material.dart';

/// Color palette definitions for the app themes
class AppColors {
  AppColors._();

  // Primary theme colors
  static const Color primaryColor = Color(0xFF6B5B95);
  static const Color secondaryColor = Color(0xFFD32F2F);
  static const Color accentColor = Color(0xFF4ECDC4);

  // Background and surface colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceHighest = Color(0xFF2A2A2A);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHighest = Color(0xFFF0F0F0);

  // Additional theme color palettes - enhanced for better contrast

  // Blue Ocean - darker primary for better contrast on white text
  static const Color blueOceanPrimary = Color(0xFF1976D2);
  static const Color blueOceanAccent = Color(0xFF00ACC1);

  // Sunset Orange - enhanced contrast
  static const Color sunsetOrangePrimary = Color(0xFFBF360C);  // Darker for better contrast
  static const Color sunsetOrangeAccent = Color(0xFFD84315);

  // Forest Green - improved contrast
  static const Color forestGreenPrimary = Color(0xFF2E7D32);  // Darker for better contrast
  static const Color forestGreenAccent = Color(0xFF689F38);

  // Midnight Purple - better contrast
  static const Color midnightPurplePrimary = Color(0xFF7B1FA2);
  static const Color midnightPurpleAccent = Color(0xFF9C27B0);

  // Rose Pink - enhanced for light theme
  static const Color rosePinkPrimary = Color(0xFCC2185B);
  static const Color rosePinkAccent = Color(0xFF880E4F);

  // Amber Gold - improved contrast for dark backgrounds
  static const Color amberGoldPrimary = Color(0xFFBF360C);    // Much darker for better contrast
  static const Color amberGoldAccent = Color(0xFFE65100);

  // Text colors - optimized for accessibility
  static const Color darkTextPrimary = Color(0xFFE0E0E0);   // High contrast on dark
  static const Color darkTextSecondary = Color(0xFFB0B0B0); // Medium contrast on dark
  static const Color darkTextTertiary = Color(0xFF757575);   // Lower contrast on dark
  
  static const Color lightTextPrimary = Color(0xFF212121);   // High contrast on light
  static const Color lightTextSecondary = Color(0xFF616161); // Darker for better contrast
  static const Color lightTextTertiary = Color(0xFF9E9E9E);  // Lower contrast on light

  // Error colors with good contrast
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color errorColorLight = Color(0xFFEF5350);
  
  // Success colors
  static const Color successColor = Color(0xFF388E3C);
  static const Color successColorLight = Color(0xFF66BB6A);
  
  // Warning colors
  static const Color warningColor = Color(0xFFE65100);
  static const Color warningColorLight = Color(0xFFFF9800);
}
