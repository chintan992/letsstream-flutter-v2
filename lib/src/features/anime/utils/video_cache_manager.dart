import 'dart:io';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages video caching for improved performance and offline playback.
class VideoCacheManager {
  static const String _cacheSizeKey = 'video_cache_size';
  static const String _maxCacheSizeKey = 'max_cache_size_mb';
  static const int _defaultMaxCacheSizeMB = 500; // 500MB default
  
  static VideoCacheManager? _instance;
  static VideoCacheManager get instance => _instance ??= VideoCacheManager._();
  
  final Logger _logger = Logger();
  
  VideoCacheManager._();
  
  Directory? _cacheDirectory;
  int _currentCacheSize = 0;
  int _maxCacheSize = _defaultMaxCacheSizeMB * 1024 * 1024; // Convert to bytes
  
  /// Initializes the cache manager.
  Future<void> initialize() async {
    _cacheDirectory = await getApplicationCacheDirectory();
    await _loadCacheSettings();
    await _calculateCurrentCacheSize();
  }
  
  /// Loads cache settings from SharedPreferences.
  Future<void> _loadCacheSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCacheSize = prefs.getInt(_cacheSizeKey) ?? 0;
    _maxCacheSize = (prefs.getInt(_maxCacheSizeKey) ?? _defaultMaxCacheSizeMB) * 1024 * 1024;
  }
  
  /// Saves cache settings to SharedPreferences.
  Future<void> _saveCacheSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cacheSizeKey, _currentCacheSize);
    await prefs.setInt(_maxCacheSizeKey, _maxCacheSize ~/ (1024 * 1024));
  }
  
  /// Calculates the current cache size.
  Future<void> _calculateCurrentCacheSize() async {
    if (_cacheDirectory == null) return;
    
    int totalSize = 0;
    await for (final entity in _cacheDirectory!.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    _currentCacheSize = totalSize;
  }
  
  /// Gets the cache directory for video files.
  Future<Directory> getCacheDirectory() async {
    if (_cacheDirectory == null) {
      await initialize();
    }
    return _cacheDirectory!;
  }
  
  /// Gets the cache file path for a given URL.
  Future<String> getCacheFilePath(String url) async {
    final cacheDir = await getCacheDirectory();
    final fileName = _generateFileName(url);
    return '${cacheDir.path}/$fileName';
  }
  
  /// Generates a unique file name for a URL.
  String _generateFileName(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    final fileName = pathSegments.isNotEmpty 
        ? pathSegments.last 
        : 'video_${url.hashCode}';
    
    // Ensure file has .m3u8 or .ts extension
    if (!fileName.contains('.')) {
      return '${fileName}_${url.hashCode}.m3u8';
    }
    
    return fileName;
  }
  
  /// Checks if a URL is cached.
  Future<bool> isCached(String url) async {
    final filePath = await getCacheFilePath(url);
    return File(filePath).existsSync();
  }
  
  /// Gets the cached file for a URL.
  Future<File?> getCachedFile(String url) async {
    final filePath = await getCacheFilePath(url);
    final file = File(filePath);
    return file.existsSync() ? file : null;
  }
  
  /// Caches a video file.
  Future<void> cacheFile(String url, List<int> data) async {
    if (_currentCacheSize + data.length > _maxCacheSize) {
      await _cleanupOldFiles();
    }
    
    final filePath = await getCacheFilePath(url);
    final file = File(filePath);
    await file.writeAsBytes(data);
    
    _currentCacheSize += data.length;
    await _saveCacheSettings();
  }
  
  /// Cleans up old cache files to make space.
  Future<void> _cleanupOldFiles() async {
    if (_cacheDirectory == null) return;
    
    final files = <File>[];
    await for (final entity in _cacheDirectory!.list(recursive: true)) {
      if (entity is File) {
        files.add(entity);
      }
    }
    
    // Sort by modification time (oldest first)
    files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
    
    // Remove oldest files until we have enough space
    int spaceNeeded = _currentCacheSize - _maxCacheSize;
    for (final file in files) {
      if (spaceNeeded <= 0) break;
      
      final fileSize = await file.length();
      await file.delete();
      _currentCacheSize -= fileSize;
      spaceNeeded -= fileSize;
    }
  }
  
  /// Clears all cached files.
  Future<void> clearCache() async {
    if (_cacheDirectory == null) return;
    
    await for (final entity in _cacheDirectory!.list(recursive: true)) {
      if (entity is File) {
        await entity.delete();
      }
    }
    
    _currentCacheSize = 0;
    await _saveCacheSettings();
  }
  
  /// Gets the current cache size in MB.
  double get cacheSizeMB => _currentCacheSize / (1024 * 1024);
  
  /// Gets the maximum cache size in MB.
  double get maxCacheSizeMB => _maxCacheSize / (1024 * 1024);
  
  /// Sets the maximum cache size in MB.
  Future<void> setMaxCacheSizeMB(int sizeMB) async {
    _maxCacheSize = sizeMB * 1024 * 1024;
    await _saveCacheSettings();
    
    if (_currentCacheSize > _maxCacheSize) {
      await _cleanupOldFiles();
    }
  }
  
  /// Gets cache statistics.
  Map<String, dynamic> getCacheStats() {
    return {
      'currentSizeMB': cacheSizeMB,
      'maxSizeMB': maxCacheSizeMB,
      'usagePercentage': (cacheSizeMB / maxCacheSizeMB) * 100,
      'isNearLimit': cacheSizeMB / maxCacheSizeMB > 0.8,
    };
  }
  
  /// Preloads the next episode for seamless playback.
  Future<void> preloadNextEpisode(String nextEpisodeUrl) async {
    if (await isCached(nextEpisodeUrl)) return;
    
    try {
      // This would typically involve downloading and caching the manifest
      // and initial video segments
      _logger.d('Preloading next episode: $nextEpisodeUrl');
      // Implementation would depend on the specific streaming protocol
    } catch (e) {
      _logger.e('Failed to preload next episode: $e');
    }
  }
  
  /// Checks if the cache is near its limit.
  bool get isNearLimit => cacheSizeMB / maxCacheSizeMB > 0.8;
  
  /// Gets the cache usage percentage.
  double get usagePercentage => (cacheSizeMB / maxCacheSizeMB) * 100;
}
