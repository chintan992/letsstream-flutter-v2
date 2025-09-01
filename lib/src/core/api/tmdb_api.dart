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

class TmdbApi {
  final Dio _dio = Dio();
  final String _baseUrl =
      dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final Logger _logger = Logger();

  static TmdbApi? _instance;
  static TmdbApi get instance {
    _instance ??= TmdbApi._();
    return _instance!;
  }

  TmdbApi._() {
    _configureDio();
  }

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

  // Helper to GET with error handling
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

  int? _parseRetryAfter(Headers? headers) {
    if (headers == null) return null;

    final retryAfter = headers.value('Retry-After');
    if (retryAfter != null) {
      return int.tryParse(retryAfter);
    }
    return null;
  }

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

  // Anime discovery (genre 16)
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

  // Search
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

  // Similar and videos
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

  // TV details with seasons
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

  // Episodes for a specific season
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

  Future<SeasonDetail> getSeasonDetails(int tvId, int seasonNumber) async {
    try {
      final response = await _get('/tv/$tvId/season/$seasonNumber');
      return SeasonDetail.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

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
}

// Dio Interceptors
class _AuthInterceptor extends Interceptor {
  final String apiKey;

  _AuthInterceptor(this.apiKey);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add API key to all requests
    options.queryParameters['api_key'] = apiKey;
    handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  final Logger _logger;

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

class _RetryInterceptor extends Interceptor {
  final Logger _logger;
  final Dio _dio;
  final Map<String, DateTime> _lastRetryTimes = {};

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

  bool _shouldRetry(DioException err) {
    // Retry on network errors, timeouts, and server errors
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }

  bool _isRecentlyRetried(String requestKey) {
    final lastRetry = _lastRetryTimes[requestKey];
    if (lastRetry == null) return false;

    // Don't retry the same request within 30 seconds
    return DateTime.now().difference(lastRetry).inSeconds < 30;
  }

  String _getRequestKey(RequestOptions options) {
    return '${options.method}:${options.path}:${options.queryParameters}';
  }

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

class _RequestDeduplicationInterceptor extends Interceptor {
  final Logger _logger;
  final Map<String, Completer<Response<dynamic>>> _pendingRequests = {};

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
