import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/connectivity_service.dart';

/// Offline service for managing cached content and offline functionality
class OfflineService {
  static const String _moviesBoxName = 'offline_movies';
  static const String _tvShowsBoxName = 'offline_tv_shows';
  static const String _lastSyncBoxName = 'last_sync_times';
  static const String _userPreferencesBoxName = 'user_preferences';

  static final OfflineService _instance = OfflineService._internal();
  factory OfflineService() => _instance;
  OfflineService._internal();

  late Box<Movie> _moviesBox;
  late Box<TvShow> _tvShowsBox;
  late Box<String> _lastSyncBox;
  late Box<String> _userPreferencesBox;

  late final ConnectivityService _connectivityService;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;

  bool _isInitialized = false;

  /// Initialize the offline service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Hive boxes
      _moviesBox = await Hive.openBox<Movie>(_moviesBoxName);
      _tvShowsBox = await Hive.openBox<TvShow>(_tvShowsBoxName);
      _lastSyncBox = await Hive.openBox<String>(_lastSyncBoxName);
      _userPreferencesBox = await Hive.openBox<String>(_userPreferencesBoxName);

      // Note: Hive adapters should be registered in main.dart or a separate adapters file
      // Hive.registerAdapter(0, MovieAdapter());
      // Hive.registerAdapter(1, TvShowAdapter());

      // Initialize connectivity service
      _connectivityService = ConnectivityService.instance;

