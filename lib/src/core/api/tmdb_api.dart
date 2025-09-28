import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/tmdb_response.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/core/models/season_detail.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/core/models/api_error.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'dart:async';

/// A service class for interacting with The Movie Database (TMDB) API.
///
/// This class provides methods to fetch movies, TV shows, cast information,
/// videos, and other media content from TMDB. It handles authentication,
/// error handling, request deduplication, and retry logic internally.
///
/// The class uses the singleton pattern to ensure efficient resource usage
/// and implements various interceptors for robust API communication.
class TmdbApi {
  final Dio _dio = Dio();
  final String _baseUrl =
      dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final Logger _logger = Logger();

  static TmdbApi? _instance;

  /// Gets the singleton instance of TmdbApi.
  ///
  /// Creates a new instance if one doesn't exist, otherwise returns the existing instance.
  static TmdbApi get instance {
    _instance ??= TmdbApi._();
    return _instance!;
  }

  /// Private constructor for TmdbApi.
  ///
  /// Initializes the Dio client with appropriate interceptors and configuration.
  TmdbApi._() {
    _configureDio();
  }

  /// Configures the Dio client with base settings and interceptors.
  ///
  /// Sets up timeouts, base URL, and adds interceptors for authentication,
  /// error handling, request deduplication, retry logic, and logging.
  void _configureDio() {
    _dio.options
      ..baseUrl = _baseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 15)
      ..sendTimeout = const Duration(seconds: 10);

