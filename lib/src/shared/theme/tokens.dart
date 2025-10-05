/// Design tokens for consistent spacing, sizing, and timing across the app
class Tokens {
  Tokens._();

  // ==================== Spacing ====================
  /// Extra small spacing (4px) - tight spacing between related elements
  static const double spaceXS = 4.0;

  /// Small spacing (8px) - compact spacing for dense layouts
  static const double spaceS = 8.0;

  /// Medium spacing (12px) - comfortable spacing for most UI elements
  static const double spaceM = 12.0;

  /// Large spacing (16px) - generous spacing for sections
  static const double spaceL = 16.0;

  /// Extra large spacing (24px) - prominent spacing for major sections
  static const double spaceXL = 24.0;

  /// Double extra large spacing (32px) - maximum spacing for page sections
  static const double spaceXXL = 32.0;

  // ==================== Border Radius ====================
  /// Small radius (6px) - subtle rounded corners
  static const double radiusS = 6.0;

  /// Medium radius (12px) - standard rounded corners for cards and buttons
  static const double radiusM = 12.0;

  /// Large radius (16px) - prominent rounded corners
  static const double radiusL = 16.0;

  /// Extra large radius (24px) - highly rounded corners for special elements
  static const double radiusXL = 24.0;

  /// Circular radius (999px) - for circular elements
  static const double radiusCircular = 999.0;

  // ==================== Elevation ====================
  /// No elevation - flat surfaces
  static const double elevationNone = 0.0;

  /// Low elevation (2px) - subtle depth for cards
  static const double elevationLow = 2.0;

  /// Medium elevation (4px) - standard depth for floating elements
  static const double elevationMedium = 4.0;

  /// High elevation (8px) - prominent depth for modals and dialogs
  static const double elevationHigh = 8.0;

  /// Extra high elevation (16px) - maximum depth for tooltips and snackbars
  static const double elevationXHigh = 16.0;

  // ==================== Animation Durations ====================
  /// Fast animation (150ms) - quick transitions for hover/focus states
  static const Duration durFast = Duration(milliseconds: 150);

  /// Medium animation (250ms) - standard transitions for most UI changes
  static const Duration durMed = Duration(milliseconds: 250);

  /// Slow animation (400ms) - emphasized transitions for major changes
  static const Duration durSlow = Duration(milliseconds: 400);

  /// Extra slow animation (600ms) - dramatic transitions for page changes
  static const Duration durXSlow = Duration(milliseconds: 600);

  // ==================== Typography Sizes ====================
  /// Display large text size (32px)
  static const double textDisplayLarge = 32.0;

  /// Display medium text size (28px)
  static const double textDisplayMedium = 28.0;

  /// Display small text size (24px)
  static const double textDisplaySmall = 24.0;

  /// Headline medium text size (20px)
  static const double textHeadlineMedium = 20.0;

  /// Headline small text size (18px)
  static const double textHeadlineSmall = 18.0;

  /// Title large text size (16px)
  static const double textTitleLarge = 16.0;

  /// Body large text size (16px)
  static const double textBodyLarge = 16.0;

  /// Body medium text size (14px)
  static const double textBodyMedium = 14.0;

  /// Body small text size (12px)
  static const double textBodySmall = 12.0;

  /// Label text size (14px)
  static const double textLabel = 14.0;

  // ==================== Icon Sizes ====================
  /// Small icon size (16px)
  static const double iconSmall = 16.0;

  /// Medium icon size (24px) - standard icon size
  static const double iconMedium = 24.0;

  /// Large icon size (32px)
  static const double iconLarge = 32.0;

  /// Extra large icon size (48px)
  static const double iconXLarge = 48.0;

  // ==================== Media Sizes ====================
  /// Poster card width (120px)
  static const double posterCardWidth = 120.0;

  /// Poster aspect ratio (width / height = 2:3)
  static const double posterAspect = 2 / 3;

  /// Backdrop aspect ratio (width / height = 16:9)
  static const double backdropAspect = 16 / 9;

  // ==================== Breakpoints ====================
  /// Mobile breakpoint (600px)
  static const double breakpointMobile = 600.0;

  /// Tablet breakpoint (900px)
  static const double breakpointTablet = 900.0;

  /// Desktop breakpoint (1200px)
  static const double breakpointDesktop = 1200.0;

  // ==================== Opacity ====================
  /// Disabled opacity (0.38)
  static const double opacityDisabled = 0.38;

  /// Medium opacity (0.6)
  static const double opacityMedium = 0.6;

  /// High opacity (0.87)
  static const double opacityHigh = 0.87;
}
