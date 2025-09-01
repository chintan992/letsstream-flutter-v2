import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Color palette
  static const Color _primaryColor = Color(0xFF6B5B95);
  static const Color _secondaryColor = Color(0xFFFF6B6B);
  static const Color _accentColor = Color(0xFF4ECDC4);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _lightBackground = Color(0xFFF5F5F5);
  static const Color _lightSurface = Color(0xFFFFFFFF);

  // Text colors
  static const Color _darkTextPrimary = Color(0xFFE0E0E0);
  static const Color _darkTextSecondary = Color(0xFFB0B0B0);
  static const Color _lightTextPrimary = Color(0xFF212121);
  static const Color _lightTextSecondary = Color(0xFF757575);

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
      secondary: _secondaryColor,
      tertiary: _accentColor,
      surface: _darkSurface,
      surfaceContainerHighest: Color(0xFF2A2A2A),
      onSurface: _darkTextPrimary,
      onSurfaceVariant: _darkTextSecondary,
    ),
    scaffoldBackgroundColor: _darkBackground,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _darkTextPrimary,
      ),
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkSurface,
      indicatorColor: _primaryColor.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _primaryColor);
        }
        return const IconThemeData(color: _darkTextSecondary);
      }),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: _darkTextPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _darkTextPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _darkTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _darkTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: _darkTextPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _darkTextPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: _darkTextPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: _darkTextSecondary),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _darkTextPrimary,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _secondaryColor),
      ),
      labelStyle: const TextStyle(color: _darkTextSecondary),
      hintStyle: TextStyle(color: _darkTextSecondary.withValues(alpha: 0.6)),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 0.1),
      thickness: 1,
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      color: _darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // TabBar Theme
    tabBarTheme: const TabBarThemeData(
      labelColor: _primaryColor,
      unselectedLabelColor: _darkTextSecondary,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
    ),
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _secondaryColor,
      tertiary: _accentColor,
      surface: _lightSurface,
      surfaceContainerHighest: Color(0xFFF0F0F0),
      onSurface: _lightTextPrimary,
      onSurfaceVariant: _lightTextSecondary,
    ),
    scaffoldBackgroundColor: _lightBackground,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: _lightTextPrimary),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _lightTextPrimary,
      ),
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _lightSurface,
      indicatorColor: _primaryColor.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _primaryColor);
        }
        return const IconThemeData(color: _lightTextSecondary);
      }),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: _lightTextPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _lightTextPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _lightTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _lightTextPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: _lightTextPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _lightTextPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: _lightTextPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: _lightTextSecondary),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _lightTextPrimary,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _secondaryColor),
      ),
      labelStyle: const TextStyle(color: _lightTextSecondary),
      hintStyle: TextStyle(color: _lightTextSecondary.withValues(alpha: 0.6)),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(color: Colors.grey.shade300, thickness: 1),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      color: _lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // TabBar Theme
    tabBarTheme: const TabBarThemeData(
      labelColor: _primaryColor,
      unselectedLabelColor: _lightTextSecondary,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
    ),
  );
}
