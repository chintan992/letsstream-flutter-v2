import 'dart:math';
import 'package:flutter/material.dart';

/// Utility class for validating color contrast ratios according to WCAG guidelines
class ColorContrastValidator {
  ColorContrastValidator._();

  /// Calculates the relative luminance of a color according to WCAG 2.1
  static double _getRelativeLuminance(Color color) {
    double toLinear(double component) {
      component = component / 255.0;
      if (component <= 0.03928) {
        return component / 12.92;
      } else {
        return pow((component + 0.055) / 1.055, 2.4).toDouble();
      }
    }

    final r = toLinear(color.red.toDouble());
    final g = toLinear(color.green.toDouble());
    final b = toLinear(color.blue.toDouble());

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculates the contrast ratio between two colors
  static double getContrastRatio(Color foregroundColor, Color backgroundColor) {
    final foregroundLuminance = _getRelativeLuminance(foregroundColor);
    final backgroundLuminance = _getRelativeLuminance(backgroundColor);

    final lighterLuminance = max(foregroundLuminance, backgroundLuminance);
    final darkerLuminance = min(foregroundLuminance, backgroundLuminance);

    return (lighterLuminance + 0.05) / (darkerLuminance + 0.05);
  }

  /// Checks if contrast ratio meets WCAG AA standards (minimum 4.5:1 for normal text)
  static bool meetsWCAGAA(Color foregroundColor, Color backgroundColor) {
    return getContrastRatio(foregroundColor, backgroundColor) >= 4.5;
  }

  /// Checks if contrast ratio meets WCAG AAA standards (minimum 7:1 for normal text)
  static bool meetsWCAGAAA(Color foregroundColor, Color backgroundColor) {
    return getContrastRatio(foregroundColor, backgroundColor) >= 7.0;
  }

  /// Checks if contrast ratio meets WCAG AA standards for large text (minimum 3:1)
  static bool meetsWCAGAALargeText(Color foregroundColor, Color backgroundColor) {
    return getContrastRatio(foregroundColor, backgroundColor) >= 3.0;
  }

  /// Validates a color scheme for accessibility compliance
  static Map<String, dynamic> validateColorScheme({
    required Color primaryText,
    required Color secondaryText,
    required Color primaryBackground,
    required Color surfaceBackground,
    required Color primaryColor,
    required String themeName,
  }) {
    final results = <String, dynamic>{
      'themeName': themeName,
      'passed': true,
      'issues': <String>[],
      'scores': <String, double>{},
    };

    // Check primary text on primary background
    final primaryTextRatio = getContrastRatio(primaryText, primaryBackground);
    results['scores']['primaryText_primaryBackground'] = primaryTextRatio;
    if (!meetsWCAGAA(primaryText, primaryBackground)) {
      results['passed'] = false;
      results['issues'].add(
          'Primary text on primary background fails WCAG AA (${primaryTextRatio.toStringAsFixed(2)}:1, needs 4.5:1)');
    }

    // Check secondary text on primary background
    final secondaryTextRatio = getContrastRatio(secondaryText, primaryBackground);
    results['scores']['secondaryText_primaryBackground'] = secondaryTextRatio;
    if (!meetsWCAGAA(secondaryText, primaryBackground)) {
      results['passed'] = false;
      results['issues'].add(
          'Secondary text on primary background fails WCAG AA (${secondaryTextRatio.toStringAsFixed(2)}:1, needs 4.5:1)');
    }

    // Check primary text on surface background
    final primaryTextSurfaceRatio = getContrastRatio(primaryText, surfaceBackground);
    results['scores']['primaryText_surfaceBackground'] = primaryTextSurfaceRatio;
    if (!meetsWCAGAA(primaryText, surfaceBackground)) {
      results['passed'] = false;
      results['issues'].add(
          'Primary text on surface background fails WCAG AA (${primaryTextSurfaceRatio.toStringAsFixed(2)}:1, needs 4.5:1)');
    }

    // Check white text on primary color (for buttons)
    final whiteOnPrimaryRatio = getContrastRatio(Colors.white, primaryColor);
    results['scores']['whiteText_primaryColor'] = whiteOnPrimaryRatio;
    if (!meetsWCAGAA(Colors.white, primaryColor)) {
      results['passed'] = false;
      results['issues'].add(
          'White text on primary color fails WCAG AA (${whiteOnPrimaryRatio.toStringAsFixed(2)}:1, needs 4.5:1)');
    }

    return results;
  }

  /// Validates all app themes for accessibility compliance
  static List<Map<String, dynamic>> validateAllThemes() {
    // This would import and validate all themes
    // For now, returning empty list as themes are imported in separate files
    return [];
  }

  /// Suggests a darker/lighter version of a color to meet contrast requirements
  static Color suggestAccessibleColor(Color originalColor, Color backgroundColor, {bool makeDarker = true}) {
    if (meetsWCAGAA(originalColor, backgroundColor)) {
      return originalColor;
    }

    final hsl = HSLColor.fromColor(originalColor);
    
    for (double i = 0.05; i <= 1.0; i += 0.05) {
      final adjustedColor = makeDarker 
          ? hsl.withLightness((hsl.lightness - i).clamp(0.0, 1.0)).toColor()
          : hsl.withLightness((hsl.lightness + i).clamp(0.0, 1.0)).toColor();
      
      if (meetsWCAGAA(adjustedColor, backgroundColor)) {
        return adjustedColor;
      }
    }
    
    return originalColor; // Return original if no suitable color found
  }
}