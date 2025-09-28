import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:logger/logger.dart';

/// Repository for handling movie-related operations
/// Provides methods to fetch movies from TMDB API with proper error handling and logging
class MovieRepository {
  final TmdbApi _api = TmdbApi.instance;
  final Logger _logger = Logger();

  /// Get trending movies
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      _logger.i('Fetching trending movies (page $page)');
      final result = await _api.getTrendingMovies(page: page);
      _logger.i('Fetched ${result.length} trending movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching trending movies: $e');
      rethrow;
    }
  }

  /// Get now playing movies
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      _logger.i('Fetching now playing movies (page $page)');
      final result = await _api.getNowPlayingMovies(page: page);
      _logger.i('Fetched ${result.length} now playing movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching now playing movies: $e');
      rethrow;
    }
  }

  /// Get popular movies
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      _logger.i('Fetching popular movies (page $page)');
      final result = await _api.getPopularMovies(page: page);
      _logger.i('Fetched ${result.length} popular movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching popular movies: $e');
      rethrow;
    }
  }

  /// Get top rated movies
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      _logger.i('Fetching top rated movies (page $page)');
      final result = await _api.getTopRatedMovies(page: page);
      _logger.i('Fetched ${result.length} top rated movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching top rated movies: $e');
      rethrow;
    }
  }

  /// Get movies by genre
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      _logger.i('Fetching movies by genre $genreId (page $page)');
      final result = await _api.getMoviesByGenre(genreId, page: page);
      _logger.i('Fetched ${result.length} movies by genre');
      return result;
    } catch (e) {
      _logger.e('Error fetching movies by genre: $e');
      rethrow;
    }
  }

  /// Get trending movies by genre (filtered on client side)
  Future<List<Movie>> getTrendingMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async {
    try {
      _logger.i('Fetching trending movies by genre $genreId (page $page)');
      final result = await _api.getTrendingMovies(page: page);
      // Filter by genre on client side since TMDB doesn't support genre filtering for trending
      return result
          .where((movie) => movie.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching trending movies by genre: $e');
      rethrow;
    }
  }

  /// Get now playing movies by genre (filtered on client side)
  Future<List<Movie>> getNowPlayingMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async {
    try {
      _logger.i('Fetching now playing movies by genre $genreId (page $page)');
      final result = await _api.getNowPlayingMovies(page: page);
      return result
          .where((movie) => movie.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching now playing movies by genre: $e');
      rethrow;
    }
  }

  /// Get popular movies by genre (filtered on client side)
  Future<List<Movie>> getPopularMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async {
    try {
      _logger.i('Fetching popular movies by genre $genreId (page $page)');
      final result = await _api.getPopularMovies(page: page);
      return result
          .where((movie) => movie.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching popular movies by genre: $e');
      rethrow;
    }
  }

  /// Get top rated movies by genre (filtered on client side)
  Future<List<Movie>> getTopRatedMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async {
    try {
      _logger.i('Fetching top rated movies by genre $genreId (page $page)');
      final result = await _api.getTopRatedMovies(page: page);
      return result
          .where((movie) => movie.genreIds?.contains(genreId) ?? false)
          .toList();
    } catch (e) {
      _logger.e('Error fetching top rated movies by genre: $e');
      rethrow;
    }
  }

  /// Get movies by multiple genres
  Future<List<Movie>> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
  }) async {
    try {
      _logger.i('Fetching movies by genres ${genreIds.join(',')} (page $page)');
      final result = await _api.getMoviesByGenres(genreIds, page: page);
      _logger.i('Fetched ${result.length} movies by genres');
      return result;
    } catch (e) {
      _logger.e('Error fetching movies by genres: $e');
      rethrow;
    }
  }

  /// Get anime movies
  Future<List<Movie>> getAnimeMovies({int page = 1}) async {
    try {
      _logger.i('Fetching anime movies (page $page)');
      final result = await _api.getAnimeMovies(page: page);
      _logger.i('Fetched ${result.length} anime movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching anime movies: $e');
      rethrow;
    }
  }

  /// Search movies
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

  /// Get similar movies
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      _logger.i('Fetching similar movies for $movieId (page $page)');
      final result = await _api.getSimilarMovies(movieId, page: page);
      _logger.i('Fetched ${result.length} similar movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching similar movies: $e');
      rethrow;
    }
  }
}
