import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../models/watchlist_item.dart';

class WatchlistService {
  static const String _watchlistBoxName = 'watchlist';
  static const String _categoriesBoxName = 'watchlist_categories';

  final Logger _logger = Logger();

  late Box<String> _watchlistBox;
  late Box<String> _categoriesBox;

  static WatchlistService? _instance;
  static WatchlistService get instance => _instance ??= WatchlistService._();

  WatchlistService._();

  /// Initialize the watchlist service
  Future<void> initialize() async {
    try {
      _watchlistBox = await Hive.openBox<String>(_watchlistBoxName);
      _categoriesBox = await Hive.openBox<String>(_categoriesBoxName);

      // Initialize default categories if not exists
      if (_categoriesBox.isEmpty) {
        await _initializeDefaultCategories();
      }

      _logger.i('Watchlist service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize watchlist service: $e');
      rethrow;
    }
  }

  /// Initialize default categories
  Future<void> _initializeDefaultCategories() async {
    const defaultCategories = WatchlistCategories.defaultCategories;
    for (final category in defaultCategories) {
      await _categoriesBox.put(category, category);
    }
  }

  /// Add an item to the watchlist
  Future<void> addToWatchlist(WatchlistItem item) async {
    try {
      final jsonString = jsonEncode(item.toJson());
      await _watchlistBox.put(item.id, jsonString);
      _logger.d('Added item to watchlist: ${item.title}');
    } catch (e) {
      _logger.e('Failed to add item to watchlist: $e');
      rethrow;
    }
  }

  /// Remove an item from the watchlist
  Future<void> removeFromWatchlist(String itemId) async {
    try {
      await _watchlistBox.delete(itemId);
      _logger.d('Removed item from watchlist: $itemId');
    } catch (e) {
      _logger.e('Failed to remove item from watchlist: $e');
      rethrow;
    }
  }

  /// Update an item in the watchlist
  Future<void> updateWatchlistItem(WatchlistItem item) async {
    try {
      final updatedItem = item.copyWith(updatedAt: DateTime.now());
      final jsonString = jsonEncode(updatedItem.toJson());
      await _watchlistBox.put(item.id, jsonString);
      _logger.d('Updated watchlist item: ${item.title}');
    } catch (e) {
      _logger.e('Failed to update watchlist item: $e');
      rethrow;
    }
  }

  /// Update an item with new information
  Future<void> updateItemWith(
    String itemId, {
    List<String>? categories,
    double? userRating,
    String? notes,
    int? priority,
    bool? isWatched,
  }) async {
    try {
      final item = getWatchlistItem(itemId);
      if (item != null) {
        final updatedItem = item.copyWith(
          categories: categories ?? item.categories,
          userRating: userRating ?? item.userRating,
          notes: notes ?? item.notes,
          priority: priority ?? item.priority,
          isWatched: isWatched ?? item.isWatched,
          watchedAt: isWatched == true
              ? DateTime.now()
              : (isWatched == false ? null : item.watchedAt),
          updatedAt: DateTime.now(),
        );
        await updateWatchlistItem(updatedItem);
      }
    } catch (e) {
      _logger.e('Failed to update item with new info: $e');
      rethrow;
    }
  }

  /// Get all watchlist items
  List<WatchlistItem> getAllItems() {
    try {
      return _watchlistBox.values.map((jsonString) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return WatchlistItem.fromJson(json);
      }).toList();
    } catch (e) {
      _logger.e('Failed to get watchlist items: $e');
      return [];
    }
  }

  /// Get items by category
  List<WatchlistItem> getItemsByCategory(String category) {
    return getAllItems()
        .where((item) => item.categories.contains(category))
        .toList();
  }

  /// Get watched items
  List<WatchlistItem> getWatchedItems() {
    return getAllItems().where((item) => item.isWatched).toList();
  }

  /// Get unwatched items
  List<WatchlistItem> getUnwatchedItems() {
    return getAllItems().where((item) => !item.isWatched).toList();
  }

  /// Check if an item is in the watchlist
  bool isInWatchlist(String itemId) {
    return _watchlistBox.containsKey(itemId);
  }

  /// Get a specific watchlist item
  WatchlistItem? getWatchlistItem(String itemId) {
    try {
      final jsonString = _watchlistBox.get(itemId);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return WatchlistItem.fromJson(json);
    } catch (e) {
      _logger.e('Failed to get watchlist item: $e');
      return null;
    }
  }

  /// Get all categories
  List<String> getAllCategories() {
    return _categoriesBox.values.toList();
  }

  /// Add a custom category
  Future<void> addCategory(String category) async {
    try {
      if (!WatchlistCategories.all.contains(category)) {
        await _categoriesBox.put(category, category);
        _logger.d('Added custom category: $category');
      }
    } catch (e) {
      _logger.e('Failed to add category: $e');
      rethrow;
    }
  }

  /// Remove a custom category
  Future<void> removeCategory(String category) async {
    try {
      // Don't allow removal of default categories
      if (!WatchlistCategories.defaultCategories.contains(category)) {
        await _categoriesBox.delete(category);

        // Remove this category from all items
        final items = getAllItems();
        for (final item in items) {
          if (item.categories.contains(category)) {
            final updatedCategories = item.categories
                .where((c) => c != category)
                .toList();
            final updatedItem = item.copyWith(categories: updatedCategories);
            await updateWatchlistItem(updatedItem);
          }
        }

        _logger.d('Removed category: $category');
      }
    } catch (e) {
      _logger.e('Failed to remove category: $e');
      rethrow;
    }
  }

  /// Toggle watch status for an item
  Future<void> toggleWatchedStatus(String itemId) async {
    try {
      final item = getWatchlistItem(itemId);
      if (item != null) {
        final isCurrentlyWatched = item.isWatched;
        final updatedItem = item.copyWith(
          isWatched: !isCurrentlyWatched,
          watchedAt: !isCurrentlyWatched ? DateTime.now() : null,
          updatedAt: DateTime.now(),
        );
        await updateWatchlistItem(updatedItem);
      }
    } catch (e) {
      _logger.e('Failed to toggle watched status: $e');
      rethrow;
    }
  }

  /// Search watchlist items
  List<WatchlistItem> searchItems(String query) {
    if (query.isEmpty) return getAllItems();

    final allItems = getAllItems();
    final lowercaseQuery = query.toLowerCase();

    return allItems.where((item) {
      return item.title.toLowerCase().contains(lowercaseQuery) ||
          (item.overview?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          item.categories.any(
            (category) => category.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  /// Get watchlist statistics
  Map<String, int> getStatistics() {
    final allItems = getAllItems();
    final watchedItems = allItems.where((item) => item.isWatched).length;
    final unwatchedItems = allItems.length - watchedItems;

    return {
      'total': allItems.length,
      'watched': watchedItems,
      'unwatched': unwatchedItems,
      'categories': getAllCategories().length,
    };
  }

  /// Clear all watchlist data
  Future<void> clearAll() async {
    try {
      await _watchlistBox.clear();
      await _categoriesBox.clear();
      await _initializeDefaultCategories();
      _logger.i('Cleared all watchlist data');
    } catch (e) {
      _logger.e('Failed to clear watchlist: $e');
      rethrow;
    }
  }

  /// Dispose the service
  Future<void> dispose() async {
    try {
      await _watchlistBox.close();
      await _categoriesBox.close();
      _logger.d('Watchlist service disposed');
    } catch (e) {
      _logger.e('Failed to dispose watchlist service: $e');
    }
  }
}
