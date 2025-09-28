/// A generic model class representing a paginated response from The Movie Database (TMDB) API.
///
/// This class wraps the standard TMDB API response format which includes pagination
/// information and a list of results of a specific type. It's designed to work
/// with any model type that can be serialized to/from JSON.
///
/// The type parameter [T] represents the type of objects in the results list,
/// typically a model class like [Movie], [TvShow], etc.
class TmdbResponse<T> {
  /// The current page number of the results.
  final int page;

  /// The list of results for the current page.
  final List<T> results;

  /// The total number of available pages.
  final int totalPages;

  /// The total number of results across all pages.
  final int totalResults;

  /// Creates a new TMDB response with pagination information.
  ///
  /// [page] The current page number.
  /// [results] The list of results for this page.
  /// [totalPages] Total number of available pages.
  /// [totalResults] Total number of results across all pages.
  TmdbResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  /// Creates a TmdbResponse instance from a JSON map.
  ///
  /// [json] A map containing the TMDB API response data.
  /// [fromJsonT] A function that converts a JSON map to an object of type [T].
  ///
  /// Returns a new TmdbResponse instance with parsed pagination data
  /// and results converted using the provided function.
  factory TmdbResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return TmdbResponse(
      page: json['page'] as int,
      results: (json['results'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  /// Converts this TmdbResponse instance to a JSON map.
  ///
  /// [toJsonT] A function that converts an object of type [T] to a JSON map.
  ///
  /// Returns a map containing pagination data and serialized results
  /// suitable for API requests or local storage.
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'page': page,
      'results': results.map((e) => toJsonT(e)).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}
