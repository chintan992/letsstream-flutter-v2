/// Represents a TV show entity with comprehensive metadata from The Movie Database (TMDB).
///
/// This model encapsulates all essential information about a television series including
/// basic details like name and overview, media information like poster and backdrop paths,
/// ratings and popularity metrics, and associated genre IDs. It's designed to work
/// seamlessly with TMDB's TV show API endpoints.
///
/// ```dart
/// // Create a TV show from JSON data
/// final tvShow = TvShow.fromJson({
///   'id': 1399,
///   'name': 'Game of Thrones',
///   'overview': 'Seven noble families fight for control...',
///   'popularity': 456.789,
///   'poster_path': '/path/to/poster.jpg',
///   'backdrop_path': '/path/to/backdrop.jpg',
///   'first_air_date': '2011-04-17',
///   'vote_average': 9.3,
///   'vote_count': 25000,
///   'genre_ids': [18, 10759, 10765]
/// });
///
/// // Convert back to JSON
/// final json = tvShow.toJson();
/// ```
class TvShow {
  /// The unique identifier for the TV show from TMDB.
  final int id;

  /// The name/title of the TV show.
  final String name;

  /// A brief plot summary or synopsis of the TV show.
  ///
  /// This provides a concise description of the show's premise and storyline,
  /// typically limited to a few sentences for quick reference.
  final String overview;

  /// The popularity score of the TV show calculated by TMDB.
  ///
  /// This value represents how popular the show is relative to other
  /// TV shows in the database. Higher values indicate greater popularity.
  final double popularity;

  /// The file path to the TV show's poster image.
  ///
  /// This is a relative path that should be combined with TMDB's base URL
  /// to construct the full image URL. Can be null if no poster is available.
  final String? posterPath;

  /// The file path to the TV show's backdrop image.
  ///
  /// This is a relative path for a larger promotional image, typically
  /// used as a background. Can be null if no backdrop is available.
  final String? backdropPath;

  /// The original air date of the first episode of the TV show.
  ///
  /// This represents when the TV show first premiered. Can be null for
  /// shows without confirmed premiere dates.
  final DateTime? firstAirDate;

  /// The average rating of the TV show from user votes.
  ///
  /// This is a decimal value typically ranging from 0.0 to 10.0,
  /// representing the average of all user ratings on TMDB.
  final double voteAverage;

  /// The total number of user votes/ratings for the TV show.
  ///
  /// This count helps indicate the reliability of the average rating -
  /// shows with more votes generally have more reliable ratings.
  final int voteCount;

  /// The list of genre IDs associated with this TV show.
  ///
  /// Each ID corresponds to a specific genre classification in TMDB.
  /// Can be null if genre information is not available.
  final List<int>? genreIds;

  /// Creates a new TvShow instance with the specified properties.
  ///
  /// All parameters are required except [genreIds] which is optional.
  /// This constructor is typically used when creating TvShow objects
  /// from data that has already been validated and processed.
  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    this.genreIds,
  });

  /// Creates a TvShow instance from a JSON map.
  ///
  /// This factory method handles the deserialization of TV show data from TMDB API
  /// responses. It includes robust error handling for missing or malformed data,
  /// providing sensible defaults when values are unavailable.
  ///
  /// The method supports both 'name' and 'title' fields for compatibility with
  /// different API endpoints that may return slightly different field names.
  ///
  /// [json] A map containing TV show data from TMDB API.
  ///
  /// Returns a new TvShow instance with parsed and validated data.
  ///
  /// ```dart
  /// final jsonData = {
  ///   'id': 1399,
  ///   'name': 'Game of Thrones',
  ///   'overview': 'Seven noble families fight for control...',
  ///   'popularity': 234.5,
  ///   'poster_path': '/poster.jpg',
  ///   'first_air_date': '2011-04-17',
  ///   'vote_average': 9.3,
  ///   'vote_count': 25000
  /// };
  /// final tvShow = TvShow.fromJson(jsonData);
  /// ```
  factory TvShow.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? json['title'] ?? '') as String;
    final overview = (json['overview'] ?? '') as String;
    final popularity = (json['popularity'] as num?)?.toDouble() ?? 0.0;
    final voteAverage = (json['vote_average'] as num?)?.toDouble() ?? 0.0;
    final voteCount = (json['vote_count'] as int?) ?? 0;

    DateTime? parsedDate;
    final fd = json['first_air_date'] as String?;
    if (fd != null && fd.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(fd);
      } catch (_) {
        parsedDate = null;
      }
    }

    List<int>? genreIds;
    if (json['genre_ids'] is List) {
      genreIds = (json['genre_ids'] as List)
          .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
          .where((e) => e != 0)
          .toList();
    }

    return TvShow(
      id: (json['id'] as num).toInt(),
      name: name,
      overview: overview,
      popularity: popularity,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: parsedDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIds,
    );
  }

  /// Converts the TvShow instance to a JSON-serializable map.
  ///
  /// This method serializes all TV show properties into a format suitable
  /// for API requests or local storage. DateTime values are converted
  /// to ISO 8601 strings for consistent serialization.
  ///
  /// Returns a Map&lt;String, dynamic&gt; containing all TV show properties
  /// in a JSON-compatible format.
  ///
  /// ```dart
  /// final tvShow = TvShow(
  ///   id: 1399,
  ///   name: 'Game of Thrones',
  ///   // ... other properties
  /// );
  /// final json = tvShow.toJson();
  /// // Use json with API calls or storage
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'first_air_date': firstAirDate?.toIso8601String(),
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
    };
  }
}
