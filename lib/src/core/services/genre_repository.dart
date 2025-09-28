import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:logger/logger.dart';

/// Repository for handling genre operations
/// Provides methods to fetch movie and TV show genres with proper error handling and logging
class GenreRepository {
  final TmdbApi _api = TmdbApi.instance;
  final Logger _logger = Logger();

  /// Get movie genres mapping
  Future<Map<int, String>> getMovieGenres() async {
    try {
      _logger.i('Fetching movie genres');
      final result = await _api.getMovieGenres();
      _logger.i('Fetched ${result.length} movie genres');
      return result;
    } catch (e) {
      _logger.e('Error fetching movie genres: $e');
      rethrow;
    }
  }

  /// Get TV show genres mapping
  Future<Map<int, String>> getTvGenres() async {
    try {
      _logger.i('Fetching TV genres');
      final result = await _api.getTvGenres();
      _logger.i('Fetched ${result.length} TV genres');
      return result;
    } catch (e) {
      _logger.e('Error fetching TV genres: $e');
      rethrow;
    }
  }
}
