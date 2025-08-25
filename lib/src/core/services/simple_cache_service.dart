import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';

class SimpleCacheService {
  static const String _keyPrefix = 'cached_';
  static const Duration _defaultCacheDuration = Duration(hours: 2);
  
  final Logger _logger = Logger();
  
  static SimpleCacheService? _instance;
  static SimpleCacheService get instance => _instance ??= SimpleCacheService._();
  
  SimpleCacheService._();
  
  /// Cache movies list with TTL
  Future<void> cacheMovies({
    required String key,
    required List<Movie> movies,
    Duration ttl = _defaultCacheDuration,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cacheData = {
        'data': movies.map((m) => m.toJson()).toList(),
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'ttlMs': ttl.inMilliseconds,
      };
      
      await prefs.setString('${_keyPrefix}movies_$key', json.encode(cacheData));
      _logger.d('Cached ${movies.length} movies with key: $key');
    } catch (e) {
      _logger.e('Failed to cache movies: $e');
    }
  }
  
  /// Get cached movies if valid
  Future<List<Movie>?> getCachedMovies(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('${_keyPrefix}movies_$key');
      if (cachedJson == null) return null;
      
      final cacheData = json.decode(cachedJson) as Map<String, dynamic>;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cacheData['cachedAt']);
      final ttl = Duration(milliseconds: cacheData['ttlMs']);
      
      // Check if expired
      if (DateTime.now().isAfter(cachedAt.add(ttl))) {
        // Remove expired entry
        await prefs.remove('${_keyPrefix}movies_$key');
        _logger.d('Removed expired cache entry for key: $key');
        return null;
      }
      
      final moviesJson = cacheData['data'] as List<dynamic>;
      final movies = moviesJson
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();
      
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
    Duration ttl = _defaultCacheDuration,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final cacheData = {
        'data': tvShows.map((tv) => tv.toJson()).toList(),
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'ttlMs': ttl.inMilliseconds,
      };
      
      await prefs.setString('${_keyPrefix}tv_$key', json.encode(cacheData));
      _logger.d('Cached ${tvShows.length} TV shows with key: $key');
    } catch (e) {
      _logger.e('Failed to cache TV shows: $e');
    }
  }
  
  /// Get cached TV shows if valid - synchronous version for immediate use
  List<TvShow>? getCachedTvShowsSync(String key, SharedPreferences prefs) {
    try {
      final cachedJson = prefs.getString('${_keyPrefix}tv_$key');
      if (cachedJson == null) return null;
      
      final cacheData = json.decode(cachedJson) as Map<String, dynamic>;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cacheData['cachedAt']);
      final ttl = Duration(milliseconds: cacheData['ttlMs']);
      
      // Check if expired
      if (DateTime.now().isAfter(cachedAt.add(ttl))) {
        // Remove expired entry
        prefs.remove('${_keyPrefix}tv_$key');
        _logger.d('Removed expired cache entry for key: $key');
        return null;
      }
      
      final tvShowsJson = cacheData['data'] as List<dynamic>;
      final tvShows = tvShowsJson
          .map((json) => TvShow.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _logger.d('Retrieved ${tvShows.length} TV shows from cache with key: $key');
      return tvShows;
    } catch (e) {
      _logger.e('Failed to get cached TV shows: $e');
      return null;
    }
  }
  
  /// Get cached movies - synchronous version for immediate use
  List<Movie>? getCachedMoviesSync(String key, SharedPreferences prefs) {
    try {
      final cachedJson = prefs.getString('${_keyPrefix}movies_$key');
      if (cachedJson == null) return null;
      
      final cacheData = json.decode(cachedJson) as Map<String, dynamic>;
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cacheData['cachedAt']);
      final ttl = Duration(milliseconds: cacheData['ttlMs']);
      
      // Check if expired
      if (DateTime.now().isAfter(cachedAt.add(ttl))) {
        // Remove expired entry
        prefs.remove('${_keyPrefix}movies_$key');
        _logger.d('Removed expired cache entry for key: $key');
        return null;
      }
      
      final moviesJson = cacheData['data'] as List<dynamic>;
      final movies = moviesJson
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _logger.d('Retrieved ${movies.length} movies from cache with key: $key');
      return movies;
    } catch (e) {
      _logger.e('Failed to get cached movies: $e');
      return null;
    }
  }
  
  /// Clear all cached data
  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final cacheKeys = keys.where((key) => key.startsWith(_keyPrefix)).toList();
      
      for (final key in cacheKeys) {
        await prefs.remove(key);
      }
      
      _logger.i('Cleared ${cacheKeys.length} cache entries');
    } catch (e) {
      _logger.e('Failed to clear cache: $e');
    }
  }
  
  /// Clean expired entries
  Future<void> cleanExpiredEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final cacheKeys = keys.where((key) => key.startsWith(_keyPrefix)).toList();
      
      int removedCount = 0;
      for (final key in cacheKeys) {
        try {
          final cachedJson = prefs.getString(key);
          if (cachedJson != null) {
            final cacheData = json.decode(cachedJson) as Map<String, dynamic>;
            final cachedAt = DateTime.fromMillisecondsSinceEpoch(cacheData['cachedAt']);
            final ttl = Duration(milliseconds: cacheData['ttlMs']);
            
            if (DateTime.now().isAfter(cachedAt.add(ttl))) {
              await prefs.remove(key);
              removedCount++;
            }
          }
        } catch (e) {
          // Remove corrupted cache entries
          await prefs.remove(key);
          removedCount++;
        }
      }
      
      _logger.i('Cleaned $removedCount expired cache entries');
    } catch (e) {
      _logger.e('Failed to clean expired entries: $e');
    }
  }
  
  /// Get cache statistics
  Future<Map<String, int>> getCacheStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final movieKeys = keys.where((key) => key.startsWith('${_keyPrefix}movies_')).length;
      final tvKeys = keys.where((key) => key.startsWith('${_keyPrefix}tv_')).length;
      
      return {
        'movies_entries': movieKeys,
        'tv_shows_entries': tvKeys,
      };
    } catch (e) {
      _logger.e('Failed to get cache stats: $e');
      return {
        'movies_entries': 0,
        'tv_shows_entries': 0,
      };
    }
  }
}
