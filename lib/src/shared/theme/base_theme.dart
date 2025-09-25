import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Base theme configurations that can be reused across different themes
class BaseTheme {
  BaseTheme._();

  // Common AppBar Theme
  static AppBarTheme getAppBarTheme({
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: iconColor),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  // Common Navigation Bar Theme
  static NavigationBarThemeData getNavigationBarTheme({
    required Color backgroundColor,
    required Color primaryColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return NavigationBarThemeData(
      backgroundColor: backgroundColor,
      indicatorColor: primaryColor.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: primaryColor);
        }
        return IconThemeData(color: secondaryTextColor);
      }),
    );
  }

  // Common Elevated Button Theme
  static ElevatedButtonThemeData getElevatedButtonTheme({
    required Color primaryColor,
    required bool isDark,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: isDark ? 4 : 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Common Text Theme
  static TextTheme getTextTheme({
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      displaySmall: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
    );
  }

  // Common Input Decoration Theme
  static InputDecorationTheme getInputDecorationTheme({
    required Color fillColor,
    required Color primaryColor,
    required Color secondaryColor,
    required Color labelColor,
    required Color hintColor,
    required bool isDark,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFE0E0E0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFE0E0E0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondaryColor),
      ),
      labelStyle: TextStyle(color: labelColor),
      hintStyle: TextStyle(color: hintColor),
    );
  }

  // Common Divider Theme
  static DividerThemeData getDividerTheme({required bool isDark}) {
    return DividerThemeData(
      color: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.shade300,
      thickness: 1,
    );
  }

  // Common Card Theme
  static CardThemeData getCardTheme({required Color surfaceColor}) {
    return CardThemeData(
      elevation: 2,
      color: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // Common TabBar Theme
  static TabBarThemeData getTabBarTheme({
    required Color primaryColor,
    required Color secondaryTextColor,
  }) {
    return TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: secondaryTextColor,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}
