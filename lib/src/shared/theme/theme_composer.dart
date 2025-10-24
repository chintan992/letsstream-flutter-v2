import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'theme_extensions.dart';
import 'tokens.dart';

/// Configuration for composing a theme
@immutable
class ThemeConfig {
  /// Creates a theme configuration
  const ThemeConfig({
    required this.brightness,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.surfaceHighestColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    this.errorColor = AppColors.errorColor,
  });

  /// The brightness of the theme (light or dark)
  final Brightness brightness;

  /// Primary brand color
  final Color primaryColor;

  /// Secondary brand color
  final Color secondaryColor;

  /// Accent/tertiary color
  final Color accentColor;

  /// Main background color
  final Color backgroundColor;

  /// Surface color for cards and elevated elements
  final Color surfaceColor;

  /// Highest surface color for nested surfaces
  final Color surfaceHighestColor;

  /// Primary text color
  final Color primaryTextColor;

  /// Secondary text color
  final Color secondaryTextColor;

  /// Error color
  final Color errorColor;

  /// Whether this is a dark theme
  bool get isDark => brightness == Brightness.dark;

  /// Factory constructor for dark themes
  factory ThemeConfig.dark({
    required Color primaryColor,
    required Color accentColor,
    Color secondaryColor = AppColors.secondaryColor,
  }) {
    return ThemeConfig(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      accentColor: accentColor,
      backgroundColor: AppColors.darkBackground,
      surfaceColor: AppColors.darkSurface,
      surfaceHighestColor: AppColors.darkSurfaceHighest,
      primaryTextColor: AppColors.darkTextPrimary,
      secondaryTextColor: AppColors.darkTextSecondary,
    );
  }

  /// Factory constructor for light themes
  factory ThemeConfig.light({
    required Color primaryColor,
    required Color accentColor,
    Color secondaryColor = AppColors.secondaryColor,
  }) {
    return ThemeConfig(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      accentColor: accentColor,
      backgroundColor: AppColors.lightBackground,
      surfaceColor: AppColors.lightSurface,
      surfaceHighestColor: AppColors.lightSurfaceHighest,
      primaryTextColor: AppColors.lightTextPrimary,
      secondaryTextColor: AppColors.lightTextSecondary,
    );
  }
}

/// Composes ThemeData from a ThemeConfig with consistent styling
class ThemeComposer {
  ThemeComposer._();

  /// Compose a complete ThemeData from a ThemeConfig
  static ThemeData compose(ThemeConfig config) {
    final colorScheme = _buildColorScheme(config);
    final textTheme = _buildTextTheme(config);
    final appExtension = config.isDark
        ? AppThemeExtension.dark(
            primaryColor: config.primaryColor,
            accentColor: config.accentColor,
          )
        : AppThemeExtension.light(
            primaryColor: config.primaryColor,
            accentColor: config.accentColor,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: config.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: config.backgroundColor,
      textTheme: textTheme,
      extensions: [appExtension],

      // Component Themes
      appBarTheme: _buildAppBarTheme(config),
      navigationBarTheme: _buildNavigationBarTheme(config),
      elevatedButtonTheme: _buildElevatedButtonTheme(config),
      inputDecorationTheme: _buildInputDecorationTheme(config),
      dividerTheme: _buildDividerTheme(config),
      cardTheme: _buildCardTheme(config),
      tabBarTheme: _buildTabBarTheme(config),
      chipTheme: _buildChipTheme(config),
      floatingActionButtonTheme: _buildFABTheme(config),
      bottomSheetTheme: _buildBottomSheetTheme(config),
      dialogTheme: _buildDialogTheme(config),
      snackBarTheme: _buildSnackBarTheme(config),
    );
  }

  /// Build color scheme from config
  static ColorScheme _buildColorScheme(ThemeConfig config) {
    if (config.isDark) {
      return ColorScheme.dark(
        primary: config.primaryColor,
        secondary: config.secondaryColor,
        tertiary: config.accentColor,
        surface: config.surfaceColor,
        surfaceContainerHighest: config.surfaceHighestColor,
        onSurface: config.primaryTextColor,
        onSurfaceVariant: config.secondaryTextColor,
        error: config.errorColor,
      );
    } else {
      return ColorScheme.light(
        primary: config.primaryColor,
        secondary: config.secondaryColor,
        tertiary: config.accentColor,
        surface: config.surfaceColor,
        surfaceContainerHighest: config.surfaceHighestColor,
        onSurface: config.primaryTextColor,
        onSurfaceVariant: config.secondaryTextColor,
        error: config.errorColor,
      );
    }
  }

