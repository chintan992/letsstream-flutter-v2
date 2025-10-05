import 'package:flutter/material.dart';

/// Custom theme extension for additional color properties not in ColorScheme
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  /// Creates a custom theme extension
  const AppThemeExtension({
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
    required this.gradientStart,
    required this.gradientEnd,
    required this.cardShadowColor,
  });

  /// Success color for positive actions and states
  final Color successColor;

  /// Warning color for cautionary states
  final Color warningColor;

  /// Info color for informational messages
  final Color infoColor;

  /// Base color for shimmer loading effect
  final Color shimmerBaseColor;

  /// Highlight color for shimmer loading effect
  final Color shimmerHighlightColor;

  /// Start color for gradient backgrounds
  final Color gradientStart;

  /// End color for gradient backgrounds
  final Color gradientEnd;

  /// Shadow color for elevated cards
  final Color cardShadowColor;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    Color? gradientStart,
    Color? gradientEnd,
    Color? cardShadowColor,
  }) {
    return AppThemeExtension(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor: shimmerHighlightColor ?? this.shimmerHighlightColor,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      cardShadowColor: cardShadowColor ?? this.cardShadowColor,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
      shimmerBaseColor:
          Color.lerp(shimmerBaseColor, other.shimmerBaseColor, t)!,
      shimmerHighlightColor:
          Color.lerp(shimmerHighlightColor, other.shimmerHighlightColor, t)!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      cardShadowColor: Color.lerp(cardShadowColor, other.cardShadowColor, t)!,
    );
  }

  /// Factory constructor for dark themes
  factory AppThemeExtension.dark({
    required Color primaryColor,
    required Color accentColor,
  }) {
    return AppThemeExtension(
      successColor: const Color(0xFF66BB6A),
      warningColor: const Color(0xFFFF9800),
      infoColor: accentColor,
      shimmerBaseColor: const Color(0xFF2A2A2A),
      shimmerHighlightColor: const Color(0xFF3A3A3A),
      gradientStart: primaryColor.withValues(alpha: 0.8),
      gradientEnd: primaryColor.withValues(alpha: 0.2),
      cardShadowColor: Colors.black.withValues(alpha: 0.3),
    );
  }

  /// Factory constructor for light themes
  factory AppThemeExtension.light({
    required Color primaryColor,
    required Color accentColor,
  }) {
    return AppThemeExtension(
      successColor: const Color(0xFF388E3C),
      warningColor: const Color(0xFFE65100),
      infoColor: accentColor,
      shimmerBaseColor: const Color(0xFFE0E0E0),
      shimmerHighlightColor: const Color(0xFFF5F5F5),
      gradientStart: primaryColor.withValues(alpha: 0.1),
      gradientEnd: primaryColor.withValues(alpha: 0.05),
      cardShadowColor: Colors.black.withValues(alpha: 0.1),
    );
  }
}

/// Helper extension to easily access custom theme properties
extension ThemeDataExtensions on ThemeData {
  /// Get the custom theme extension, or a fallback if not found
  AppThemeExtension get appExtension {
    return extension<AppThemeExtension>() ??
        AppThemeExtension.dark(
          primaryColor: colorScheme.primary,
          accentColor: colorScheme.tertiary,
        );
  }
}

