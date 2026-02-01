import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for managing accessibility features and preferences
class AccessibilityService {
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  /// Check if the device has accessibility features enabled
  bool get isAccessibilityEnabled {
    // This would typically check system accessibility settings
    // For now, we'll use a simple heuristic
    return true; // Accessibility features are always available
  }

  /// Get the current text scale factor from system settings
  double get textScaleFactor {
    return WidgetsBinding.instance.platformDispatcher.textScaleFactor;
  }

  /// Check if high contrast mode is enabled
  bool get isHighContrastEnabled {
    final features =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    return features.highContrast;
  }

  /// Check if reduce motion is enabled
  bool get isReduceMotionEnabled {
    final features =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    return features.reduceMotion;
  }

  /// Check if bold text is enabled
  bool get isBoldTextEnabled {
    final features =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    return features.boldText;
  }

  /// Get recommended touch target size based on accessibility needs
  double getRecommendedTouchTargetSize(BuildContext context) {
    // Minimum touch target size should be 44x44 points for accessibility
    return isAccessibilityEnabled ? 48.0 : 44.0;
  }

  /// Get accessible text style with proper scaling
  TextStyle getAccessibleTextStyle(
    BuildContext context,
    TextStyle? baseStyle, {
    bool ensureMinimumSize = true,
  }) {
    final theme = Theme.of(context);
    final scaleFactor = textScaleFactor;

    TextStyle style =
        baseStyle ?? theme.textTheme.bodyMedium ?? const TextStyle();

    // Apply text scaling
    style = style.copyWith(
      fontSize: style.fontSize != null ? style.fontSize! * scaleFactor : null,
    );

    // Ensure minimum readable size if requested
    if (ensureMinimumSize && style.fontSize != null && style.fontSize! < 14.0) {
      style = style.copyWith(fontSize: 14.0);
    }

    // Apply bold text if enabled
    if (isBoldTextEnabled) {
      style = style.copyWith(fontWeight: FontWeight.w600);
    }

    return style;
  }

  /// Create accessible button with proper semantics
  Widget buildAccessibleButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback onPressed,
    required String label,
    String? hint,
    bool enabled = true,
    FocusNode? focusNode,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      enabled: enabled,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          focusNode: focusNode,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: BoxConstraints(
              minWidth: getRecommendedTouchTargetSize(context),
              minHeight: getRecommendedTouchTargetSize(context),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Create accessible card with proper semantics
  Widget buildAccessibleCard({
    required BuildContext context,
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
    bool selected = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      selected: selected,
      button: onTap != null,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: BoxConstraints(
              minHeight: getRecommendedTouchTargetSize(context),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Create accessible image with alt text
  Widget buildAccessibleImage({
    required String? imageUrl,
    required String altText,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Semantics(
      label: altText,
      image: true,
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholder ?? const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return errorWidget ?? const Icon(Icons.broken_image);
              },
            )
          : errorWidget ?? const Icon(Icons.image_not_supported),
    );
  }

  /// Create accessible list item
  Widget buildAccessibleListItem({
    required BuildContext context,
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
    bool selected = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      selected: selected,
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            minHeight: getRecommendedTouchTargetSize(context),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Announce content to screen readers
  void announce(String message) {
    // The new sendAnnouncement API requires a FlutterView parameter.
    // Using deprecated method until multi-view support is added.
    // ignore: deprecated_member_use
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Create accessible focus indicator
  Widget buildFocusIndicator({
    required BuildContext context,
    required Widget child,
    bool showFocusRing = true,
  }) {
    if (!showFocusRing) return child;

    return Focus(
      child: Builder(
        builder: (context) {
          final focused = Focus.of(context).hasFocus;
          return Container(
            decoration: focused
                ? BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  )
                : null,
            child: child,
          );
        },
      ),
    );
  }

  /// Get accessible colors that meet contrast requirements
  Color getAccessibleColor({
    required BuildContext context,
    required Color backgroundColor,
    bool isOnBackground = false,
  }) {
    if (!isHighContrastEnabled) {
      return isOnBackground
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.primary;
    }

    // For high contrast mode, ensure better contrast
    return isOnBackground
        ? backgroundColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white
        : Theme.of(context).colorScheme.primary;
  }
}

// Riverpod provider
final accessibilityServiceProvider = Provider<AccessibilityService>((ref) {
  return AccessibilityService();
});

// Provider for text scale factor
final textScaleFactorProvider = Provider<double>((ref) {
  return AccessibilityService().textScaleFactor;
});

// Provider for accessibility features
final accessibilityFeaturesProvider = Provider<AccessibilityFeatures>((ref) {
  return WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
});
