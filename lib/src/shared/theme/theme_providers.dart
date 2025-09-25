import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_model.dart';
import 'dart:math' as math;

/// Service class for theme persistence
class ThemeService {
  static const String _themeKey = 'selected_theme';

  /// Save the selected theme to shared preferences
  Future<void> saveTheme(AppThemeType themeType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeType.key);
  }

  /// Load the selected theme from shared preferences
  Future<AppThemeType> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeKey = prefs.getString(_themeKey);
    return AppThemeTypeExtension.fromKey(themeKey ?? '');
  }
}

/// Provider for the theme service
final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService();
});

/// State notifier for theme management
class ThemeNotifier extends StateNotifier<AppThemeType> {
  final ThemeService _themeService;

  ThemeNotifier(this._themeService) : super(AppThemeType.classicDark) {
    _loadInitialTheme();
  }

  /// Load the initial theme from shared preferences
  Future<void> _loadInitialTheme() async {
    final savedTheme = await _themeService.loadTheme();
    state = savedTheme;
    // Log contrast ratios for debugging
    logThemeContrasts(savedTheme.themeData, savedTheme.displayName);
  }

  /// Set a new theme and save it to persistence
  Future<void> setTheme(AppThemeType themeType) async {
    state = themeType;
    await _themeService.saveTheme(themeType);
    // Log contrast ratios for debugging
    logThemeContrasts(themeType.themeData, themeType.displayName);
  }

  /// Get the current theme data
  ThemeData get currentTheme => state.themeData;

  /// Get the current brightness
  Brightness get currentBrightness => state.brightness;

  /// Get the current primary color
  Color get currentPrimaryColor => state.primaryColor;

  /// Get the current accent color
  Color get currentAccentColor => state.accentColor;
}

/// Provider for the theme notifier
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeType>((ref) {
      final themeService = ref.watch(themeServiceProvider);
      return ThemeNotifier(themeService);
    });

/// Provider for the current theme data
final currentThemeProvider = Provider<ThemeData>((ref) {
  final currentThemeType = ref.watch(themeNotifierProvider);
  return currentThemeType.themeData;
});

// Removed - no longer needed since we're not using themeMode

/// Provider for the current primary color
final currentPrimaryColorProvider = Provider<Color>((ref) {
  final currentThemeType = ref.watch(themeNotifierProvider);
  return currentThemeType.primaryColor;
});

/// Provider for the current accent color
final currentAccentColorProvider = Provider<Color>((ref) {
  final currentThemeType = ref.watch(themeNotifierProvider);
  return currentThemeType.accentColor;
});

/// Calculate contrast ratio between two colors
double calculateContrastRatio(Color color1, Color color2) {
  double luminance(Color color) {
    double r = color.r / 255.0;
    double g = color.g / 255.0;
    double b = color.b / 255.0;

    r = r <= 0.03928
        ? r / 12.92
        : math.pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = g <= 0.03928
        ? g / 12.92
        : math.pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = b <= 0.03928
        ? b / 12.92
        : math.pow((b + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double lum1 = luminance(color1);
  double lum2 = luminance(color2);

  double brighter = math.max(lum1, lum2);
  double darker = math.min(lum1, lum2);

  return (brighter + 0.05) / (darker + 0.05);
}

/// Log contrast ratios for a theme
void logThemeContrasts(ThemeData theme, String themeName) {
  final colorScheme = theme.colorScheme;
  final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

  debugPrint('=== Contrast Ratios for $themeName ===');
  debugPrint(
    'Primary on Surface: ${calculateContrastRatio(colorScheme.primary, colorScheme.surface).toStringAsFixed(2)}',
  );
  debugPrint(
    'Secondary on Surface: ${calculateContrastRatio(colorScheme.secondary, colorScheme.surface).toStringAsFixed(2)}',
  );
  debugPrint(
    'On Surface on Surface: ${calculateContrastRatio(colorScheme.onSurface, colorScheme.surface).toStringAsFixed(2)}',
  );
  debugPrint(
    'On Surface Variant on Surface: ${calculateContrastRatio(colorScheme.onSurfaceVariant, colorScheme.surface).toStringAsFixed(2)}',
  );
  debugPrint(
    'Text Color on Surface: ${calculateContrastRatio(textColor, colorScheme.surface).toStringAsFixed(2)}',
  );
  debugPrint('=====================================');
}
