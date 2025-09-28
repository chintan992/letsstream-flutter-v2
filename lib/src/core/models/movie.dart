/// Represents a movie entity with comprehensive metadata from The Movie Database (TMDB).
///
/// This model encapsulates all essential information about a movie including
/// basic details like title and overview, media information like poster and
/// backdrop paths, ratings and popularity metrics, and associated genre IDs.
///
/// ```dart
/// // Create a movie from JSON data
/// final movie = Movie.fromJson({
///   'id': 550,
///   'title': 'Fight Club',
///   'overview': 'A ticking-time-bomb insomniac...',
///   'popularity': 123.456,
///   'poster_path': '/path/to/poster.jpg',
///   'backdrop_path': '/path/to/backdrop.jpg',
///   'release_date': '1999-10-15',
///   'vote_average': 8.4,
///   'vote_count': 15000,
///   'genre_ids': [18, 53]
/// });
///
/// // Convert back to JSON
/// final json = movie.toJson();
/// ```
class Movie {
  /// The unique identifier for the movie from TMDB.
  final int id;

  /// The title of the movie.
  final String title;

  /// A brief plot summary or synopsis of the movie.
  ///
  /// This provides a concise description of the movie's storyline,
  /// typically limited to a few sentences for quick reference.
  final String overview;

  /// The popularity score of the movie calculated by TMDB.
  ///
  /// This value represents how popular the movie is relative to other
  /// movies in the database. Higher values indicate greater popularity.
  final double popularity;

  /// The file path to the movie's poster image.
  ///
  /// This is a relative path that should be combined with TMDB's base URL
  /// to construct the full image URL. Can be null if no poster is available.
  final String? posterPath;

  /// The file path to the movie's backdrop image.
  ///
  /// This is a relative path for a larger promotional image, typically
  /// used as a background. Can be null if no backdrop is available.
  final String? backdropPath;

  /// The theatrical release date of the movie.
  ///
  /// This represents when the movie was first released in theaters.
  /// Can be null for movies without confirmed release dates.
  final DateTime? releaseDate;

  /// The average rating of the movie from user votes.
  ///
  /// This is a decimal value typically ranging from 0.0 to 10.0,
  /// representing the average of all user ratings on TMDB.
  final double voteAverage;

  /// The total number of user votes/ratings for the movie.
  ///
  /// This count helps indicate the reliability of the average rating -
  /// movies with more votes generally have more reliable ratings.
  final int voteCount;

  /// The list of genre IDs associated with this movie.
  ///
  /// Each ID corresponds to a specific genre classification in TMDB.
  /// Can be null if genre information is not available.
  final List<int>? genreIds;

  /// Creates a new Movie instance with the specified properties.
  ///
  /// All parameters are required except [genreIds] which is optional.
  /// This constructor is typically used when creating Movie objects
  /// from data that has already been validated and processed.
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    this.genreIds,
  });

  /// Creates a Movie instance from a JSON map.
  ///
  /// This factory method handles the deserialization of movie data from TMDB API
  /// responses. It includes robust error handling for missing or malformed data,
  /// providing sensible defaults when values are unavailable.
  ///
  /// The method supports both 'title' and 'name' fields for compatibility with
  /// different API endpoints that may return slightly different field names.
  ///
  /// [json] A map containing movie data from TMDB API.
  ///
  /// Returns a new Movie instance with parsed and validated data.
  ///
  /// ```dart
  /// final jsonData = {
  ///   'id': 550,
  ///   'title': 'Fight Club',
  ///   'overview': 'A ticking-time-bomb insomniac...',
  ///   'popularity': 67.8,
  ///   'poster_path': '/poster.jpg',
  ///   'release_date': '1999-10-15',
  ///   'vote_average': 8.4,
  ///   'vote_count': 15000
  /// };
  /// final movie = Movie.fromJson(jsonData);
  /// ```
  factory Movie.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? json['name'] ?? '') as String;
    final overview = (json['overview'] ?? '') as String;
    final popularity = (json['popularity'] as num?)?.toDouble() ?? 0.0;
    final voteAverage = (json['vote_average'] as num?)?.toDouble() ?? 0.0;
    final voteCount = (json['vote_count'] as int?) ?? 0;

    DateTime? parsedDate;
    final rd = json['release_date'] as String?;
    if (rd != null && rd.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(rd);
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

    return Movie(
      id: (json['id'] as num).toInt(),
      title: title,
      overview: overview,
      popularity: popularity,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: parsedDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIds,
    );
  }

  /// Converts the Movie instance to a JSON-serializable map.
  ///
  /// This method serializes all movie properties into a format suitable
  /// for API requests or local storage. DateTime values are converted
  /// to ISO 8601 strings for consistent serialization.
  ///
  /// Returns a [Map<String, dynamic>] containing all movie properties
  /// in a JSON-compatible format.
  ///
  /// ```dart
  /// final movie = Movie(
  ///   id: 550,
  ///   title: 'Fight Club',
  ///   // ... other properties
  /// );
  /// final json = movie.toJson();
  /// // Use json with API calls or storage
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate?.toIso8601String(),
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
    };
  }
}
