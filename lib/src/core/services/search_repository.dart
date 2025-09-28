import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:logger/logger.dart';

/// Repository for handling search operations
/// Provides methods to search for movies and TV shows with proper error handling and logging
class SearchRepository {
  final TmdbApi _api = TmdbApi.instance;
  final Logger _logger = Logger();

  /// Search for movies by query string
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      _logger.i('Searching movies: "$query" (page $page)');
      final result = await _api.searchMovies(query, page: page);
      _logger.i('Found ${result.length} movies');
      return result;
    } catch (e) {
      _logger.e('Error searching movies: $e');
      rethrow;
    }
  }

  /// Search for TV shows by query string
  Future<List<TvShow>> searchTvShows(String query, {int page = 1}) async {
    try {
      _logger.i('Searching TV shows: "$query" (page $page)');
      final result = await _api.searchTvShows(query, page: page);
      _logger.i('Found ${result.length} TV shows');
      return result;
    } catch (e) {
      _logger.e('Error searching TV shows: $e');
      rethrow;
    }
  }
}
