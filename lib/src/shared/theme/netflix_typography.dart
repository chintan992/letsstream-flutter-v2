import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'netflix_colors.dart';

/// Netflix typography configuration
/// Uses Netflix Sans style with Google Fonts (Inter for body, Bebas Neue for display)
class NetflixTypography {
  NetflixTypography._();

  /// Get the complete Netflix text theme
  static TextTheme get textTheme {
    return TextTheme(
      // Display styles - Large bold headers
      displayLarge: GoogleFonts.bebasNeue(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: NetflixColors.textPrimary,
        letterSpacing: 1.0,
      ),
      displayMedium: GoogleFonts.bebasNeue(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: NetflixColors.textPrimary,
        letterSpacing: 0.8,
      ),
      displaySmall: GoogleFonts.bebasNeue(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: NetflixColors.textPrimary,
        letterSpacing: 0.6,
      ),

      // Headline styles - Section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: NetflixColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: NetflixColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textPrimary,
      ),

      // Title styles - Card titles, item names
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textPrimary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textSecondary,
      ),

      // Body styles - Descriptions, content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: NetflixColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: NetflixColors.textSecondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: NetflixColors.textTertiary,
        height: 1.4,
      ),

      // Label styles - Buttons, chips, navigation
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textPrimary,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textPrimary,
        letterSpacing: 0.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }

  /// Hero title style - For featured content titles
  static TextStyle get heroTitle => GoogleFonts.bebasNeue(
        fontSize: 56,
        fontWeight: FontWeight.bold,
        color: NetflixColors.textPrimary,
        letterSpacing: 1.2,
        shadows: [
          Shadow(
            color: NetflixColors.blackWithOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Hero subtitle style
  static TextStyle get heroSubtitle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: NetflixColors.textSecondary,
        shadows: [
          Shadow(
            color: NetflixColors.blackWithOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );

  /// Section title style - "Popular on Netflix", etc.
  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: NetflixColors.textPrimary,
        letterSpacing: 0.3,
      );

  /// Card title style
  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: NetflixColors.textPrimary,
      );

  /// Navigation label style
  static TextStyle get navigationLabel => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: NetflixColors.textSecondary,
        letterSpacing: 0.2,
      );

  /// Button text style
  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: NetflixColors.textPrimary,
        letterSpacing: 0.5,
      );
}
