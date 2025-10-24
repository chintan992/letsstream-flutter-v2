/// Represents the current network quality for adaptive streaming.
enum NetworkQuality {
  /// Excellent network conditions.
  excellent,
  
  /// Good network conditions.
  good,
  
  /// Fair network conditions.
  fair,
  
  /// Poor network conditions.
  poor,
  
  /// Unknown network conditions.
  unknown,
}

/// Extension methods for NetworkQuality.
extension NetworkQualityExtension on NetworkQuality {
  /// Returns the recommended quality height for this network quality.
  int get recommendedHeight {
    switch (this) {
      case NetworkQuality.excellent:
        return 1080;
      case NetworkQuality.good:
        return 720;
      case NetworkQuality.fair:
        return 480;
      case NetworkQuality.poor:
        return 360;
      case NetworkQuality.unknown:
        return 720;
    }
  }

  /// Returns the recommended bitrate for this network quality.
  int get recommendedBitrate {
    switch (this) {
      case NetworkQuality.excellent:
        return 5000;
      case NetworkQuality.good:
        return 3000;
      case NetworkQuality.fair:
        return 1500;
      case NetworkQuality.poor:
        return 800;
      case NetworkQuality.unknown:
        return 2000;
    }
  }

  /// Returns a user-friendly description of the network quality.
  String get description {
    switch (this) {
      case NetworkQuality.excellent:
        return 'Excellent';
      case NetworkQuality.good:
        return 'Good';
      case NetworkQuality.fair:
        return 'Fair';
      case NetworkQuality.poor:
        return 'Poor';
      case NetworkQuality.unknown:
        return 'Unknown';
    }
  }
}
