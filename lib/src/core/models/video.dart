/// A model class representing a video associated with a movie or TV show.
///
/// Contains information about video content such as trailers, teasers,
/// behind-the-scenes footage, and other promotional materials from
/// various video hosting platforms like YouTube and Vimeo.
class Video {
  /// The unique identifier for this video from TMDB.
  final String id;

  /// The video key or identifier from the hosting platform.
  ///
  /// For YouTube videos, this is the video ID used in the URL.
  final String key;

  /// The display name or title of the video.
  final String name;

  /// The hosting site for the video (e.g., 'YouTube', 'Vimeo').
  final String site;

  /// The type of video content (e.g., 'Trailer', 'Teaser', 'Clip').
  final String type;

  /// Creates a new Video instance with the specified properties.
  ///
  /// [id] The unique identifier for the video from TMDB.
  /// [key] The video key from the hosting platform.
  /// [name] The display name of the video.
  /// [site] The hosting site (e.g., 'YouTube').
  /// [type] The type of video content.
  const Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  /// Creates a Video instance from a JSON map.
  ///
  /// [json] A map containing video data from the TMDB API.
  /// Handles null values by providing empty string defaults.
  ///
  /// Returns a new Video instance with the parsed values.
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: (json['id'] ?? '') as String,
      key: (json['key'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      site: (json['site'] ?? '') as String,
      type: (json['type'] ?? '') as String,
    );
  }
}
