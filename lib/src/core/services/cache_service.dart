import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../models/cache_entry.dart';

/// A service for caching movies and TV shows data locally using Hive.
///
/// This service provides functionality to cache API responses with TTL (Time To Live)
/// support, allowing the app to work offline and improve performance by reducing
/// unnecessary network requests. It manages separate caches for movies and TV shows
/// with automatic cleanup of expired entries.
///
/// The service uses Hive for local storage and provides methods for:
/// - Caching data with configurable TTL
/// - Retrieving cached data with automatic expiration checks
/// - Clearing all cached data
/// - Cleaning up expired entries
/// - Getting cache statistics
///
/// Example usage:
/// ```dart
/// final cacheService = CacheService.instance;
/// await cacheService.initialize();
///
/// // Cache movies with 2 hour TTL
/// await cacheService.cacheMovies(
///   key: 'trending_movies',
///   movies: movieList,
///   ttl: const Duration(hours: 2),
/// );
///
/// // Retrieve cached movies
/// final cachedMovies = cacheService.getCachedMovies('trending_movies');
/// ```
class CacheService {
  static const String _moviesBoxName = 'movies_cache';
  static const String _tvShowsBoxName = 'tv_shows_cache';

  final Logger _logger = Logger();

  late Box<CacheEntry> _moviesBox;
  late Box<CacheEntry> _tvShowsBox;

  static CacheService? _instance;
  static CacheService get instance => _instance ??= CacheService._();

  CacheService._();

  bool _isInitialized = false;

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize Hive and open boxes
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      // Register type adapters
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(CacheEntryAdapter());
      }

      // Open boxes
      _moviesBox = await Hive.openBox<CacheEntry>(_moviesBoxName);
      _tvShowsBox = await Hive.openBox<CacheEntry>(_tvShowsBoxName);

      _isInitialized = true;
      _logger.i('Cache service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize cache service: $e');
      rethrow;
    }
  }

  /// Cache movies list with TTL
  Future<void> cacheMovies({
    required String key,
    required List<Movie> movies,
    Duration ttl = const Duration(hours: 1),
  }) async {
    try {
      final entry = CacheEntry(
        data: movies.map((m) => m.toJson()).toList(),
        createdAt: DateTime.now(),
        ttlMs: ttl.inMilliseconds,
      );

      await _moviesBox.put(key, entry);
      _logger.d('Cached ${movies.length} movies with key: $key');
    } catch (e) {
      _logger.e('Failed to cache movies: $e');
    }
  }

  /// Get cached movies if valid
  List<Movie>? getCachedMovies(String key) {
    try {
      final entry = _moviesBox.get(key);

      if (entry == null || entry.isExpired) {
        if (entry?.isExpired == true) {
          _moviesBox.delete(key); // Clean up expired entries
          _logger.d('Removed expired cache entry for key: $key');
        }
        return null;
      }

      final movies = entry.data.map((json) => Movie.fromJson(json)).toList();

      _logger.d('Retrieved ${movies.length} movies from cache with key: $key');
      return movies;
    } catch (e) {
      _logger.e('Failed to get cached movies: $e');
      return null;
    }
  }

  /// Cache TV shows list with TTL
  Future<void> cacheTvShows({
    required String key,
    required List<TvShow> tvShows,
    Duration ttl = const Duration(hours: 1),
  }) async {
    try {
      final entry = CacheEntry(
        data: tvShows.map((tv) => tv.toJson()).toList(),
        createdAt: DateTime.now(),
        ttlMs: ttl.inMilliseconds,
      );

      await _tvShowsBox.put(key, entry);
      _logger.d('Cached ${tvShows.length} TV shows with key: $key');
    } catch (e) {
      _logger.e('Failed to cache TV shows: $e');
    }
  }

  /// Get cached TV shows if valid
  List<TvShow>? getCachedTvShows(String key) {
    try {
      final entry = _tvShowsBox.get(key);

      if (entry == null || entry.isExpired) {
        if (entry?.isExpired == true) {
          _tvShowsBox.delete(key); // Clean up expired entries
          _logger.d('Removed expired cache entry for key: $key');
        }
        return null;
      }

      final tvShows = entry.data
          .map((json) => TvShow.fromJson(json))
          .toList();

      _logger.d(
        'Retrieved ${tvShows.length} TV shows from cache with key: $key',
      );
      return tvShows;
    } catch (e) {
      _logger.e('Failed to get cached TV shows: $e');
      return null;
    }
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    if (!_isInitialized) {
      _logger.w('Cache service not initialized, cannot clear cache');
      return;
    }

    try {
      await _moviesBox.clear();
      await _tvShowsBox.clear();
      _logger.i('Cleared all cache data');
    } catch (e) {
      _logger.e('Failed to clear cache: $e');
      rethrow;
    }
  }

  /// Clear expired entries from all boxes
  Future<void> cleanExpiredEntries() async {
    try {
      // Clean movies cache
      final moviesKeysToDelete = <dynamic>[];
      for (var key in _moviesBox.keys) {
        final entry = _moviesBox.get(key);
        if (entry?.isExpired == true) {
          moviesKeysToDelete.add(key);
        }
      }
      await _moviesBox.deleteAll(moviesKeysToDelete);

      // Clean TV shows cache
      final tvKeysToDelete = <dynamic>[];
      for (var key in _tvShowsBox.keys) {
        final entry = _tvShowsBox.get(key);
        if (entry?.isExpired == true) {
          tvKeysToDelete.add(key);
        }
      }
      await _tvShowsBox.deleteAll(tvKeysToDelete);

      _logger.i(
        'Cleaned ${moviesKeysToDelete.length + tvKeysToDelete.length} expired cache entries',
      );
    } catch (e) {
      _logger.e('Failed to clean expired entries: $e');
    }
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return {
      'movies_entries': _moviesBox.length,
      'tv_shows_entries': _tvShowsBox.length,
    };
  }

  /// Close all boxes
  Future<void> dispose() async {
    try {
      await _moviesBox.close();
      await _tvShowsBox.close();
      _logger.d('Cache service disposed');
    } catch (e) {
      _logger.e('Failed to dispose cache service: $e');
    }
  }
}
