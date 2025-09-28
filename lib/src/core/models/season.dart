/// A model class representing a summary of a TV show season.
///
/// Contains essential information about a season including its number,
/// title, overview, air date, episode count, and poster as provided
/// by The Movie Database (TMDB) API.
class SeasonSummary {
  /// The unique identifier for this season.
  final int id;

  /// The season number within the TV show.
  final int seasonNumber;

  /// The title/name of this season.
  final String name;

  /// A brief description or summary of the season.
  final String? overview;

  /// The file path to the season's poster image.
  final String? posterPath;

  /// The date when this season originally aired.
  final DateTime? airDate;

  /// The total number of episodes in this season.
  final int episodeCount;

  /// Creates a new season summary with the specified details.
  ///
  /// [id] The unique identifier for the season.
  /// [seasonNumber] The season number within the TV show.
  /// [name] The title of the season.
  /// [overview] A brief description of the season.
  /// [posterPath] The file path to the season's poster image.
  /// [airDate] When the season originally aired.
  /// [episodeCount] The total number of episodes in the season.
  SeasonSummary({
    required this.id,
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.airDate,
    required this.episodeCount,
  });

  /// Creates a [SeasonSummary] instance from a JSON map.
  ///
  /// [json] A map containing season data from the TMDB API.
  /// Handles date parsing and type conversion with null safety.
  ///
  /// Returns a new [SeasonSummary] instance with the parsed values.
  factory SeasonSummary.fromJson(Map<String, dynamic> json) {
    DateTime? ad;
    final adStr = json['air_date'] as String?;
    if (adStr != null && adStr.isNotEmpty) {
      try {
        ad = DateTime.parse(adStr);
      } catch (_) {
        ad = null;
      }
    }
    return SeasonSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      airDate: ad,
      episodeCount: (json['episode_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Converts this [SeasonSummary] instance to a JSON map.
  ///
  /// Returns a map containing all season data in a format suitable
  /// for API requests or local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'season_number': seasonNumber,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'air_date': airDate?.toIso8601String(),
      'episode_count': episodeCount,
    };
  }
}