  /// Build text theme from config
  static TextTheme _buildTextTheme(ThemeConfig config) {
    return GoogleFonts.allertaTextTheme().copyWith(
      displayLarge: GoogleFonts.allerta(
        fontSize: Tokens.textDisplayLarge,
        fontWeight: FontWeight.bold,
        color: config.primaryTextColor,
      ),
      displayMedium: GoogleFonts.allerta(
        fontSize: Tokens.textDisplayMedium,
        fontWeight: FontWeight.bold,
        color: config.primaryTextColor,
      ),
      displaySmall: GoogleFonts.allerta(
        fontSize: Tokens.textDisplaySmall,
        fontWeight: FontWeight.w600,
        color: config.primaryTextColor,
      ),
      headlineMedium: GoogleFonts.allerta(
        fontSize: Tokens.textHeadlineMedium,
        fontWeight: FontWeight.w600,
        color: config.primaryTextColor,
      ),
      headlineSmall: GoogleFonts.allerta(
        fontSize: Tokens.textHeadlineSmall,
        fontWeight: FontWeight.w500,
        color: config.primaryTextColor,
      ),
      titleLarge: GoogleFonts.allerta(
        fontSize: Tokens.textTitleLarge,
        fontWeight: FontWeight.w600,
        color: config.primaryTextColor,
      ),
      bodyLarge: GoogleFonts.allerta(
        fontSize: Tokens.textBodyLarge,
        fontWeight: FontWeight.w500,
        color: config.primaryTextColor,
      ),
      bodyMedium: GoogleFonts.allerta(
        fontSize: Tokens.textBodyMedium,
        fontWeight: FontWeight.w500,
        color: config.secondaryTextColor,
      ),
      labelLarge: GoogleFonts.allerta(
        fontSize: Tokens.textLabel,
        fontWeight: FontWeight.w600,
        color: config.primaryTextColor,
      ),
    );
  }

  /// Build AppBar theme
  static AppBarTheme _buildAppBarTheme(ThemeConfig config) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: Tokens.elevationNone,
      centerTitle: true,
      iconTheme: IconThemeData(color: config.primaryTextColor),
      titleTextStyle: TextStyle(
        fontSize: Tokens.textHeadlineMedium,
        fontWeight: FontWeight.bold,
        color: config.primaryTextColor,
      ),
    );
  }

  /// Build NavigationBar theme
  static NavigationBarThemeData _buildNavigationBarTheme(ThemeConfig config) {
    return NavigationBarThemeData(
      backgroundColor: config.surfaceColor,
      indicatorColor: config.primaryColor.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: Tokens.textBodySmall,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: config.primaryColor);
        }
        return IconThemeData(color: config.secondaryTextColor);
      }),
    );
  }

  /// Build ElevatedButton theme
  static ElevatedButtonThemeData _buildElevatedButtonTheme(ThemeConfig config) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        elevation: config.isDark ? Tokens.elevationMedium : Tokens.elevationLow,
        padding: const EdgeInsets.symmetric(
          horizontal: Tokens.spaceXL,
          vertical: Tokens.spaceM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Tokens.radiusM),
        ),
      ),
    );
  }

  /// Build InputDecoration theme
  static InputDecorationTheme _buildInputDecorationTheme(ThemeConfig config) {
    final fillColor = config.isDark
        ? config.surfaceColor
        : const Color(0xFFF8F9FA);
    final borderColor = config.isDark
        ? Colors.white.withValues(alpha: 0.1)
        : const Color(0xFFE0E0E0);

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Tokens.spaceL,
        vertical: Tokens.spaceM + 2,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusM),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusM),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusM),
        borderSide: BorderSide(color: config.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusM),
        borderSide: BorderSide(color: config.errorColor),
      ),
      labelStyle: TextStyle(color: config.secondaryTextColor),
      hintStyle: TextStyle(
        color: config.secondaryTextColor.withValues(alpha: 0.6),
      ),
    );
  }

  /// Build Divider theme
  static DividerThemeData _buildDividerTheme(ThemeConfig config) {
    return DividerThemeData(
      color: config.isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.shade300,
      thickness: 1,
    );
  }

  /// Build Card theme
  static CardThemeData _buildCardTheme(ThemeConfig config) {
    return CardThemeData(
      elevation: Tokens.elevationLow,
      color: config.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusM),
      ),
    );
  }

  /// Build TabBar theme
  static TabBarThemeData _buildTabBarTheme(ThemeConfig config) {
    return TabBarThemeData(
      labelColor: config.primaryColor,
      unselectedLabelColor: config.secondaryTextColor,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: config.primaryColor, width: 2),
      ),
    );
  }

  /// Build Chip theme
  static ChipThemeData _buildChipTheme(ThemeConfig config) {
    return ChipThemeData(
      backgroundColor: config.surfaceHighestColor,
      selectedColor: config.primaryColor.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: config.primaryTextColor),
      padding: const EdgeInsets.symmetric(
        horizontal: Tokens.spaceM,
        vertical: Tokens.spaceS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusM),
      ),
    );
  }

  /// Build FloatingActionButton theme
  static FloatingActionButtonThemeData _buildFABTheme(ThemeConfig config) {
    return FloatingActionButtonThemeData(
      backgroundColor: config.primaryColor,
      foregroundColor: Colors.white,
      elevation: Tokens.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusL),
      ),
    );
  }

  /// Build BottomSheet theme
  static BottomSheetThemeData _buildBottomSheetTheme(ThemeConfig config) {
    return BottomSheetThemeData(
      backgroundColor: config.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Tokens.radiusL),
        ),
      ),
    );
  }

  /// Build Dialog theme
  static DialogThemeData _buildDialogTheme(ThemeConfig config) {
    return DialogThemeData(
      backgroundColor: config.surfaceColor,
      elevation: Tokens.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusL),
      ),
    );
  }

  /// Build SnackBar theme
  static SnackBarThemeData _buildSnackBarTheme(ThemeConfig config) {
    return SnackBarThemeData(
      backgroundColor: config.surfaceHighestColor,
      contentTextStyle: TextStyle(color: config.primaryTextColor),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusM),
      ),
    );
  }
}

