import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Enum representing different predefined themes
enum AppThemeType {
  // Original Themes
  classicDark('Classic Dark', 'Dark theme with purple accents'),
  classicLight('Classic Light', 'Light theme with purple accents'),
  blueOcean('Blue Ocean', 'Dark theme with blue accents'),
  sunsetOrange('Sunset Orange', 'Dark theme with orange accents'),
  forestGreen('Forest Green', 'Dark theme with green accents'),
  midnightPurple('Midnight Purple', 'Dark theme with deep purple accents'),
  rosePink('Rose Pink', 'Light theme with pink accents'),
  amberGold('Amber Gold', 'Dark theme with golden accents'),
  
  // New Light Themes
  lavenderDream('Lavender Dream', 'Light theme with soft lavender accents'),
  mintFresh('Mint Fresh', 'Light theme with fresh mint green accents'),
  coralSunset('Coral Sunset', 'Light theme with warm coral accents'),
  skyBlue('Sky Blue', 'Light theme with soft blue accents'),
  honeyGold('Honey Gold', 'Light theme with warm golden accents'),
  
  // New Dark Themes
  emeraldNight('Emerald Night', 'Dark theme with rich emerald accents'),
  deepOcean('Deep Ocean', 'Dark theme with deep navy blue accents'),
  rubyRed('Ruby Red', 'Dark theme with rich ruby red accents'),
  slateGray('Slate Gray', 'Dark theme with cool slate gray accents'),
  violetDusk('Violet Dusk', 'Dark theme with rich violet accents'),
  crimsonNight('Crimson Night', 'Dark theme with deep crimson accents'),
  tealWave('Teal Wave', 'Dark theme with teal cyan accents'),
  indigoDeep('Indigo Deep', 'Dark theme with deep indigo accents');

  const AppThemeType(this.displayName, this.description);

  final String displayName;
  final String description;

  /// Get the theme data for this theme type
  ThemeData get themeData {
    switch (this) {
      // Original Themes
      case AppThemeType.classicDark:
        return AppTheme.darkTheme;
      case AppThemeType.classicLight:
        return AppTheme.lightTheme;
      case AppThemeType.blueOcean:
        return AppTheme.blueOceanTheme;
      case AppThemeType.sunsetOrange:
        return AppTheme.sunsetOrangeTheme;
      case AppThemeType.forestGreen:
        return AppTheme.forestGreenTheme;
      case AppThemeType.midnightPurple:
        return AppTheme.midnightPurpleTheme;
      case AppThemeType.rosePink:
        return AppTheme.rosePinkTheme;
      case AppThemeType.amberGold:
        return AppTheme.amberGoldTheme;
      
      // New Light Themes
      case AppThemeType.lavenderDream:
        return AppTheme.lavenderDreamTheme;
      case AppThemeType.mintFresh:
        return AppTheme.mintFreshTheme;
      case AppThemeType.coralSunset:
        return AppTheme.coralSunsetTheme;
      case AppThemeType.skyBlue:
        return AppTheme.skyBlueTheme;
      case AppThemeType.honeyGold:
        return AppTheme.honeyGoldTheme;
      
      // New Dark Themes
      case AppThemeType.emeraldNight:
        return AppTheme.emeraldNightTheme;
      case AppThemeType.deepOcean:
        return AppTheme.deepOceanTheme;
      case AppThemeType.rubyRed:
        return AppTheme.rubyRedTheme;
      case AppThemeType.slateGray:
        return AppTheme.slateGrayTheme;
      case AppThemeType.violetDusk:
        return AppTheme.violetDuskTheme;
      case AppThemeType.crimsonNight:
        return AppTheme.crimsonNightTheme;
      case AppThemeType.tealWave:
        return AppTheme.tealWaveTheme;
      case AppThemeType.indigoDeep:
        return AppTheme.indigoDeepTheme;
    }
  }

  /// Get the brightness of this theme
  Brightness get brightness {
    switch (this) {
      // Light themes
      case AppThemeType.classicLight:
      case AppThemeType.rosePink:
      case AppThemeType.lavenderDream:
      case AppThemeType.mintFresh:
      case AppThemeType.coralSunset:
      case AppThemeType.skyBlue:
      case AppThemeType.honeyGold:
        return Brightness.light;
      // Dark themes
      default:
        return Brightness.dark;
    }
  }

