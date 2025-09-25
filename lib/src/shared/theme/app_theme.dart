import 'package:flutter/material.dart';

// Import all theme modules
export 'app_colors.dart';
export 'base_theme.dart';
export 'dark_theme.dart';
export 'light_theme.dart';
export 'blue_ocean_theme.dart';
export 'sunset_orange_theme.dart';
export 'forest_green_theme.dart';
export 'midnight_purple_theme.dart';
export 'rose_pink_theme.dart';
export 'amber_gold_theme.dart';

// Import theme classes for backward compatibility
import 'dark_theme.dart';
import 'light_theme.dart';
import 'blue_ocean_theme.dart';
import 'sunset_orange_theme.dart';
import 'forest_green_theme.dart';
import 'midnight_purple_theme.dart';
import 'rose_pink_theme.dart';
import 'amber_gold_theme.dart';

/// Main AppTheme class that provides access to all themes
class AppTheme {
  AppTheme._();

  // Export all theme getters for backward compatibility
  static ThemeData get darkTheme => DarkTheme.darkTheme;
  static ThemeData get lightTheme => LightTheme.lightTheme;
  static ThemeData get blueOceanTheme => BlueOceanTheme.blueOceanTheme;
  static ThemeData get sunsetOrangeTheme => SunsetOrangeTheme.sunsetOrangeTheme;
  static ThemeData get forestGreenTheme => ForestGreenTheme.forestGreenTheme;
  static ThemeData get midnightPurpleTheme =>
      MidnightPurpleTheme.midnightPurpleTheme;
  static ThemeData get rosePinkTheme => RosePinkTheme.rosePinkTheme;
  static ThemeData get amberGoldTheme => AmberGoldTheme.amberGoldTheme;
}
