/// A model class representing a summary of a TV show episode.
///
/// Contains essential information about an episode including its number,
/// title, overview, air date, and ratings as provided by The Movie Database (TMDB) API.
class EpisodeSummary {
  /// The unique identifier for this episode.
  final int id;

  /// The episode number within its season.
  final int episodeNumber;

  /// The title/name of this episode.
  final String name;

  /// A brief description or summary of the episode.
  final String? overview;

  /// The file path to the episode's still image.
  final String? stillPath;

  /// The date when this episode originally aired.
  final DateTime? airDate;

  /// The average user rating for this episode (0-10 scale).
  final double voteAverage;

  /// Creates a new episode summary with the specified details.
  ///
  /// [id] The unique identifier for the episode.
  /// [episodeNumber] The episode number within its season.
  /// [name] The title of the episode.
  /// [overview] A brief description of the episode.
  /// [stillPath] The file path to the episode's still image.
  /// [airDate] When the episode originally aired.
  /// [voteAverage] The average user rating (0-10 scale).
  EpisodeSummary({
    required this.id,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.stillPath,
    required this.airDate,
    required this.voteAverage,
  });

  /// Creates an [EpisodeSummary] instance from a JSON map.
  ///
  /// [json] A map containing episode data from the TMDB API.
  /// Handles date parsing and type conversion with null safety.
  ///
  /// Returns a new [EpisodeSummary] instance with the parsed values.
  factory EpisodeSummary.fromJson(Map<String, dynamic> json) {
    DateTime? ad;
    final adStr = json['air_date'] as String?;
    if (adStr != null && adStr.isNotEmpty) {
      try {
        ad = DateTime.parse(adStr);
      } catch (_) {
        ad = null;
      }
    }
    return EpisodeSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      overview: json['overview'] as String?,
      stillPath: json['still_path'] as String?,
      airDate: ad,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts this [EpisodeSummary] instance to a JSON map.
  ///
  /// Returns a map containing all episode data in a format suitable
  /// for API requests or local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episode_number': episodeNumber,
      'name': name,
      'overview': overview,
      'still_path': stillPath,
      'air_date': airDate?.toIso8601String(),
      'vote_average': voteAverage,
    };
  }
}
