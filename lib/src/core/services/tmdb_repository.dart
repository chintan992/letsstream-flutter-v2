import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:logger/logger.dart';

class TmdbRepository {
  final TmdbApi _api = TmdbApi.instance;
  final Logger _logger = Logger();

  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      _logger.i('Fetching trending movies (page $page)');
      final result = await _api.getTrendingMovies(page: page);
      _logger.i('Fetched ${result.length} trending movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching trending movies: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      _logger.i('Fetching now playing movies (page $page)');
      final result = await _api.getNowPlayingMovies(page: page);
      _logger.i('Fetched ${result.length} now playing movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching now playing movies: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      _logger.i('Fetching popular movies (page $page)');
      final result = await _api.getPopularMovies(page: page);
      _logger.i('Fetched ${result.length} popular movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching popular movies: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      _logger.i('Fetching top rated movies (page $page)');
      final result = await _api.getTopRatedMovies(page: page);
      _logger.i('Fetched ${result.length} top rated movies');
      return result;
    } catch (e) {
      _logger.e('Error fetching top rated movies: $e');
      // Handle error appropriately
      rethrow;
    }
  }

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

  Future<List<Movie>> getMoviesByGenres(List<int> genreIds, {int page = 1}) async {
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

  Future<List<TvShow>> getTrendingTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching trending TV shows (page $page)');
      final result = await _api.getTrendingTvShows(page: page);
      _logger.i('Fetched ${result.length} trending TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching trending TV shows: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<TvShow>> getAiringTodayTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching airing today TV shows (page $page)');
      final result = await _api.getAiringTodayTvShows(page: page);
      _logger.i('Fetched ${result.length} airing today TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching airing today TV shows: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<TvShow>> getPopularTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching popular TV shows (page $page)');
      final result = await _api.getPopularTvShows(page: page);
      _logger.i('Fetched ${result.length} popular TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching popular TV shows: $e');
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<TvShow>> getTopRatedTvShows({int page = 1}) async {
    try {
      _logger.i('Fetching top rated TV shows (page $page)');
      final result = await _api.getTopRatedTvShows(page: page);
      _logger.i('Fetched ${result.length} top rated TV shows');
      return result;
    } catch (e) {
      _logger.e('Error fetching top rated TV shows: $e');
      // Handle error appropriately
      rethrow;
    }
  }

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

  // Anime
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

  // Search
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

  // Similar
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

  // Videos
  Future<List<Video>> getMovieVideos(int movieId) async {
    try {
      _logger.i('Fetching movie videos for $movieId');
      final result = await _api.getMovieVideos(movieId);
      _logger.i('Fetched ${result.length} videos');
      return result;
    } catch (e) {
      _logger.e('Error fetching movie videos: $e');
      rethrow;
    }
  }

  Future<List<Video>> getTvVideos(int tvId) async {
    try {
      _logger.i('Fetching TV videos for $tvId');
      final result = await _api.getTvVideos(tvId);
      _logger.i('Fetched ${result.length} videos');
      return result;
    } catch (e) {
      _logger.e('Error fetching TV videos: $e');
      rethrow;
    }
  }

  // Credits
  Future<List<CastMember>> getMovieCast(int movieId) async {
    try {
      _logger.i('Fetching movie cast for $movieId');
      final result = await _api.getMovieCredits(movieId);
      _logger.i('Fetched ${result.length} cast');
      return result;
    } catch (e) {
      _logger.e('Error fetching movie cast: $e');
      rethrow;
    }
  }

  Future<List<CastMember>> getTvCast(int tvId) async {
    try {
      _logger.i('Fetching TV cast for $tvId');
      final result = await _api.getTvCredits(tvId);
      _logger.i('Fetched ${result.length} cast');
      return result;
    } catch (e) {
      _logger.e('Error fetching TV cast: $e');
      rethrow;
    }
  }
}
