import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/core/services/movie_repository.dart';
import 'package:lets_stream/src/core/services/tv_show_repository.dart';
import 'package:lets_stream/src/core/services/search_repository.dart';
import 'package:lets_stream/src/core/services/genre_repository.dart';
import 'package:logger/logger.dart';

/// Main repository for TMDB operations
/// Delegates to specialized repositories while maintaining backward compatibility
class TmdbRepository {
  final TmdbApi _api = TmdbApi.instance;
  final Logger _logger = Logger();

  // Specialized repositories
  final MovieRepository _movieRepo = MovieRepository();
  final TvShowRepository _tvShowRepo = TvShowRepository();
  final SearchRepository _searchRepo = SearchRepository();
  final GenreRepository _genreRepo = GenreRepository();

  // Movie operations - delegate to MovieRepository
  Future<List<Movie>> getTrendingMovies({int page = 1}) async =>
      _movieRepo.getTrendingMovies(page: page);

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async =>
      _movieRepo.getNowPlayingMovies(page: page);

  Future<List<Movie>> getPopularMovies({int page = 1}) async =>
      _movieRepo.getPopularMovies(page: page);

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async =>
      _movieRepo.getTopRatedMovies(page: page);

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async =>
      _movieRepo.getMoviesByGenre(genreId, page: page);

  Future<List<Movie>> getTrendingMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async => _movieRepo.getTrendingMoviesByGenre(genreId, page: page);

  Future<List<Movie>> getNowPlayingMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async => _movieRepo.getNowPlayingMoviesByGenre(genreId, page: page);

  Future<List<Movie>> getPopularMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async => _movieRepo.getPopularMoviesByGenre(genreId, page: page);

  Future<List<Movie>> getTopRatedMoviesByGenre(
    int genreId, {
    int page = 1,
  }) async => _movieRepo.getTopRatedMoviesByGenre(genreId, page: page);

  Future<List<Movie>> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
  }) async => _movieRepo.getMoviesByGenres(genreIds, page: page);

  Future<List<Movie>> getAnimeMovies({int page = 1}) async =>
      _movieRepo.getAnimeMovies(page: page);

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async =>
      _movieRepo.searchMovies(query, page: page);

  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async =>
      _movieRepo.getSimilarMovies(movieId, page: page);

  // TV Show operations - delegate to TvShowRepository
  Future<List<TvShow>> getTrendingTvShows({int page = 1}) async =>
      _tvShowRepo.getTrendingTvShows(page: page);

  Future<List<TvShow>> getAiringTodayTvShows({int page = 1}) async =>
      _tvShowRepo.getAiringTodayTvShows(page: page);

  Future<List<TvShow>> getPopularTvShows({int page = 1}) async =>
      _tvShowRepo.getPopularTvShows(page: page);

  Future<List<TvShow>> getTopRatedTvShows({int page = 1}) async =>
      _tvShowRepo.getTopRatedTvShows(page: page);

  Future<List<TvShow>> getTvByGenre(int genreId, {int page = 1}) async =>
      _tvShowRepo.getTvByGenre(genreId, page: page);

  Future<List<TvShow>> getTrendingTvByGenre(
    int genreId, {
    int page = 1,
  }) async => _tvShowRepo.getTrendingTvByGenre(genreId, page: page);

  Future<List<TvShow>> getAiringTodayTvByGenre(
    int genreId, {
    int page = 1,
  }) async => _tvShowRepo.getAiringTodayTvByGenre(genreId, page: page);

  Future<List<TvShow>> getPopularTvByGenre(int genreId, {int page = 1}) async =>
      _tvShowRepo.getPopularTvByGenre(genreId, page: page);

  Future<List<TvShow>> getTopRatedTvByGenre(
    int genreId, {
    int page = 1,
  }) async => _tvShowRepo.getTopRatedTvByGenre(genreId, page: page);

  Future<List<TvShow>> getTvByGenres(
    List<int> genreIds, {
    int page = 1,
  }) async => _tvShowRepo.getTvByGenres(genreIds, page: page);

  Future<List<TvShow>> getAnimeTvShows({int page = 1}) async =>
      _tvShowRepo.getAnimeTvShows(page: page);

  Future<List<TvShow>> searchTvShows(String query, {int page = 1}) async =>
      _tvShowRepo.searchTvShows(query, page: page);

  Future<List<TvShow>> getSimilarTvShows(int tvId, {int page = 1}) async =>
      _tvShowRepo.getSimilarTvShows(tvId, page: page);

  // Search operations - delegate to SearchRepository
  Future<List<Movie>> searchMoviesOnly(String query, {int page = 1}) async =>
      _searchRepo.searchMovies(query, page: page);

  Future<List<TvShow>> searchTvShowsOnly(String query, {int page = 1}) async =>
      _searchRepo.searchTvShows(query, page: page);

  // Genre operations - delegate to GenreRepository
  Future<Map<int, String>> getMovieGenres() async =>
      _genreRepo.getMovieGenres();

  Future<Map<int, String>> getTvGenres() async => _genreRepo.getTvGenres();

  // Direct API operations that don't fit into specialized repositories
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

  Future<List<SeasonSummary>> getTvSeasons(int tvId) async {
    try {
      _logger.i('Fetching TV seasons for $tvId');
      final result = await _api.getTvSeasons(tvId);
      _logger.i('Fetched ${result.length} seasons');
      return result;
    } catch (e) {
      _logger.e('Error fetching TV seasons: $e');
      rethrow;
    }
  }

  Future<List<EpisodeSummary>> getSeasonEpisodes(
    int tvId,
    int seasonNumber,
  ) async {
    try {
      _logger.i('Fetching episodes for TV $tvId season $seasonNumber');
      final result = await _api.getSeasonEpisodes(tvId, seasonNumber);
      _logger.i('Fetched ${result.length} episodes');
      return result;
    } catch (e) {
      _logger.e('Error fetching season episodes: $e');
      rethrow;
    }
  }
}
