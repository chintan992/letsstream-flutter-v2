import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_model.dart';

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
  }

  /// Set a new theme and save it to persistence
  Future<void> setTheme(AppThemeType themeType) async {
    state = themeType;
    await _themeService.saveTheme(themeType);
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
