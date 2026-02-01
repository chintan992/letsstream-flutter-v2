import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'netflix_colors.dart';
import 'netflix_typography.dart';
import 'theme_extensions.dart';

/// Complete Netflix theme configuration
/// This is the main theme that will replace all other themes in the app
class NetflixTheme {
  NetflixTheme._();

  /// The main Netflix theme data
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: NetflixColors.backgroundBlack,
      textTheme: NetflixTypography.textTheme,
      extensions: [_themeExtension],

      // Component themes
      appBarTheme: _appBarTheme,
      navigationBarTheme: _navigationBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      dividerTheme: _dividerTheme,
      cardTheme: _cardTheme,
      tabBarTheme: _tabBarTheme,
      chipTheme: _chipTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomSheetTheme: _bottomSheetTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      iconTheme: _iconTheme,
      listTileTheme: _listTileTheme,
      sliderTheme: _sliderTheme,
    );
  }

  // ==================== Color Scheme ====================
  static ColorScheme get _colorScheme {
    return const ColorScheme.dark(
      primary: NetflixColors.primaryRed,
      secondary: NetflixColors.surfaceMedium,
      tertiary: NetflixColors.textSecondary,
      surface: NetflixColors.surfaceDark,
      surfaceContainerHighest: NetflixColors.surfaceHighest,
      onSurface: NetflixColors.textPrimary,
      onSurfaceVariant: NetflixColors.textSecondary,
      error: NetflixColors.error,
      onPrimary: NetflixColors.textPrimary,
      onSecondary: NetflixColors.textPrimary,
      onError: NetflixColors.textPrimary,
      brightness: Brightness.dark,
    );
  }

  // ==================== Theme Extension ====================
  static AppThemeExtension get _themeExtension {
    return AppThemeExtension.dark(
      primaryColor: NetflixColors.primaryRed,
      accentColor: NetflixColors.primaryRed,
    );
  }

  // ==================== Component Themes ====================

  /// AppBar theme - Transparent with white icons
  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(
        color: NetflixColors.textPrimary,
        size: 24,
      ),
      titleTextStyle: NetflixTypography.textTheme.titleLarge,
      actionsIconTheme: const IconThemeData(
        color: NetflixColors.textPrimary,
        size: 24,
      ),
    );
  }

  /// Navigation bar theme - Netflix style bottom nav
  static NavigationBarThemeData get _navigationBarTheme {
    return NavigationBarThemeData(
      backgroundColor: NetflixColors.backgroundBlack,
      elevation: 0,
      height: 56,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return NetflixTypography.navigationLabel.copyWith(
            color: NetflixColors.textPrimary,
            fontWeight: FontWeight.w600,
          );
        }
        return NetflixTypography.navigationLabel;
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: NetflixColors.textPrimary,
            size: 24,
          );
        }
        return const IconThemeData(
          color: NetflixColors.textTertiary,
          size: 24,
        );
      }),
    );
  }

  /// Elevated button theme - Primary red buttons
  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(NetflixColors.primaryRed),
        foregroundColor: WidgetStateProperty.all(NetflixColors.textPrimary),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        textStyle: WidgetStateProperty.all(NetflixTypography.buttonText),
        minimumSize: WidgetStateProperty.all(const Size(48, 48)),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return NetflixColors.primaryRedDark.withValues(alpha: 0.3);
          }
          if (states.contains(WidgetState.hovered)) {
            return NetflixColors.primaryRedLight.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Outlined button theme - Gray outlined buttons
  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: NetflixColors.textPrimary,
        side: const BorderSide(color: NetflixColors.textSecondary),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: NetflixTypography.buttonText.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: const Size(48, 48),
      ),
    );
  }

  /// Text button theme
  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: NetflixColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: NetflixTypography.textTheme.labelMedium,
        minimumSize: const Size(48, 48),
      ),
    );
  }

  /// Input decoration theme
  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: NetflixColors.surfaceMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: NetflixColors.textSecondary, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: NetflixColors.error, width: 1),
      ),
      labelStyle: const TextStyle(color: NetflixColors.textSecondary),
      hintStyle: const TextStyle(color: NetflixColors.textTertiary),
      prefixIconColor: NetflixColors.textTertiary,
      suffixIconColor: NetflixColors.textTertiary,
    );
  }

  /// Divider theme
  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: NetflixColors.surfaceLight,
      thickness: 1,
      space: 1,
    );
  }

  /// Card theme
  static CardThemeData get _cardTheme {
    return CardThemeData(
      elevation: 0,
      color: NetflixColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  /// Tab bar theme
  static TabBarThemeData get _tabBarTheme {
    return TabBarThemeData(
      labelColor: NetflixColors.textPrimary,
      unselectedLabelColor: NetflixColors.textTertiary,
      labelStyle: NetflixTypography.textTheme.labelMedium,
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: NetflixColors.textTertiary,
        letterSpacing: 0.4,
      ),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: NetflixColors.primaryRed, width: 3),
      ),
      dividerColor: Colors.transparent,
    );
  }

  /// Chip theme
  static ChipThemeData get _chipTheme {
    return ChipThemeData(
      backgroundColor: NetflixColors.surfaceMedium,
      selectedColor: NetflixColors.primaryRed.withValues(alpha: 0.2),
      labelStyle: const TextStyle(color: NetflixColors.textPrimary),
      secondaryLabelStyle: const TextStyle(color: NetflixColors.textPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: BorderSide.none,
    );
  }

  /// Floating action button theme
  static FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: NetflixColors.primaryRed,
      foregroundColor: NetflixColors.textPrimary,
      elevation: 0,
      shape: CircleBorder(),
    );
  }

  /// Bottom sheet theme
  static BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: NetflixColors.backgroundBlack,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    );
  }

  /// Dialog theme
  static DialogThemeData get _dialogTheme {
    return DialogThemeData(
      backgroundColor: NetflixColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Snack bar theme
  static SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      backgroundColor: NetflixColors.surfaceMedium,
      contentTextStyle: const TextStyle(color: NetflixColors.textPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      actionTextColor: NetflixColors.primaryRed,
    );
  }

  /// Progress indicator theme
  static ProgressIndicatorThemeData get _progressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: NetflixColors.primaryRed,
      linearTrackColor: NetflixColors.surfaceMedium,
      circularTrackColor: NetflixColors.surfaceMedium,
    );
  }

  /// Icon theme
  static IconThemeData get _iconTheme {
    return const IconThemeData(
      color: NetflixColors.textPrimary,
      size: 24,
    );
  }

  /// List tile theme
  static ListTileThemeData get _listTileTheme {
    return ListTileThemeData(
      iconColor: NetflixColors.textSecondary,
      textColor: NetflixColors.textPrimary,
      tileColor: Colors.transparent,
      selectedTileColor: NetflixColors.surfaceMedium,
      selectedColor: NetflixColors.primaryRed,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Slider theme
  static SliderThemeData get _sliderTheme {
    return SliderThemeData(
      activeTrackColor: NetflixColors.primaryRed,
      inactiveTrackColor: NetflixColors.surfaceMedium,
      thumbColor: NetflixColors.primaryRed,
      overlayColor: NetflixColors.primaryRed.withValues(alpha: 0.2),
      trackHeight: 2,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
    );
  }
}