    _dio.interceptors.addAll([
      _AuthInterceptor(_apiKey),
      _RequestDeduplicationInterceptor(_logger),
      _ErrorInterceptor(_logger),
      _RetryInterceptor(_logger, _dio),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
        logPrint: (object) => _logger.d(object),
      ),
    ]);
  }

  /// Performs a GET request with error handling.
  ///
  /// [path] The API endpoint path.
  /// [query] Optional query parameters to include in the request.
  ///
  /// Returns a Dio Response object or throws an [ApiError] on failure.
  Future<Response<dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiError.unknown(message: 'Unexpected error: $e');
    }
  }

  /// Handles Dio exceptions and converts them to appropriate ApiError types.
  ///
  /// [error] The DioException to handle.
  ///
  /// Returns an appropriate [ApiError] based on the exception type and response.
  ApiError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError.timeout(
          message: 'Request timed out',
          details: error.message,
        );

      case DioExceptionType.connectionError:
        return ApiError.network(
          message: 'Network connection failed',
          statusCode: error.response?.statusCode,
          details: error.message,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        switch (statusCode) {
          case 401:
            return ApiError.unauthorized(
              message: 'Invalid API key',
              details: responseData?['status_message'] ?? error.message,
            );
          case 404:
            return ApiError.notFound(
              message: 'Resource not found',
              details: responseData?['status_message'] ?? error.message,
            );
          case 429:
            final retryAfter = _parseRetryAfter(error.response?.headers);
            return ApiError.rateLimit(
              message: 'Rate limit exceeded',
              retryAfter: retryAfter,
              details: responseData?['status_message'] ?? error.message,
            );
          case 500:
          case 502:
          case 503:
          case 504:
            return ApiError.server(
              message: 'Server error',
              statusCode: statusCode,
              details: responseData?['status_message'] ?? error.message,
            );
          default:
            return ApiError.server(
              message: 'API error',
              statusCode: statusCode,
              details: responseData?['status_message'] ?? error.message,
            );
        }

      case DioExceptionType.cancel:
        return ApiError.unknown(
          message: 'Request was cancelled',
          details: error.message,
        );

      case DioExceptionType.badCertificate:
        return ApiError.network(
          message: 'SSL certificate error',
          statusCode: null,
          details: error.message,
        );

      case DioExceptionType.unknown:
        // Check if it's a network connectivity issue
        if (error.error is SocketException) {
          return ApiError.offline(
            message: 'No internet connection',
            details: error.message,
          );
        }

        return ApiError.unknown(
          message: 'Unknown error occurred',
          details: error.message,
        );
    }
  }

  /// Parses the Retry-After header value to get retry delay in seconds.
  ///
  /// [headers] The response headers that may contain Retry-After.
  ///
  /// Returns the retry delay in seconds, or null if not available or invalid.
  int? _parseRetryAfter(Headers? headers) {
    if (headers == null) return null;

    final retryAfter = headers.value('Retry-After');
    if (retryAfter != null) {
      return int.tryParse(retryAfter);
    }
    return null;
  }

  /// Gets trending movies for the day.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of trending movies, or throws an [ApiError] on failure.
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _get('/trending/movie/day', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets movies currently playing in theaters.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of now playing movies, or throws an [ApiError] on failure.
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _get('/movie/now_playing', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets popular movies.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of popular movies, or throws an [ApiError] on failure.
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _get('/movie/popular', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets top rated movies.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of top rated movies, or throws an [ApiError] on failure.
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _get('/movie/top_rated', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets movies filtered by a specific genre.
  ///
  /// [genreId] The TMDB genre ID to filter by.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of movies in the specified genre, or throws an [ApiError] on failure.
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _get(
        '/discover/movie',
        query: {
          'with_genres': '$genreId',
          'page': page,
          'sort_by': 'popularity.desc',
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets movies filtered by multiple genres.
  ///
  /// [genreIds] List of TMDB genre IDs to filter by.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of movies that match all specified genres, or throws an [ApiError] on failure.
  Future<List<Movie>> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
  }) async {
    try {
      final response = await _get(
        '/discover/movie',
        query: {
          'with_genres': genreIds.join(','),
          'page': page,
          'sort_by': 'popularity.desc',
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets trending TV shows for the day.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of trending TV shows, or throws an [ApiError] on failure.
  Future<List<TvShow>> getTrendingTvShows({int page = 1}) async {
    try {
      final response = await _get('/trending/tv/day', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets TV shows airing today.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of TV shows airing today, or throws an [ApiError] on failure.
  Future<List<TvShow>> getAiringTodayTvShows({int page = 1}) async {
    try {
      final response = await _get('/tv/airing_today', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets popular TV shows.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of popular TV shows, or throws an [ApiError] on failure.
  Future<List<TvShow>> getPopularTvShows({int page = 1}) async {
    try {
      final response = await _get('/tv/popular', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets top rated TV shows.
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of top rated TV shows, or throws an [ApiError] on failure.
  Future<List<TvShow>> getTopRatedTvShows({int page = 1}) async {
    try {
      final response = await _get('/tv/top_rated', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  /// Gets TV shows filtered by a specific genre.
  ///
  /// [genreId] The TMDB genre ID to filter by.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of TV shows in the specified genre, or throws an [ApiError] on failure.
  Future<List<TvShow>> getTvByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _get(
        '/discover/tv',
        query: {
          'with_genres': '$genreId',
          'page': page,
          'sort_by': 'popularity.desc',
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets TV shows filtered by multiple genres.
  ///
  /// [genreIds] List of TMDB genre IDs to filter by.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of TV shows that match all specified genres, or throws an [ApiError] on failure.
  Future<List<TvShow>> getTvByGenres(List<int> genreIds, {int page = 1}) async {
    try {
      final response = await _get(
        '/discover/tv',
        query: {
          'with_genres': genreIds.join(','),
          'page': page,
          'sort_by': 'popularity.desc',
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets anime movies (genre ID 16).
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of anime movies, or throws an [ApiError] on failure.
  Future<List<Movie>> getAnimeMovies({int page = 1}) async {
    try {
      final response = await _get(
        '/discover/movie',
        query: {
          'with_genres': '16',
          'sort_by': 'popularity.desc',
          'page': page,
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets anime TV shows (genre ID 16).
  ///
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of anime TV shows, or throws an [ApiError] on failure.
  Future<List<TvShow>> getAnimeTvShows({int page = 1}) async {
    try {
      final response = await _get(
        '/discover/tv',
        query: {
          'with_genres': '16',
          'sort_by': 'popularity.desc',
          'page': page,
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Searches for movies by query string.
  ///
  /// [query] The search query string.
  /// [page] The page number for pagination (default: 1).
  /// [additionalParams] Additional search parameters to include.
  ///
  /// Returns a list of movies matching the search query, or throws an [ApiError] on failure.
  Future<List<Movie>> searchMovies(
    String query, {
    int page = 1,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      final queryParams = <String, dynamic>{'query': query, 'page': page};
      if (additionalParams != null) {
        queryParams.addAll(additionalParams);
      }

      final response = await _get('/search/movie', query: queryParams);
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Searches for TV shows by query string.
  ///
  /// [query] The search query string.
  /// [page] The page number for pagination (default: 1).
  /// [additionalParams] Additional search parameters to include.
  ///
  /// Returns a list of TV shows matching the search query, or throws an [ApiError] on failure.
  Future<List<TvShow>> searchTvShows(
    String query, {
    int page = 1,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      final queryParams = <String, dynamic>{'query': query, 'page': page};
      if (additionalParams != null) {
        queryParams.addAll(additionalParams);
      }

      final response = await _get('/search/tv', query: queryParams);
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets movies similar to the specified movie.
  ///
  /// [movieId] The TMDB movie ID to find similar movies for.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of similar movies, or throws an [ApiError] on failure.
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      final response = await _get(
        '/movie/$movieId/similar',
        query: {'page': page},
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets TV shows similar to the specified TV show.
  ///
  /// [tvId] The TMDB TV show ID to find similar TV shows for.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of similar TV shows, or throws an [ApiError] on failure.
  Future<List<TvShow>> getSimilarTvShows(int tvId, {int page = 1}) async {
    try {
      final response = await _get('/tv/$tvId/similar', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets videos (trailers, teasers, etc.) for a movie.
  ///
  /// [movieId] The TMDB movie ID to get videos for.
  ///
  /// Returns a list of videos for the movie, or throws an [ApiError] on failure.
  Future<List<Video>> getMovieVideos(int movieId) async {
    try {
      final response = await _get('/movie/$movieId/videos');
      final results = (response.data['results'] as List?) ?? [];
      return results
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Gets videos (trailers, teasers, etc.) for a TV show.
  ///
  /// [tvId] The TMDB TV show ID to get videos for.
  ///
  /// Returns a list of videos for the TV show, or throws an [ApiError] on failure.
  Future<List<Video>> getTvVideos(int tvId) async {
    try {
      final response = await _get('/tv/$tvId/videos');
      final results = (response.data['results'] as List?) ?? [];
      return results
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Gets cast and crew information for a movie.
  ///
  /// [movieId] The TMDB movie ID to get credits for.
  ///
  /// Returns a list of cast members for the movie, or throws an [ApiError] on failure.
  Future<List<CastMember>> getMovieCredits(int movieId) async {
    try {
      final response = await _get('/movie/$movieId/credits');
      final cast = (response.data['cast'] as List?) ?? [];
      return cast
          .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Gets cast and crew information for a TV show.
  ///
  /// [tvId] The TMDB TV show ID to get credits for.
  ///
  /// Returns a list of cast members for the TV show, or throws an [ApiError] on failure.
  Future<List<CastMember>> getTvCredits(int tvId) async {
    try {
      final response = await _get('/tv/$tvId/credits');
      final cast = (response.data['cast'] as List?) ?? [];
      return cast
          .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Gets season information for a TV show.
  ///
  /// [tvId] The TMDB TV show ID to get seasons for.
  ///
  /// Returns a list of season summaries for the TV show, or throws an [ApiError] on failure.
  Future<List<SeasonSummary>> getTvSeasons(int tvId) async {
    try {
      // append_to_response=seasons is not supported by TMDB; seasons are in TV details
      final response = await _get('/tv/$tvId');
      final seasons = (response.data['seasons'] as List?) ?? [];
      return seasons
          .map((e) => SeasonSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Gets episodes for a specific season of a TV show.
  ///
  /// [tvId] The TMDB TV show ID.
  /// [seasonNumber] The season number to get episodes for.
  ///
  /// Returns a list of episode summaries for the season, or throws an [ApiError] on failure.
  Future<List<EpisodeSummary>> getSeasonEpisodes(
    int tvId,
    int seasonNumber,
  ) async {
    try {
      final response = await _get('/tv/$tvId/season/$seasonNumber');
      final episodes = (response.data['episodes'] as List?) ?? [];
      return episodes
          .map((e) => EpisodeSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Gets detailed information for a specific season of a TV show.
  ///
  /// [tvId] The TMDB TV show ID.
  /// [seasonNumber] The season number to get details for.
  ///
  /// Returns detailed season information including episodes, or throws an [ApiError] on failure.
  Future<SeasonDetail> getSeasonDetails(int tvId, int seasonNumber) async {
    try {
      final response = await _get('/tv/$tvId/season/$seasonNumber');
      return SeasonDetail.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets all available movie genres.
  ///
  /// Returns a map of genre ID to genre name, or throws an [ApiError] on failure.
  Future<Map<int, String>> getMovieGenres() async {
    try {
      final response = await _get('/genre/movie/list');
      final genres = (response.data['genres'] as List?) ?? [];
      return {
        for (var genre in genres) genre['id'] as int: genre['name'] as String,
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Gets all available TV show genres.
  ///
  /// Returns a map of genre ID to genre name, or throws an [ApiError] on failure.
  Future<Map<int, String>> getTvGenres() async {
    try {
      final response = await _get('/genre/tv/list');
      final genres = (response.data['genres'] as List?) ?? [];
      return {
        for (var genre in genres) genre['id'] as int: genre['name'] as String,
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Gets movies available on a specific watch provider.
  ///
  /// [providerId] The TMDB watch provider ID.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of movies available on the provider, or throws an [ApiError] on failure.
  Future<List<Movie>> getMoviesByWatchProvider(
    int providerId, {
    int page = 1,
  }) async {
    try {
      final response = await _get(
        '/discover/movie',
        query: {
          'with_watch_providers': '$providerId',
          'watch_region': 'US',
          'page': page,
          'sort_by': 'popularity.desc',
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets TV shows available on a specific watch provider.
  ///
  /// [providerId] The TMDB watch provider ID.
  /// [page] The page number for pagination (default: 1).
  ///
  /// Returns a list of TV shows available on the provider, or throws an [ApiError] on failure.
  Future<List<TvShow>> getTvShowsByWatchProvider(
    int providerId, {
    int page = 1,
  }) async {
    try {
      final response = await _get(
        '/discover/tv',
        query: {
          'with_watch_providers': '$providerId',
          'watch_region': 'US',
          'page': page,
          'sort_by': 'popularity.desc',
        },
      );
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }
}

/// Dio interceptor that adds authentication to requests.
///
/// Automatically adds the TMDB API key to all outgoing requests.
class _AuthInterceptor extends Interceptor {
  final String apiKey;

  /// Creates an authentication interceptor with the provided API key.
  _AuthInterceptor(this.apiKey);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add API key to all requests
    options.queryParameters['api_key'] = apiKey;
    handler.next(options);
  }
}

/// Dio interceptor that logs errors.
///
/// Logs detailed error information including error type, message, status code,
/// and response data for debugging purposes.
class _ErrorInterceptor extends Interceptor {
  final Logger _logger;

  /// Creates an error interceptor with the provided logger.
  _ErrorInterceptor(this._logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('Dio Error: ${err.type} - ${err.message}');
    if (err.response != null) {
      _logger.e('Response status: ${err.response?.statusCode}');
      _logger.e('Response data: ${err.response?.data}');
    }
    handler.next(err);
  }
}

/// Dio interceptor that handles request retries.
///
/// Automatically retries failed requests for network errors, timeouts,
/// and server errors, with rate limiting to prevent spam.
class _RetryInterceptor extends Interceptor {
  final Logger _logger;
  final Dio _dio;
  final Map<String, DateTime> _lastRetryTimes = {};

  /// Creates a retry interceptor with the provided logger and Dio instance.
  _RetryInterceptor(this._logger, this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestKey = _getRequestKey(err.requestOptions);

    // Check if we should retry this request
    if (_shouldRetry(err) && !_isRecentlyRetried(requestKey)) {
      _logger.i('Retrying request: ${err.requestOptions.path}');

      try {
        // Wait before retrying
        await Future.delayed(const Duration(seconds: 1));

        // Mark as retried
        _lastRetryTimes[requestKey] = DateTime.now();

        // Retry the request
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (retryError) {
        _logger.e('Retry failed: $retryError');
      }
    }

    handler.next(err);
  }

  /// Determines if a request should be retried based on the error type.
  ///
  /// Retries on network errors, timeouts, and server errors (5xx status codes).
  bool _shouldRetry(DioException err) {
    // Retry on network errors, timeouts, and server errors
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }

  /// Checks if the request was recently retried to prevent spam.
  ///
  /// [requestKey] The unique key identifying the request.
  ///
  /// Returns true if the request was retried within the last 30 seconds.
  bool _isRecentlyRetried(String requestKey) {
    final lastRetry = _lastRetryTimes[requestKey];
    if (lastRetry == null) return false;

    // Don't retry the same request within 30 seconds
    return DateTime.now().difference(lastRetry).inSeconds < 30;
  }

  /// Creates a unique key for the request to track retry attempts.
  ///
  /// [options] The request options to create a key for.
  ///
  /// Returns a string key combining method, path, and query parameters.
  String _getRequestKey(RequestOptions options) {
    return '${options.method}:${options.path}:${options.queryParameters}';
  }

  /// Retries a failed request with the same options.
  ///
  /// [requestOptions] The original request options to retry.
  ///
  /// Returns the response from the retried request.
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: requestOptions.extra,
      followRedirects: requestOptions.followRedirects,
      maxRedirects: requestOptions.maxRedirects,
      persistentConnection: requestOptions.persistentConnection,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

/// Dio interceptor that deduplicates identical requests.
///
/// Prevents multiple identical requests from being made simultaneously by
/// reusing the response from the first request for subsequent identical requests.
class _RequestDeduplicationInterceptor extends Interceptor {
  final Logger _logger;
  final Map<String, Completer<Response<dynamic>>> _pendingRequests = {};

  /// Creates a request deduplication interceptor with the provided logger.
  _RequestDeduplicationInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestKey = _getRequestKey(options);

    // Check if there's already a pending request with the same key
    if (_pendingRequests.containsKey(requestKey)) {
      _logger.d('Deduplicating request: $requestKey');
      // Wait for the existing request to complete
      _pendingRequests[requestKey]!.future
          .then((response) {
            // Clone the response for the duplicate request
            final clonedResponse = Response(
              data: response.data,
              headers: response.headers,
              requestOptions: options,
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
            );
            handler.resolve(clonedResponse);
          })
          .catchError((error) {
            handler.reject(error);
          });
      return;
    }

    // Create a completer for this new request
    final completer = Completer<Response<dynamic>>();
    _pendingRequests[requestKey] = completer;

    // Proceed with the request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestKey = _getRequestKey(response.requestOptions);

    // Complete the pending request
    final completer = _pendingRequests.remove(requestKey);
    if (completer != null && !completer.isCompleted) {
      completer.complete(response);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestKey = _getRequestKey(err.requestOptions);

    // Complete the pending request with error
    final completer = _pendingRequests.remove(requestKey);
    if (completer != null && !completer.isCompleted) {
      completer.completeError(err);
    }

    handler.next(err);
  }

  /// Creates a unique key for the request to identify duplicates.
  ///
  /// [options] The request options to create a key for.
  ///
  /// Returns a string key combining method, path, and sorted query parameters.
  String _getRequestKey(RequestOptions options) {
    // Create a unique key based on method, path, and query parameters
    final queryString =
        options.queryParameters.entries
            .map((e) => '${e.key}=${e.value}')
            .toList()
          ..sort();
    return '${options.method}:${options.path}?${queryString.join('&')}';
  }
}
