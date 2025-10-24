import 'package:flutter/material.dart';
import 'theme_extensions.dart';
import 'tokens.dart';

/// Utility extension methods for easier theme access in widgets
extension BuildContextThemeExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get the text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get the custom app extension
  AppThemeExtension get appTheme => theme.appExtension;

  /// Quick access to primary color
  Color get primaryColor => colorScheme.primary;

  /// Quick access to secondary color
  Color get secondaryColor => colorScheme.secondary;

  /// Quick access to tertiary/accent color
  Color get accentColor => colorScheme.tertiary;

  /// Quick access to surface color
  Color get surfaceColor => colorScheme.surface;

  /// Quick access to background color
  Color get backgroundColor => theme.scaffoldBackgroundColor;

  /// Quick access to error color
  Color get errorColor => colorScheme.error;

  /// Quick access to success color from extension
  Color get successColor => appTheme.successColor;

  /// Quick access to warning color from extension
  Color get warningColor => appTheme.warningColor;

  /// Quick access to info color from extension
  Color get infoColor => appTheme.infoColor;

  /// Check if current theme is dark
  bool get isDarkTheme => theme.brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLightTheme => theme.brightness == Brightness.light;

  /// Get primary text color
  Color get primaryTextColor => colorScheme.onSurface;

  /// Get secondary text color
  Color get secondaryTextColor => colorScheme.onSurfaceVariant;
}

/// Extension for spacing utilities
extension SpacingExtensions on num {
  /// Convert number to SizedBox with vertical spacing
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Convert number to SizedBox with horizontal spacing
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// Convert number to EdgeInsets with all sides equal
  EdgeInsets get padding => EdgeInsets.all(toDouble());

  /// Convert number to EdgeInsets with horizontal padding
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: toDouble());

  /// Convert number to EdgeInsets with vertical padding
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());
}

/// Predefined spacing widgets using design tokens
class Spacing {
  Spacing._();

  // Vertical spacing
  static const verticalXS = SizedBox(height: Tokens.spaceXS);
  static const verticalS = SizedBox(height: Tokens.spaceS);
  static const verticalM = SizedBox(height: Tokens.spaceM);
  static const verticalL = SizedBox(height: Tokens.spaceL);
  static const verticalXL = SizedBox(height: Tokens.spaceXL);
  static const verticalXXL = SizedBox(height: Tokens.spaceXXL);

  // Horizontal spacing
  static const horizontalXS = SizedBox(width: Tokens.spaceXS);
  static const horizontalS = SizedBox(width: Tokens.spaceS);
  static const horizontalM = SizedBox(width: Tokens.spaceM);
  static const horizontalL = SizedBox(width: Tokens.spaceL);
  static const horizontalXL = SizedBox(width: Tokens.spaceXL);
  static const horizontalXXL = SizedBox(width: Tokens.spaceXXL);
}

/// Predefined padding values using design tokens
class Paddings {
  Paddings._();

  // All sides padding
  static const allXS = EdgeInsets.all(Tokens.spaceXS);
  static const allS = EdgeInsets.all(Tokens.spaceS);
  static const allM = EdgeInsets.all(Tokens.spaceM);
  static const allL = EdgeInsets.all(Tokens.spaceL);
  static const allXL = EdgeInsets.all(Tokens.spaceXL);
  static const allXXL = EdgeInsets.all(Tokens.spaceXXL);

  // Horizontal padding
  static const horizontalXS = EdgeInsets.symmetric(horizontal: Tokens.spaceXS);
  static const horizontalS = EdgeInsets.symmetric(horizontal: Tokens.spaceS);
  static const horizontalM = EdgeInsets.symmetric(horizontal: Tokens.spaceM);
  static const horizontalL = EdgeInsets.symmetric(horizontal: Tokens.spaceL);
  static const horizontalXL = EdgeInsets.symmetric(horizontal: Tokens.spaceXL);
  static const horizontalXXL = EdgeInsets.symmetric(horizontal: Tokens.spaceXXL);

  // Vertical padding
  static const verticalXS = EdgeInsets.symmetric(vertical: Tokens.spaceXS);
  static const verticalS = EdgeInsets.symmetric(vertical: Tokens.spaceS);
  static const verticalM = EdgeInsets.symmetric(vertical: Tokens.spaceM);
  static const verticalL = EdgeInsets.symmetric(vertical: Tokens.spaceL);
  static const verticalXL = EdgeInsets.symmetric(vertical: Tokens.spaceXL);
  static const verticalXXL = EdgeInsets.symmetric(vertical: Tokens.spaceXXL);
}

/// Border radius utilities using design tokens
class AppBorderRadius {
  AppBorderRadius._();

  static final small = BorderRadius.circular(Tokens.radiusS);
  static final medium = BorderRadius.circular(Tokens.radiusM);
  static final large = BorderRadius.circular(Tokens.radiusL);
  static final extraLarge = BorderRadius.circular(Tokens.radiusXL);
  static final circular = BorderRadius.circular(Tokens.radiusCircular);

  // Top-only rounded corners
  static const topSmall = BorderRadius.vertical(
    top: Radius.circular(Tokens.radiusS),
  );
  static const topMedium = BorderRadius.vertical(
    top: Radius.circular(Tokens.radiusM),
  );
  static const topLarge = BorderRadius.vertical(
    top: Radius.circular(Tokens.radiusL),
  );

  // Bottom-only rounded corners
  static const bottomSmall = BorderRadius.vertical(
    bottom: Radius.circular(Tokens.radiusS),
  );
  static const bottomMedium = BorderRadius.vertical(
    bottom: Radius.circular(Tokens.radiusM),
  );
  static const bottomLarge = BorderRadius.vertical(
    bottom: Radius.circular(Tokens.radiusL),
  );
}

