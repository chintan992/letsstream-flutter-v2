import 'package:flutter/material.dart';

// Export all theme modules
export 'app_colors.dart';
export 'base_theme.dart';

// Original themes
export 'dark_theme.dart';
export 'light_theme.dart';
export 'blue_ocean_theme.dart';
export 'sunset_orange_theme.dart';
export 'forest_green_theme.dart';
export 'midnight_purple_theme.dart';
export 'rose_pink_theme.dart';
export 'amber_gold_theme.dart';

// New light themes
export 'lavender_dream_theme.dart';
export 'mint_fresh_theme.dart';
export 'coral_sunset_theme.dart';
export 'sky_blue_theme.dart';
export 'honey_gold_theme.dart';

// New dark themes
export 'emerald_night_theme.dart';
export 'deep_ocean_theme.dart';
export 'ruby_red_theme.dart';
export 'slate_gray_theme.dart';
export 'violet_dusk_theme.dart';
export 'crimson_night_theme.dart';
export 'teal_wave_theme.dart';
export 'indigo_deep_theme.dart';

// Export new composition system
export 'theme_composer.dart';
export 'theme_extensions.dart';
export 'theme_utils.dart';
export 'tokens.dart';

// Import theme classes for backward compatibility
// Original themes
import 'dark_theme.dart';
import 'light_theme.dart';
import 'blue_ocean_theme.dart';
import 'sunset_orange_theme.dart';
import 'forest_green_theme.dart';
import 'midnight_purple_theme.dart';
import 'rose_pink_theme.dart';
import 'amber_gold_theme.dart';

// New light themes
import 'lavender_dream_theme.dart';
import 'mint_fresh_theme.dart';
import 'coral_sunset_theme.dart';
import 'sky_blue_theme.dart';
import 'honey_gold_theme.dart';

// New dark themes
import 'emerald_night_theme.dart';
import 'deep_ocean_theme.dart';
import 'ruby_red_theme.dart';
import 'slate_gray_theme.dart';
import 'violet_dusk_theme.dart';
import 'crimson_night_theme.dart';
import 'teal_wave_theme.dart';
import 'indigo_deep_theme.dart';

/// Main AppTheme class that provides access to all themes
///
/// This class serves as a centralized access point for all app themes.
/// All themes now use the ThemeComposer for consistent composition.
///
/// Available themes:
/// - 7 Light themes: Classic Light, Rose Pink, Lavender Dream, Mint Fresh,
///   Coral Sunset, Sky Blue, Honey Gold
/// - 14 Dark themes: Classic Dark, Blue Ocean, Sunset Orange, Forest Green,
///   Midnight Purple, Amber Gold, Emerald Night, Deep Ocean, Ruby Red,
///   Slate Gray, Violet Dusk, Crimson Night, Teal Wave, Indigo Deep
class AppTheme {
  AppTheme._();

  // ==================== Original Themes ====================
  static ThemeData get darkTheme => DarkTheme.darkTheme;
  static ThemeData get lightTheme => LightTheme.lightTheme;
  static ThemeData get blueOceanTheme => BlueOceanTheme.blueOceanTheme;
  static ThemeData get sunsetOrangeTheme => SunsetOrangeTheme.sunsetOrangeTheme;
  static ThemeData get forestGreenTheme => ForestGreenTheme.forestGreenTheme;
  static ThemeData get midnightPurpleTheme =>
      MidnightPurpleTheme.midnightPurpleTheme;
  static ThemeData get rosePinkTheme => RosePinkTheme.rosePinkTheme;
  static ThemeData get amberGoldTheme => AmberGoldTheme.amberGoldTheme;

  // ==================== New Light Themes ====================
  static ThemeData get lavenderDreamTheme =>
      LavenderDreamTheme.lavenderDreamTheme;
  static ThemeData get mintFreshTheme => MintFreshTheme.mintFreshTheme;
  static ThemeData get coralSunsetTheme => CoralSunsetTheme.coralSunsetTheme;
  static ThemeData get skyBlueTheme => SkyBlueTheme.skyBlueTheme;
  static ThemeData get honeyGoldTheme => HoneyGoldTheme.honeyGoldTheme;

  // ==================== New Dark Themes ====================
  static ThemeData get emeraldNightTheme =>
      EmeraldNightTheme.emeraldNightTheme;
  static ThemeData get deepOceanTheme => DeepOceanTheme.deepOceanTheme;
  static ThemeData get rubyRedTheme => RubyRedTheme.rubyRedTheme;
  static ThemeData get slateGrayTheme => SlateGrayTheme.slateGrayTheme;
  static ThemeData get violetDuskTheme => VioletDuskTheme.violetDuskTheme;
  static ThemeData get crimsonNightTheme =>
      CrimsonNightTheme.crimsonNightTheme;
  static ThemeData get tealWaveTheme => TealWaveTheme.tealWaveTheme;
  static ThemeData get indigoDeepTheme => IndigoDeepTheme.indigoDeepTheme;
}
