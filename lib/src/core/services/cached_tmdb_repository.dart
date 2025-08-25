import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/core/services/cache_service.dart';
import 'package:logger/logger.dart';
import 'dart:io';

class CachedTmdbRepository {
  final TmdbApi _api = TmdbApi.instance;
  final CacheService _cache = CacheService.instance;
  final Logger _logger = Logger();

  // Cache TTL configurations
  static const Duration _shortCacheDuration = Duration(minutes: 30);
  static const Duration _mediumCacheDuration = Duration(hours: 2);
  static const Duration _longCacheDuration = Duration(hours: 6);

  /// Helper method to check network connectivity and cache strategy
  Future<bool> get _isOnline async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Generic method to handle caching for movie lists
  Future<List<Movie>> _fetchMoviesWithCache({
    required String cacheKey,
    required Future<List<Movie>> Function() apiCall,
    Duration cacheDuration = _mediumCacheDuration,
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cached = _cache.getCachedMovies(cacheKey);
        if (cached != null) {
          _logger.d('Retrieved ${cached.length} movies from cache: $cacheKey');
          return cached;
        }
      }

      // Check network connectivity
      final isOnline = await _isOnline;
      if (!isOnline) {
        // Return cached data even if expired when offline
        final cached = _cache.getCachedMovies(cacheKey);
        if (cached != null) {
          _logger.w('Offline: Using cached data for $cacheKey');
          return cached;
        } else {
          throw Exception('No network connection and no cached data available');
        }
      }

      // Fetch from API
      final result = await apiCall();
      
      // Cache the result
      await _cache.cacheMovies(
        key: cacheKey,
        movies: result,
        ttl: cacheDuration,
      );

      return result;
    } catch (e) {
      _logger.e('Error in _fetchMoviesWithCache for $cacheKey: $e');
      
      // Try to return cached data as fallback
      final cached = _cache.getCachedMovies(cacheKey);
      if (cached != null) {
        _logger.w('API failed: Using cached data for $cacheKey');
        return cached;
      }
      
      rethrow;
    }
  }

  /// Generic method to handle caching for TV show lists
  Future<List<TvShow>> _fetchTvShowsWithCache({
    required String cacheKey,
    required Future<List<TvShow>> Function() apiCall,
    Duration cacheDuration = _mediumCacheDuration,
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cached = _cache.getCachedTvShows(cacheKey);
        if (cached != null) {
          _logger.d('Retrieved ${cached.length} TV shows from cache: $cacheKey');
          return cached;
        }
      }

      // Check network connectivity
      final isOnline = await _isOnline;
      if (!isOnline) {
        // Return cached data even if expired when offline
        final cached = _cache.getCachedTvShows(cacheKey);
        if (cached != null) {
          _logger.w('Offline: Using cached data for $cacheKey');
          return cached;
        } else {
          throw Exception('No network connection and no cached data available');
        }
      }

      // Fetch from API
      final result = await apiCall();
      
      // Cache the result
      await _cache.cacheTvShows(
        key: cacheKey,
        tvShows: result,
        ttl: cacheDuration,
      );

      return result;
    } catch (e) {
      _logger.e('Error in _fetchTvShowsWithCache for $cacheKey: $e');
      
      // Try to return cached data as fallback
      final cached = _cache.getCachedTvShows(cacheKey);
      if (cached != null) {
        _logger.w('API failed: Using cached data for $cacheKey');
        return cached;
      }
      
      rethrow;
    }
  }

  // MOVIES
  Future<List<Movie>> getTrendingMovies({int page = 1, bool forceRefresh = false}) async {
    return _fetchMoviesWithCache(
      cacheKey: 'trending_movies_$page',
      apiCall: () => _api.getTrendingMovies(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1, bool forceRefresh = false}) async {
    return _fetchMoviesWithCache(
      cacheKey: 'now_playing_movies_$page',
      apiCall: () => _api.getNowPlayingMovies(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getPopularMovies({int page = 1, bool forceRefresh = false}) async {
    return _fetchMoviesWithCache(
      cacheKey: 'popular_movies_$page',
      apiCall: () => _api.getPopularMovies(page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1, bool forceRefresh = false}) async {
    return _fetchMoviesWithCache(
      cacheKey: 'top_rated_movies_$page',
      apiCall: () => _api.getTopRatedMovies(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1, bool forceRefresh = false}) async {
    return _fetchMoviesWithCache(
      cacheKey: 'movies_genre_${genreId}_$page',
      apiCall: () => _api.getMoviesByGenre(genreId, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getMoviesByGenres(List<int> genreIds, {int page = 1, bool forceRefresh = false}) async {
    final genreKey = genreIds.join(',');
    return _fetchMoviesWithCache(
      cacheKey: 'movies_genres_${genreKey}_$page',
      apiCall: () => _api.getMoviesByGenres(genreIds, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  // TV SHOWS
  Future<List<TvShow>> getTrendingTvShows({int page = 1, bool forceRefresh = false}) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'trending_tv_$page',
      apiCall: () => _api.getTrendingTvShows(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getAiringTodayTvShows({int page = 1, bool forceRefresh = false}) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'airing_today_tv_$page',
      apiCall: () => _api.getAiringTodayTvShows(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getPopularTvShows({int page = 1, bool forceRefresh = false}) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'popular_tv_$page',
      apiCall: () => _api.getPopularTvShows(page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getTopRatedTvShows({int page = 1, bool forceRefresh = false}) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'top_rated_tv_$page',
      apiCall: () => _api.getTopRatedTvShows(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getTvByGenre(int genreId, {int page = 1, bool forceRefresh = false}) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'tv_genre_${genreId}_$page',
      apiCall: () => _api.getTvByGenre(genreId, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getTvByGenres(List<int> genreIds, {int page = 1, bool forceRefresh = false}) async {
    final genreKey = genreIds.join(',');
    return _fetchTvShowsWithCache(
      cacheKey: 'tv_genres_${genreKey}_$page',
      apiCall: () => _api.getTvByGenres(genreIds, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  // ANIME
  Future<List<Movie>> getAnimeMovies({int page = 1, bool forceRefresh = false}) async {
    return _fetchMoviesWithCache(
      cacheKey: 'anime_movies_$page',
      apiCall: () => _api.getAnimeMovies(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getAnimeTvShows({int page = 1, bool forceRefresh = false}) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'anime_tv_$page',
      apiCall: () => _api.getAnimeTvShows(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  // SEARCH (no caching for search results as they're user-specific and dynamic)
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

  // SIMILAR (cached with shorter duration as they're content-specific)
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1, bool forceRefresh = false}) async {
    return _fetchMoviesWithCache(
      cacheKey: 'similar_movies_${movieId}_$page',
      apiCall: () => _api.getSimilarMovies(movieId, page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getSimilarTvShows(int tvId, {int page = 1, bool forceRefresh = false}) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'similar_tv_${tvId}_$page',
      apiCall: () => _api.getSimilarTvShows(tvId, page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  // VIDEOS AND CAST (no caching for now as they're less frequently accessed)
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

  /// Force refresh all cached data
  Future<void> refreshAllCache() async {
    try {
      _logger.i('Refreshing all cached data...');
      await _cache.clearAllCache();
      _logger.i('Cache refreshed successfully');
    } catch (e) {
      _logger.e('Error refreshing cache: $e');
      rethrow;
    }
  }

  /// Clean expired cache entries
  Future<void> cleanExpiredCache() async {
    try {
      await _cache.cleanExpiredEntries();
    } catch (e) {
      _logger.e('Error cleaning expired cache: $e');
    }
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return _cache.getCacheStats();
  }
}