  /// Get the primary color for this theme
  Color get primaryColor {
    switch (this) {
      // Original themes
      case AppThemeType.classicDark:
      case AppThemeType.classicLight:
        return AppColors.primaryColor;
      case AppThemeType.blueOcean:
        return AppColors.blueOceanPrimary;
      case AppThemeType.sunsetOrange:
        return AppColors.sunsetOrangePrimary;
      case AppThemeType.forestGreen:
        return AppColors.forestGreenPrimary;
      case AppThemeType.midnightPurple:
        return AppColors.midnightPurplePrimary;
      case AppThemeType.rosePink:
        return AppColors.rosePinkPrimary;
      case AppThemeType.amberGold:
        return AppColors.amberGoldPrimary;
      
      // New light themes
      case AppThemeType.lavenderDream:
        return AppColors.lavenderDreamPrimary;
      case AppThemeType.mintFresh:
        return AppColors.mintFreshPrimary;
      case AppThemeType.coralSunset:
        return AppColors.coralSunsetPrimary;
      case AppThemeType.skyBlue:
        return AppColors.skyBluePrimary;
      case AppThemeType.honeyGold:
        return AppColors.honeyGoldPrimary;
      
      // New dark themes
      case AppThemeType.emeraldNight:
        return AppColors.emeraldNightPrimary;
      case AppThemeType.deepOcean:
        return AppColors.deepOceanPrimary;
      case AppThemeType.rubyRed:
        return AppColors.rubyRedPrimary;
      case AppThemeType.slateGray:
        return AppColors.slateGrayPrimary;
      case AppThemeType.violetDusk:
        return AppColors.violetDuskPrimary;
      case AppThemeType.crimsonNight:
        return AppColors.crimsonNightPrimary;
      case AppThemeType.tealWave:
        return AppColors.tealWavePrimary;
      case AppThemeType.indigoDeep:
        return AppColors.indigoDeepPrimary;
    }
  }

  /// Get the accent color for this theme
  Color get accentColor {
    switch (this) {
      // Original themes
      case AppThemeType.classicDark:
      case AppThemeType.classicLight:
        return AppColors.accentColor;
      case AppThemeType.blueOcean:
        return AppColors.blueOceanAccent;
      case AppThemeType.sunsetOrange:
        return AppColors.sunsetOrangeAccent;
      case AppThemeType.forestGreen:
        return AppColors.forestGreenAccent;
      case AppThemeType.midnightPurple:
        return AppColors.midnightPurpleAccent;
      case AppThemeType.rosePink:
        return AppColors.rosePinkAccent;
      case AppThemeType.amberGold:
        return AppColors.amberGoldAccent;
      
      // New light themes
      case AppThemeType.lavenderDream:
        return AppColors.lavenderDreamAccent;
      case AppThemeType.mintFresh:
        return AppColors.mintFreshAccent;
      case AppThemeType.coralSunset:
        return AppColors.coralSunsetAccent;
      case AppThemeType.skyBlue:
        return AppColors.skyBlueAccent;
      case AppThemeType.honeyGold:
        return AppColors.honeyGoldAccent;
      
      // New dark themes
      case AppThemeType.emeraldNight:
        return AppColors.emeraldNightAccent;
      case AppThemeType.deepOcean:
        return AppColors.deepOceanAccent;
      case AppThemeType.rubyRed:
        return AppColors.rubyRedAccent;
      case AppThemeType.slateGray:
        return AppColors.slateGrayAccent;
      case AppThemeType.violetDusk:
        return AppColors.violetDuskAccent;
      case AppThemeType.crimsonNight:
        return AppColors.crimsonNightAccent;
      case AppThemeType.tealWave:
        return AppColors.tealWaveAccent;
      case AppThemeType.indigoDeep:
        return AppColors.indigoDeepAccent;
    }
  }
}

/// Extension to get theme type from string (for persistence)
extension AppThemeTypeExtension on AppThemeType {
  String get key => name;

  static AppThemeType fromKey(String key) {
    return AppThemeType.values.firstWhere(
      (theme) => theme.key == key,
      orElse: () => AppThemeType.classicDark, // Default fallback
    );
  }
}
