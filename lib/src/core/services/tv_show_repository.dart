import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:logger/logger.dart';

/// Repository for handling TV show-related operations
/// Provides methods to fetch TV shows from TMDB API with proper error handling and logging
class TvShowRepository {
  final TmdbApi _api = TmdbApi.instance;
  final Logger _logger = Logger();

  /// Get trending TV shows
  Future<List<TvShow>> getTrendingTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching trending TV shows (page $page)');
      final result = await _api.getTrendingTvShows(page: page);
      _logger.i('Fetched ${result.length} trending TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching trending TV shows: $e');
      rethrow;
    }
  }

  /// Get airing today TV shows
  Future<List<TvShow>> getAiringTodayTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching airing today TV shows (page $page)');
      final result = await _api.getAiringTodayTvShows(page: page);
      _logger.i('Fetched ${result.length} airing today TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching airing today TV shows: $e');
      rethrow;
    }
  }

  /// Get popular TV shows
  Future<List<TvShow>> getPopularTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching popular TV shows (page $page)');
      final result = await _api.getPopularTvShows(page: page);
      _logger.i('Fetched ${result.length} popular TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching popular TV shows: $e');
      rethrow;
    }
  }

  /// Get top rated TV shows
  Future<List<TvShow>> getTopRatedTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching top rated TV shows (page $page)');
      final result = await _api.getTopRatedTvShows(page: page);
      _logger.i('Fetched ${result.length} top rated TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching top rated TV shows: $e');
      rethrow;
    }
  }

  /// Get TV shows by genre
  Future<List<TvShow>> getTvByGenre(int genreId, {int page = 1}) async {
    try {
      _logger.i('Fetching TV by genre $genreId (page $page)');
      final result = await _api.getTvByGenre(genreId, page: page);
      _logger.i('Fetched ${result.length} TV by genre');
      return result;
    } catch (e) {
      _logger.e('Error fetching TV by genre: $e');
      rethrow;
    }
  }

  /// Get trending TV shows by genre (filtered on client side)
  Future<List<TvShow>> getTrendingTvByGenre(int genreId, {int page = 1}) async {
    try {
      _logger.i('Fetching trending TV by genre $genreId (page $page)');
      final result = await _api.getTrendingTvShows(page: page);
      // Filter by genre on client side since TMDB doesn't support genre filtering for trending
      return result
          .where((tv) => tv.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching trending TV by genre: $e');
      rethrow;
    }
  }

  /// Get airing today TV shows by genre (filtered on client side)
  Future<List<TvShow>> getAiringTodayTvByGenre(
    int genreId, {
    int page = 1,
  }) async {
    try {
      _logger.i('Fetching airing today TV by genre $genreId (page $page)');
      final result = await _api.getAiringTodayTvShows(page: page);
      return result
          .where((tv) => tv.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching airing today TV by genre: $e');
      rethrow;
    }
  }

  /// Get popular TV shows by genre (filtered on client side)
  Future<List<TvShow>> getPopularTvByGenre(int genreId, {int page = 1}) async {
    try {
      _logger.i('Fetching popular TV by genre $genreId (page $page)');
      final result = await _api.getPopularTvShows(page: page);
      return result
          .where((tv) => tv.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching popular TV by genre: $e');
      rethrow;
    }
  }

  /// Get top rated TV shows by genre (filtered on client side)
  Future<List<TvShow>> getTopRatedTvByGenre(int genreId, {int page = 1}) async {
    try {
      _logger.i('Fetching top rated TV by genre $genreId (page $page)');
      final result = await _api.getTopRatedTvShows(page: page);
      return result
          .where((tv) => tv.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching top rated TV by genre: $e');
      rethrow;
    }
  }

  /// Get TV shows by multiple genres
  Future<List<TvShow>> getTvByGenres(List<int> genreIds, {int page = 1}) async {
    try {
      _logger.i('Fetching TV by genres ${genreIds.join(',')} (page $page)');
      final result = await _api.getTvByGenres(genreIds, page: page);
      _logger.i('Fetched ${result.length} TV by genres');
      return result;
    } catch (e) {
      _logger.e('Error fetching TV by genres: $e');
      rethrow;
    }
  }

  /// Get anime TV shows
  Future<List<TvShow>> getAnimeTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching anime TV shows (page $page)');
      final result = await _api.getAnimeTvShows(page: page);
      _logger.i('Fetched ${result.length} anime TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching anime TV shows: $e');
      rethrow;
    }
  }

  /// Search TV shows
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

  /// Get similar TV shows
  Future<List<TvShow>> getSimilarTvShows(int tvId, {int page = 1}) async {
    try {
      _logger.i('Fetching similar TV shows for $tvId (page $page)');
      final result = await _api.getSimilarTvShows(tvId, page: page);
      _logger.i('Fetched ${result.length} similar TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching similar TV shows: $e');
      rethrow;
    }
  }
}
