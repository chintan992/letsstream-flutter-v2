import 'package:flutter/material.dart';

// Export all theme modules
export 'app_colors.dart';
export 'base_theme.dart';

// Netflix theme - the only theme
export 'netflix_colors.dart';
export 'netflix_typography.dart';
export 'netflix_theme.dart';

// Export new composition system (kept for backward compatibility)
export 'theme_composer.dart';
export 'theme_extensions.dart';
export 'theme_utils.dart';
export 'tokens.dart';

// Import Netflix theme
import 'netflix_theme.dart';

/// Main AppTheme class that provides access to the Netflix theme
///
/// This class now only provides the Netflix-inspired theme.
/// All legacy themes have been replaced for a consistent Netflix-style UI.
class AppTheme {
  AppTheme._();

  /// Netflix theme - the only available theme
  static ThemeData get netflixTheme => NetflixTheme.themeData;
}