      // Listen to connectivity changes
      _connectivitySubscription = _connectivityService.statusStream.listen(
        _onConnectivityStatusChanged,
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize offline service: $e');
      rethrow;
    }
  }

  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// Check if the device is currently online
  Future<bool> isOnline() async {
    return _connectivityService.currentStatus == ConnectivityStatus.online;
  }

  /// Cache a movie for offline viewing
  Future<void> cacheMovie(Movie movie) async {
    await _ensureInitialized();
    await _moviesBox.put(movie.id.toString(), movie);
    await _updateLastSyncTime('movies');
  }

  /// Cache a TV show for offline viewing
  Future<void> cacheTvShow(TvShow tvShow) async {
    await _ensureInitialized();
    await _tvShowsBox.put(tvShow.id.toString(), tvShow);
    await _updateLastSyncTime('tv_shows');
  }

  /// Cache multiple movies
  Future<void> cacheMovies(List<Movie> movies) async {
    await _ensureInitialized();
    final Map<String, Movie> movieMap = {
      for (final movie in movies) movie.id.toString(): movie,
    };
    await _moviesBox.putAll(movieMap);
    await _updateLastSyncTime('movies');
  }

  /// Cache multiple TV shows
  Future<void> cacheTvShows(List<TvShow> tvShows) async {
    await _ensureInitialized();
    final Map<String, TvShow> tvShowMap = {
      for (final tvShow in tvShows) tvShow.id.toString(): tvShow,
    };
    await _tvShowsBox.putAll(tvShowMap);
    await _updateLastSyncTime('tv_shows');
  }

  /// Get cached movie by ID
  Movie? getCachedMovie(int id) {
    if (!_isInitialized) return null;
    return _moviesBox.get(id.toString());
  }

  /// Get cached TV show by ID
  TvShow? getCachedTvShow(int id) {
    if (!_isInitialized) return null;
    return _tvShowsBox.get(id.toString());
  }

  /// Get all cached movies
  List<Movie> getAllCachedMovies() {
    if (!_isInitialized) return [];
    return _moviesBox.values.toList();
  }

  /// Get all cached TV shows
  List<TvShow> getAllCachedTvShows() {
    if (!_isInitialized) return [];
    return _tvShowsBox.values.toList();
  }

  /// Check if a movie is cached
  bool isMovieCached(int id) {
    if (!_isInitialized) return false;
    return _moviesBox.containsKey(id.toString());
  }

  /// Check if a TV show is cached
  bool isTvShowCached(int id) {
    if (!_isInitialized) return false;
    return _tvShowsBox.containsKey(id.toString());
  }

  /// Remove cached movie
  Future<void> removeCachedMovie(int id) async {
    await _ensureInitialized();
    await _moviesBox.delete(id.toString());
  }

  /// Remove cached TV show
  Future<void> removeCachedTvShow(int id) async {
    await _ensureInitialized();
    await _tvShowsBox.delete(id.toString());
  }

  /// Clear all cached movies
  Future<void> clearAllCachedMovies() async {
    await _ensureInitialized();
    await _moviesBox.clear();
  }

  /// Clear all cached TV shows
  Future<void> clearAllCachedTvShows() async {
    await _ensureInitialized();
    await _tvShowsBox.clear();
  }

  /// Clear all cached content
  Future<void> clearAllCache() async {
    await _ensureInitialized();
    await Future.wait([_moviesBox.clear(), _tvShowsBox.clear()]);
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    if (!_isInitialized) return {};

    return {
      'cached_movies_count': _moviesBox.length,
      'cached_tv_shows_count': _tvShowsBox.length,
      'total_cached_items': _moviesBox.length + _tvShowsBox.length,
      'movies_last_sync': _lastSyncBox.get('movies'),
      'tv_shows_last_sync': _lastSyncBox.get('tv_shows'),
      'cache_size_estimate': _estimateCacheSize(),
    };
  }

  /// Get recently cached content
  List<dynamic> getRecentlyCached({int limit = 10}) {
    if (!_isInitialized) return [];

    final movies = getAllCachedMovies();
    final tvShows = getAllCachedTvShows();

    // Combine and sort by cache time (if available) or just return mixed
    final allContent = [...movies, ...tvShows];
    allContent.shuffle(); // Simple randomization for "recent" feel

    return allContent.take(limit).toList();
  }

  /// Search cached content
  List<dynamic> searchCachedContent(String query) {
    if (!_isInitialized || query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();

    final matchingMovies = getAllCachedMovies()
        .where((movie) => movie.title.toLowerCase().contains(lowerQuery))
        .toList();

    final matchingTvShows = getAllCachedTvShows()
        .where((tvShow) => tvShow.name.toLowerCase().contains(lowerQuery))
        .toList();

    return [...matchingMovies, ...matchingTvShows];
  }

  /// Save user preference
  Future<void> saveUserPreference(String key, String value) async {
    await _ensureInitialized();
    await _userPreferencesBox.put(key, value);
  }

  /// Get user preference
  String? getUserPreference(String key) {
    if (!_isInitialized) return null;
    return _userPreferencesBox.get(key);
  }

  /// Get all user preferences
  Map<String, String> getAllUserPreferences() {
    if (!_isInitialized) return {};
    return Map.from(_userPreferencesBox.toMap());
  }

  /// Handle connectivity status changes
  void _onConnectivityStatusChanged(ConnectivityStatus status) {
    final isOnline = status == ConnectivityStatus.online;

    if (isOnline) {
      // Trigger sync when coming back online
      _syncWhenOnline();
    }
  }

  /// Sync data when coming back online
  Future<void> _syncWhenOnline() async {
    // This could trigger background sync operations
    // For now, just update the sync time
    await _updateLastSyncTime('online_sync');
  }

  /// Update last sync time
  Future<void> _updateLastSyncTime(String key) async {
    await _ensureInitialized();
    await _lastSyncBox.put(key, DateTime.now().toIso8601String());
  }

  /// Get last sync time
  DateTime? getLastSyncTime(String key) {
    if (!_isInitialized) return null;
    final timeString = _lastSyncBox.get(key);
    if (timeString == null) return null;
    return DateTime.tryParse(timeString);
  }

  /// Estimate cache size (rough calculation)
  int _estimateCacheSize() {
    // Rough estimate: each movie/TV show ~2KB of metadata
    return (_moviesBox.length + _tvShowsBox.length) * 2048;
  }

  /// Ensure service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get offline indicator widget
  Widget buildOfflineIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 16,
            color: Colors.orange.shade800,
          ),
          const SizedBox(width: 4),
          Text(
            'Offline',
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Get cached content indicator widget
  Widget buildCachedIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.offline_pin, size: 14, color: Colors.blue.shade800),
          const SizedBox(width: 2),
          Text(
            'Cached',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
