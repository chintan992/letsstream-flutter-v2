import 'package:lets_stream/src/core/models/episode.dart';

/// A model class representing detailed information about a TV show season.
///
/// Contains comprehensive season information including all episodes,
/// detailed descriptions, and metadata as provided by The Movie Database (TMDB) API.
class SeasonDetail {
  /// The unique identifier for this season.
  final int id;

  /// The title/name of this season.
  final String name;

  /// A detailed description or summary of the season.
  final String overview;

  /// The season number within the TV show.
  final int seasonNumber;

  /// A list of all episodes in this season.
  final List<EpisodeSummary> episodes;

  /// Creates a new season detail with the specified information.
  ///
  /// [id] The unique identifier for the season.
  /// [name] The title of the season.
  /// [overview] A detailed description of the season.
  /// [seasonNumber] The season number within the TV show.
  /// [episodes] A list of all episodes in this season.
  SeasonDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.episodes,
  });

  /// Creates a [SeasonDetail] instance from a JSON map.
  ///
  /// [json] A map containing detailed season data from the TMDB API,
  /// including nested episode information.
  ///
  /// Returns a new [SeasonDetail] instance with the parsed values
  /// and all episodes converted to [EpisodeSummary] objects.
  factory SeasonDetail.fromJson(Map<String, dynamic> json) {
    return SeasonDetail(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      seasonNumber: json['season_number'],
      episodes: (json['episodes'] as List)
          .map((e) => EpisodeSummary.fromJson(e))
          .toList(),
    );
  }
}
