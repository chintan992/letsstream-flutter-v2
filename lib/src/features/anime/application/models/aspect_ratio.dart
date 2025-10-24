/// Represents different aspect ratio options for video playback.
enum AspectRatio {
  /// 16:9 aspect ratio (widescreen).
  widescreen,
  
  /// 4:3 aspect ratio (standard).
  standard,
  
  /// Fit to screen (maintain aspect ratio).
  fit,
  
  /// Fill screen (crop to fit).
  fill,
  
  /// Stretch to fill screen (distort if needed).
  stretch,
}

/// Extension methods for AspectRatio.
extension AspectRatioExtension on AspectRatio {
  /// Returns the display name for this aspect ratio.
  String get displayName {
    switch (this) {
      case AspectRatio.widescreen:
        return '16:9';
      case AspectRatio.standard:
        return '4:3';
      case AspectRatio.fit:
        return 'Fit';
      case AspectRatio.fill:
        return 'Fill';
      case AspectRatio.stretch:
        return 'Stretch';
    }
  }

  /// Returns the description for this aspect ratio.
  String get description {
    switch (this) {
      case AspectRatio.widescreen:
        return 'Widescreen (16:9)';
      case AspectRatio.standard:
        return 'Standard (4:3)';
      case AspectRatio.fit:
        return 'Fit to screen (maintain aspect ratio)';
      case AspectRatio.fill:
        return 'Fill screen (crop to fit)';
      case AspectRatio.stretch:
        return 'Stretch to fill (may distort)';
    }
  }

  /// Returns the aspect ratio value as a double.
  double get value {
    switch (this) {
      case AspectRatio.widescreen:
        return 16 / 9;
      case AspectRatio.standard:
        return 4 / 3;
      case AspectRatio.fit:
        return 16 / 9; // Default to widescreen for fit
      case AspectRatio.fill:
        return 16 / 9; // Default to widescreen for fill
      case AspectRatio.stretch:
        return 16 / 9; // Default to widescreen for stretch
    }
  }
}
