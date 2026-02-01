import 'package:flutter/material.dart';

/// Netflix brand colors and design system colors
class NetflixColors {
  NetflixColors._();

  // ==================== Primary Brand Colors ====================
  /// Netflix primary red - #E50914
  static const Color primaryRed = Color(0xFFE50914);

  /// Darker red for hover states
  static const Color primaryRedDark = Color(0xFFB20710);

  /// Lighter red for highlights
  static const Color primaryRedLight = Color(0xFFFF3B3B);

  // ==================== Background Colors ====================
  /// Main background black - #141414
  static const Color backgroundBlack = Color(0xFF141414);

  /// Darker background for depth - #0F0F0F
  static const Color backgroundBlackDark = Color(0xFF0F0F0F);

  /// Slightly lighter background - #1A1A1A
  static const Color backgroundBlackLight = Color(0xFF1A1A1A);

  // ==================== Surface Colors ====================
  /// Card/elevated surface color - #1F1F1F
  static const Color surfaceDark = Color(0xFF1F1F1F);

  /// Input fields, buttons background - #2F2F2F
  static const Color surfaceMedium = Color(0xFF2F2F2F);

  /// Hover states, borders - #3F3F3F
  static const Color surfaceLight = Color(0xFF3F3F3F);

  /// Highest surface for nested elements - #4F4F4F
  static const Color surfaceHighest = Color(0xFF4F4F4F);

  // ==================== Text Colors ====================
  /// Primary text - white #FFFFFF
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text - light gray #B3B3B3
  static const Color textSecondary = Color(0xFFB3B3B3);

  /// Tertiary text - medium gray #808080
  static const Color textTertiary = Color(0xFF808080);

  /// Disabled text - dark gray #666666
  static const Color textDisabled = Color(0xFF666666);

  // ==================== Accent Colors ====================
  /// Success green
  static const Color success = Color(0xFF46D369);

  /// Warning orange
  static const Color warning = Color(0xFFE6B800);

  /// Error red (same as primary)
  static const Color error = primaryRed;

  /// Info blue
  static const Color info = Color(0xFF54B9C5);

  // ==================== Gradient Colors ====================
  /// Hero gradient - from transparent to black
  static const List<Color> heroGradient = [
    Color(0x00141414),
    Color(0x80141414),
    Color(0xCC141414),
    Color(0xFF141414),
  ];

  /// Top gradient for scroll fade
  static const List<Color> topGradient = [
    Color(0xFF141414),
    Color(0x80141414),
    Color(0x00141414),
  ];

  // ==================== Utility Colors ====================
  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// White with opacity variants
  static Color whiteWithOpacity(double opacity) =>
      Color.fromRGBO(255, 255, 255, opacity);

  /// Black with opacity variants
  static Color blackWithOpacity(double opacity) =>
      Color.fromRGBO(0, 0, 0, opacity);
}
