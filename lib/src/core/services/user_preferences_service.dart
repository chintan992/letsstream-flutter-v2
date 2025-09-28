import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

/// Service for managing user preferences and personalization settings
class UserPreferencesService {
  static UserPreferencesService? _instance;
  static UserPreferencesService get instance {
    _instance ??= UserPreferencesService._();
    return _instance!;
  }

  UserPreferencesService._();

  final Logger _logger = Logger();

  // Preference keys
  static const String _preferredGenresKey = 'preferred_genres';
  static const String _preferredPlatformsKey = 'preferred_platforms';
  static const String _hubPersonalizationEnabledKey = 'hub_personalization_enabled';
  static const String _recentlyViewedKey = 'recently_viewed';
  static const String _watchlistKey = 'watchlist';

  /// Gets user's preferred movie genres
  Future<List<int>> getPreferredGenres() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final genreStrings = prefs.getStringList(_preferredGenresKey) ?? [];
      return genreStrings.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
    } catch (e) {
      _logger.e('Error getting preferred genres: $e');
      return [];
    }
  }

  /// Sets user's preferred movie genres
  Future<void> setPreferredGenres(List<int> genreIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final genreStrings = genreIds.map((e) => e.toString()).toList();
      await prefs.setStringList(_preferredGenresKey, genreStrings);
      _logger.d('Updated preferred genres: $genreIds');
    } catch (e) {
      _logger.e('Error setting preferred genres: $e');
    }
  }

  /// Gets user's preferred streaming platforms
  Future<List<int>> getPreferredPlatforms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final platformStrings = prefs.getStringList(_preferredPlatformsKey) ?? [];
      return platformStrings.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
    } catch (e) {
      _logger.e('Error getting preferred platforms: $e');
      return [];
    }
  }

  /// Sets user's preferred streaming platforms
  Future<void> setPreferredPlatforms(List<int> platformIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final platformStrings = platformIds.map((e) => e.toString()).toList();
      await prefs.setStringList(_preferredPlatformsKey, platformStrings);
      _logger.d('Updated preferred platforms: $platformIds');
    } catch (e) {
      _logger.e('Error setting preferred platforms: $e');
    }
  }

  /// Checks if hub personalization is enabled
  Future<bool> isHubPersonalizationEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hubPersonalizationEnabledKey) ?? true;
    } catch (e) {
      _logger.e('Error checking personalization setting: $e');
      return true;
    }
  }

  /// Enables or disables hub personalization
  Future<void> setHubPersonalizationEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hubPersonalizationEnabledKey, enabled);
      _logger.d('Updated personalization setting: $enabled');
    } catch (e) {
      _logger.e('Error setting personalization: $e');
    }
  }

  /// Gets recently viewed items (movie/TV IDs)
  Future<List<int>> getRecentlyViewed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentStrings = prefs.getStringList(_recentlyViewedKey) ?? [];
      return recentStrings.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
    } catch (e) {
      _logger.e('Error getting recently viewed: $e');
      return [];
    }
  }

  /// Adds an item to recently viewed list
  Future<void> addToRecentlyViewed(int itemId) async {
    try {
      final recent = await getRecentlyViewed();
      recent.removeWhere((id) => id == itemId); // Remove if already exists
      recent.insert(0, itemId); // Add to beginning
      
      // Keep only last 20 items
      final limited = recent.take(20).toList();
      
      final prefs = await SharedPreferences.getInstance();
      final recentStrings = limited.map((e) => e.toString()).toList();
      await prefs.setStringList(_recentlyViewedKey, recentStrings);
      _logger.d('Added to recently viewed: $itemId');
    } catch (e) {
      _logger.e('Error adding to recently viewed: $e');
    }
  }

  /// Gets user's watchlist items
  Future<List<int>> getWatchlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final watchlistStrings = prefs.getStringList(_watchlistKey) ?? [];
      return watchlistStrings.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
    } catch (e) {
      _logger.e('Error getting watchlist: $e');
      return [];
    }
  }

  /// Adds an item to watchlist
  Future<void> addToWatchlist(int itemId) async {
    try {
      final watchlist = await getWatchlist();
      if (!watchlist.contains(itemId)) {
        watchlist.add(itemId);
        final prefs = await SharedPreferences.getInstance();
        final watchlistStrings = watchlist.map((e) => e.toString()).toList();
        await prefs.setStringList(_watchlistKey, watchlistStrings);
        _logger.d('Added to watchlist: $itemId');
      }
    } catch (e) {
      _logger.e('Error adding to watchlist: $e');
    }
  }

  /// Removes an item from watchlist
  Future<void> removeFromWatchlist(int itemId) async {
    try {
      final watchlist = await getWatchlist();
      watchlist.removeWhere((id) => id == itemId);
      final prefs = await SharedPreferences.getInstance();
      final watchlistStrings = watchlist.map((e) => e.toString()).toList();
      await prefs.setStringList(_watchlistKey, watchlistStrings);
      _logger.d('Removed from watchlist: $itemId');
    } catch (e) {
      _logger.e('Error removing from watchlist: $e');
    }
  }

  /// Clears all user preferences
  Future<void> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_preferredGenresKey);
      await prefs.remove(_preferredPlatformsKey);
      await prefs.remove(_hubPersonalizationEnabledKey);
      await prefs.remove(_recentlyViewedKey);
      await prefs.remove(_watchlistKey);
      _logger.d('Cleared all user preferences');
    } catch (e) {
      _logger.e('Error clearing preferences: $e');
    }
  }
}