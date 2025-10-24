import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/core/services/simple_cache_service.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'dart:convert';

class SimpleCachedRepository {
  final TmdbApi _api = TmdbApi.instance;
  final SimpleCacheService _cache = SimpleCacheService.instance;
  final Logger _logger = Logger();

  // Cache TTL configurations
  static const Duration _shortCacheDuration = Duration(minutes: 30);
  static const Duration _mediumCacheDuration = Duration(hours: 2);
  static const Duration _longCacheDuration = Duration(hours: 6);

  /// Helper method to check network connectivity
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
      final prefs = await SharedPreferences.getInstance();

      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cached = _cache.getCachedMoviesSync(cacheKey, prefs);
        if (cached != null) {
          _logger.d('Retrieved ${cached.length} movies from cache: $cacheKey');
          return cached;
        }
      }

      // Check network connectivity
      final isOnline = await _isOnline;
      if (!isOnline) {
        // Return cached data even if expired when offline
        final cached = _cache.getCachedMoviesSync(cacheKey, prefs);
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
      final prefs = await SharedPreferences.getInstance();
      final cached = _cache.getCachedMoviesSync(cacheKey, prefs);
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
      final prefs = await SharedPreferences.getInstance();

      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cached = _cache.getCachedTvShowsSync(cacheKey, prefs);
        if (cached != null) {
          _logger.d(
            'Retrieved ${cached.length} TV shows from cache: $cacheKey',
          );
          return cached;
        }
      }

      // Check network connectivity
      final isOnline = await _isOnline;
      if (!isOnline) {
        // Return cached data even if expired when offline
        final cached = _cache.getCachedTvShowsSync(cacheKey, prefs);
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
      final prefs = await SharedPreferences.getInstance();
      final cached = _cache.getCachedTvShowsSync(cacheKey, prefs);
      if (cached != null) {
        _logger.w('API failed: Using cached data for $cacheKey');
        return cached;
      }

      rethrow;
    }
  }

  // MOVIES
  Future<List<Movie>> getTrendingMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'trending_movies_$page',
      apiCall: () => _api.getTrendingMovies(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getNowPlayingMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'now_playing_movies_$page',
      apiCall: () => _api.getNowPlayingMovies(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getPopularMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'popular_movies_$page',
      apiCall: () => _api.getPopularMovies(page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getTopRatedMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'top_rated_movies_$page',
      apiCall: () => _api.getTopRatedMovies(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getMoviesByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'movies_genre_${genreId}_$page',
      apiCall: () => _api.getMoviesByGenre(genreId, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getMoviesByGenres(
    List<int> genreIds, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    final genreKey = genreIds.join(',');
    return _fetchMoviesWithCache(
      cacheKey: 'movies_genres_${genreKey}_$page',
      apiCall: () => _api.getMoviesByGenres(genreIds, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<Movie>> getMovies({
    required String feed,
    int page = 1,
    bool forceRefresh = false,
  }) {
    switch (feed) {
      case 'trending':
        return getTrendingMovies(page: page, forceRefresh: forceRefresh);
      case 'now_playing':
        return getNowPlayingMovies(page: page, forceRefresh: forceRefresh);
      case 'popular':
        return getPopularMovies(page: page, forceRefresh: forceRefresh);
      case 'top_rated':
        return getTopRatedMovies(page: page, forceRefresh: forceRefresh);
      
      // Personalized feeds
      case 'recommended':
      case 'personalized':
        return getPopularMovies(page: page, forceRefresh: forceRefresh); // Fallback to popular for now
        
      // Platform-specific movie feeds
      case 'netflix_movies':
        return getMoviesByWatchProvider(8, page: page, forceRefresh: forceRefresh); // Netflix
      case 'prime_movies':
        return getMoviesByWatchProvider(9, page: page, forceRefresh: forceRefresh); // Amazon Prime
      case 'disney_movies':
        return getMoviesByWatchProvider(337, page: page, forceRefresh: forceRefresh); // Disney+
        
      default:
        return getTrendingMovies(page: page, forceRefresh: forceRefresh);
    }
  }

  Future<List<TvShow>> getTvShows({
    required String feed,
    int page = 1,
    bool forceRefresh = false,
  }) {
    switch (feed) {
      case 'trending':
        return getTrendingTvShows(page: page, forceRefresh: forceRefresh);
      case 'airing_today':
        return getAiringTodayTvShows(page: page, forceRefresh: forceRefresh);
      case 'popular':
        return getPopularTvShows(page: page, forceRefresh: forceRefresh);
      case 'top_rated':
        return getTopRatedTvShows(page: page, forceRefresh: forceRefresh);
        
      // Personalized feeds
      case 'recommended':
      case 'platform_recommended':
        return getPopularTvShows(page: page, forceRefresh: forceRefresh); // Fallback to popular for now
        
      // Platform-specific TV feeds
      case 'netflix':
        return getTvShowsByWatchProvider(8, page: page, forceRefresh: forceRefresh); // Netflix
      case 'amazon_prime':
        return getTvShowsByWatchProvider(9, page: page, forceRefresh: forceRefresh); // Amazon Prime
      case 'disney_plus':
        return getTvShowsByWatchProvider(337, page: page, forceRefresh: forceRefresh); // Disney+
      case 'hulu':
        return getTvShowsByWatchProvider(15, page: page, forceRefresh: forceRefresh); // Hulu
      case 'hbo_max':
        return getTvShowsByWatchProvider(384, page: page, forceRefresh: forceRefresh); // HBO Max
      case 'apple_tv':
        return getTvShowsByWatchProvider(2, page: page, forceRefresh: forceRefresh); // Apple TV+
        
      default:
        return getTrendingTvShows(page: page, forceRefresh: forceRefresh);
    }
  }

  // TV SHOWS
  Future<List<TvShow>> getTrendingTvShows({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'trending_tv_$page',
      apiCall: () => _api.getTrendingTvShows(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getAiringTodayTvShows({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'airing_today_tv_$page',
      apiCall: () => _api.getAiringTodayTvShows(page: page),
      cacheDuration: _shortCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getPopularTvShows({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'popular_tv_$page',
      apiCall: () => _api.getPopularTvShows(page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getTopRatedTvShows({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'top_rated_tv_$page',
      apiCall: () => _api.getTopRatedTvShows(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getTvByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'tv_genre_${genreId}_$page',
      apiCall: () => _api.getTvByGenre(genreId, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getTvByGenres(
    List<int> genreIds, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    final genreKey = genreIds.join(',');
    return _fetchTvShowsWithCache(
      cacheKey: 'tv_genres_${genreKey}_$page',
      apiCall: () => _api.getTvByGenres(genreIds, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  // ANIME
  Future<List<Movie>> getAnimeMovies({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'anime_movies_$page',
      apiCall: () => _api.getAnimeMovies(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getAnimeTvShows({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'anime_tv_$page',
      apiCall: () => _api.getAnimeTvShows(page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  // SEARCH (no caching for search results as they're user-specific and dynamic)
  Future<List<Movie>> searchMovies(
    String query, {
    int page = 1,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      _logger.i('Searching movies: "$query" (page $page)');
      final result = await _api.searchMovies(
        query,
        page: page,
        additionalParams: additionalParams,
      );
      _logger.i('Found ${result.length} movies');
      return result;
    } catch (e) {
      _logger.e('Error searching movies: $e');
      rethrow;
    }
  }

  Future<List<TvShow>> searchTvShows(
    String query, {
    int page = 1,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      _logger.i('Searching TV shows: "$query" (page $page)');
      final result = await _api.searchTvShows(
        query,
        page: page,
        additionalParams: additionalParams,
      );
      _logger.i('Found ${result.length} TV shows');
      return result;
    } catch (e) {
      _logger.e('Error searching TV shows: $e');
      rethrow;
    }
  }

  // SIMILAR (cached with shorter duration as they're content-specific)
  Future<List<Movie>> getSimilarMovies(
    int movieId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'similar_movies_${movieId}_$page',
      apiCall: () => _api.getSimilarMovies(movieId, page: page),
      cacheDuration: _longCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getSimilarTvShows(
    int tvId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
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

  // Seasons & Episodes (no caching for now)
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
  Future<Map<String, int>> getCacheStats() async {
    return await _cache.getCacheStats();
  }

  // GENRES
  Future<Map<int, String>> getMovieGenres({bool forceRefresh = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const cacheKey = 'movie_genres';

      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cached = _cache.getCachedString(cacheKey, prefs);
        if (cached != null) {
          _logger.d('Retrieved movie genres from cache');
          // Parse the cached JSON string back to Map
          final List<dynamic> list = json.decode(cached);
          return {
            for (var item in list) item['id'] as int: item['name'] as String,
          };
        }
      }

      // Check network connectivity
      final isOnline = await _isOnline;
      if (!isOnline) {
        // Return cached data even if expired when offline
        final cached = _cache.getCachedString(cacheKey, prefs);
        if (cached != null) {
          _logger.w('Offline: Using cached data for movie genres');
          final List<dynamic> list = json.decode(cached);
          return {
            for (var item in list) item['id'] as int: item['name'] as String,
          };
        } else {
          throw Exception('No network connection and no cached data available');
        }
      }

      // Fetch from API
      final result = await _api.getMovieGenres();

      // Cache the result as JSON string
      final jsonString = json.encode(
        result.entries
            .map((entry) => {'id': entry.key, 'name': entry.value})
            .toList(),
      );
      await _cache.cacheString(
        key: cacheKey,
        value: jsonString,
        ttl: _longCacheDuration,
      );

      return result;
    } catch (e) {
      _logger.e('Error in getMovieGenres: $e');

      // Try to return cached data as fallback
      final prefs = await SharedPreferences.getInstance();
      const cacheKey = 'movie_genres';
      final cached = _cache.getCachedString(cacheKey, prefs);
      if (cached != null) {
        _logger.w('API failed: Using cached data for movie genres');
        final List<dynamic> list = json.decode(cached);
        return {
          for (var item in list) item['id'] as int: item['name'] as String,
        };
      }

      rethrow;
    }
  }

  Future<Map<int, String>> getTvGenres({bool forceRefresh = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const cacheKey = 'tv_genres';

      // Check cache first (unless force refresh)
      if (!forceRefresh) {
        final cached = _cache.getCachedString(cacheKey, prefs);
        if (cached != null) {
          _logger.d('Retrieved TV genres from cache');
          // Parse the cached JSON string back to Map
          final List<dynamic> list = json.decode(cached);
          return {
            for (var item in list) item['id'] as int: item['name'] as String,
          };
        }
      }

      // Check network connectivity
      final isOnline = await _isOnline;
      if (!isOnline) {
        // Return cached data even if expired when offline
        final cached = _cache.getCachedString(cacheKey, prefs);
        if (cached != null) {
          _logger.w('Offline: Using cached data for TV genres');
          final List<dynamic> list = json.decode(cached);
          return {
            for (var item in list) item['id'] as int: item['name'] as String,
          };
        } else {
          throw Exception('No network connection and no cached data available');
        }
      }

      // Fetch from API
      final result = await _api.getTvGenres();

      // Cache the result as JSON string
      final jsonString = json.encode(
        result.entries
            .map((entry) => {'id': entry.key, 'name': entry.value})
            .toList(),
      );
      await _cache.cacheString(
        key: cacheKey,
        value: jsonString,
        ttl: _longCacheDuration,
      );

      return result;
    } catch (e) {
      _logger.e('Error in getTvGenres: $e');

      // Try to return cached data as fallback
      final prefs = await SharedPreferences.getInstance();
      const cacheKey = 'tv_genres';
      final cached = _cache.getCachedString(cacheKey, prefs);
      if (cached != null) {
        _logger.w('API failed: Using cached data for TV genres');
        final List<dynamic> list = json.decode(cached);
        return {
          for (var item in list) item['id'] as int: item['name'] as String,
        };
      }

      rethrow;
    }
  }

  // MOVIE GENRE-SPECIFIC FEEDS
  Future<List<Movie>> getTrendingMoviesByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all trending movies and filter by genre
    final allTrending = await getTrendingMovies(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allTrending
        .where((movie) => movie.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  Future<List<Movie>> getNowPlayingMoviesByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all now playing movies and filter by genre
    final allNowPlaying = await getNowPlayingMovies(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allNowPlaying
        .where((movie) => movie.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  Future<List<Movie>> getPopularMoviesByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all popular movies and filter by genre
    final allPopular = await getPopularMovies(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allPopular
        .where((movie) => movie.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  Future<List<Movie>> getTopRatedMoviesByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all top rated movies and filter by genre
    final allTopRated = await getTopRatedMovies(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allTopRated
        .where((movie) => movie.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  // TV GENRE-SPECIFIC FEEDS
  Future<List<TvShow>> getTrendingTvByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all trending TV shows and filter by genre
    final allTrending = await getTrendingTvShows(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allTrending
        .where((tv) => tv.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  Future<List<TvShow>> getAiringTodayTvByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all airing today TV shows and filter by genre
    final allAiringToday = await getAiringTodayTvShows(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allAiringToday
        .where((tv) => tv.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  Future<List<TvShow>> getPopularTvByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all popular TV shows and filter by genre
    final allPopular = await getPopularTvShows(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allPopular
        .where((tv) => tv.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  Future<List<TvShow>> getTopRatedTvByGenre(
    int genreId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // Fetch all top rated TV shows and filter by genre
    final allTopRated = await getTopRatedTvShows(
      page: page,
      forceRefresh: forceRefresh,
    );
    return allTopRated
        .where((tv) => tv.genreIds?.contains(genreId) ?? false)
        .toList();
  }

  Future<List<Movie>> getMoviesByWatchProvider(
    int providerId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchMoviesWithCache(
      cacheKey: 'movies_provider_${providerId}_$page',
      apiCall: () => _api.getMoviesByWatchProvider(providerId, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<TvShow>> getTvShowsByWatchProvider(
    int providerId, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    return _fetchTvShowsWithCache(
      cacheKey: 'tv_shows_provider_${providerId}_$page',
      apiCall: () => _api.getTvShowsByWatchProvider(providerId, page: page),
      cacheDuration: _mediumCacheDuration,
      forceRefresh: forceRefresh,
    );
  }
}
