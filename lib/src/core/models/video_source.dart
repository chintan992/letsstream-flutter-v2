/// Represents a video streaming source configuration for movies and TV shows.
///
/// This model defines the URL patterns and metadata needed to construct
/// streaming URLs for different video sources. Each source has unique
/// patterns for movies and TV shows, allowing the application to build
/// proper streaming URLs based on content type and identifiers.
///
/// ```dart
/// // Create a video source configuration
/// final videoSource = VideoSource(
///   key: 'youtube',
///   name: 'YouTube',
///   movieUrlPattern: 'https://www.youtube.com/watch?v={id}',
///   tvUrlPattern: 'https://www.youtube.com/watch?v={id}'
/// );
///
/// // Create from JSON configuration
/// final source = VideoSource.fromJson({
///   'key': 'youtube',
///   'name': 'YouTube',
///   'movieUrlPattern': 'https://www.youtube.com/watch?v={id}',
///   'tvUrlPattern': 'https://www.youtube.com/watch?v={id}'
/// });
/// ```
class VideoSource {
  /// A unique identifier for this video source.
  ///
  /// This key is used to distinguish between different video sources
  /// and is typically a short, lowercase string like 'youtube', 'vimeo', etc.
  final String key;

  /// The display name of the video source.
  ///
  /// This is the human-readable name that should be shown to users
  /// when presenting source options, such as 'YouTube', 'Vimeo', etc.
  final String name;

  /// The URL pattern template for movie streaming links.
  ///
  /// This template string contains placeholders (typically '{id}') that
  /// should be replaced with the actual movie identifier to construct
  /// a working streaming URL. The pattern determines how movie content
  /// is accessed from this source.
  final String movieUrlPattern;

  /// The URL pattern template for TV show streaming links.
  ///
  /// This template string contains placeholders (typically '{id}') that
  /// should be replaced with the actual TV show identifier to construct
  /// a working streaming URL. The pattern determines how TV show content
  /// is accessed from this source.
  final String tvUrlPattern;

  /// Creates a new VideoSource instance with the specified configuration.
  ///
  /// All parameters are required as they define the complete configuration
  /// needed to construct streaming URLs for this source. This constructor
  /// is typically used when creating VideoSource objects from configuration
  /// data that has already been validated.
  VideoSource({
    required this.key,
    required this.name,
    required this.movieUrlPattern,
    required this.tvUrlPattern,
  });

  /// Creates a VideoSource instance from a JSON configuration map.
  ///
  /// This factory method handles the deserialization of video source
  /// configuration data. The JSON should contain all required fields
  /// that define how to construct streaming URLs for this source.
  ///
  /// [json] A map containing video source configuration data.
  ///
  /// Returns a new VideoSource instance with the parsed configuration.
  ///
  /// ```dart
  /// final jsonConfig = {
  ///   'key': 'youtube',
  ///   'name': 'YouTube',
  ///   'movieUrlPattern': 'https://www.youtube.com/watch?v={id}',
  ///   'tvUrlPattern': 'https://www.youtube.com/watch?v={id}'
  /// };
  /// final videoSource = VideoSource.fromJson(jsonConfig);
  /// ```
  factory VideoSource.fromJson(Map<String, dynamic> json) {
    return VideoSource(
      key: json['key'],
      name: json['name'],
      movieUrlPattern: json['movieUrlPattern'],
      tvUrlPattern: json['tvUrlPattern'],
    );
  }
}
