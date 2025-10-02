import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../models/watchlist_item.dart';
import '../services/watchlist_service.dart';

/// Provider for the WatchlistService singleton
final watchlistServiceProvider = Provider<WatchlistService>((ref) {
  return WatchlistService.instance;
});

/// State class for watchlist state management.
///
/// This immutable class holds the current state of the watchlist including
/// items, categories, filters, and loading states. It provides computed
/// properties for common filtering operations like getting movies, TV shows,
/// watched items, etc.
class WatchlistState {
  const WatchlistState({
    this.items = const [],
    this.filteredItems = const [],
    this.categories = const [],
    this.selectedCategories = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  final List<WatchlistItem> items;
  final List<WatchlistItem> filteredItems;
  final List<String> categories;
  final List<String> selectedCategories;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  /// Get items by content type
  List<WatchlistItem> get movies =>
      items.where((item) => item.contentType == 'movie').toList();
  List<WatchlistItem> get tvShows =>
      items.where((item) => item.contentType == 'tv').toList();

  /// Get watched/unwatched items
  List<WatchlistItem> get watchedItems =>
      items.where((item) => item.isWatched).toList();
  List<WatchlistItem> get unwatchedItems =>
      items.where((item) => !item.isWatched).toList();

  /// Get favourite items
  List<WatchlistItem> get favouriteItems =>
      items.where((item) => item.categories.contains('Favorites')).toList();

  /// Get items by priority
  List<WatchlistItem> get highPriorityItems =>
      items.where((item) => item.priority >= 4).toList();
  List<WatchlistItem> get mediumPriorityItems =>
      items.where((item) => item.priority == 3).toList();
  List<WatchlistItem> get lowPriorityItems =>
      items.where((item) => item.priority <= 2).toList();

  /// Get recently added items (last 7 days)
  List<WatchlistItem> get recentlyAddedItems {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return items.where((item) => item.addedAt.isAfter(weekAgo)).toList();
  }

  /// Get statistics
  Map<String, int> get statistics => {
        'total': items.length,
        'movies': movies.length,
        'tvShows': tvShows.length,
        'watched': watchedItems.length,
        'unwatched': unwatchedItems.length,
        'favorites': favouriteItems.length,
        'categories': categories.length,
      };

  WatchlistState copyWith({
    List<WatchlistItem>? items,
    List<WatchlistItem>? filteredItems,
    List<String>? categories,
    List<String>? selectedCategories,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return WatchlistState(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// StateNotifier for managing watchlist state.
///
/// This notifier provides reactive state management for the watchlist feature.
/// It handles all watchlist operations including adding, removing, updating items,
/// managing categories, and applying filters. The notifier automatically updates
/// the state and triggers UI rebuilds when data changes.
class WatchlistNotifier extends StateNotifier<WatchlistState> {
  final WatchlistService _service;

  WatchlistNotifier(this._service) : super(const WatchlistState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);

    try {
      await _service.initialize();
      final items = _service.getAllItems();
      final categories = _service.getAllCategories();

      state = state.copyWith(
        items: items,
        categories: categories,
        filteredItems: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add item to watchlist.
  ///
  /// Adds a new item to the watchlist and updates the state with the new item list.
  /// The item will be visible in the UI immediately after this operation completes.
  ///
  /// [item] The watchlist item to add.
  /// Throws an exception if the operation fails.
  Future<void> addItem(WatchlistItem item) async {
    try {
      await _service.addToWatchlist(item);
      final updatedItems = _service.getAllItems();
      state = state.copyWith(
        items: updatedItems,
        filteredItems: _applyFilters(updatedItems),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Remove item from watchlist.
  ///
  /// Removes an item from the watchlist by its ID and updates the state.
  /// The item will be removed from the UI immediately after this operation completes.
  ///
  /// [itemId] The ID of the item to remove.
  /// Throws an exception if the operation fails.
  Future<void> removeItem(String itemId) async {
    try {
      await _service.removeFromWatchlist(itemId);
      final updatedItems = _service.getAllItems();
      state = state.copyWith(
        items: updatedItems,
        filteredItems: _applyFilters(updatedItems),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Update watchlist item.
  ///
  /// Updates an existing watchlist item with new data and refreshes the state.
  /// The updated item will be reflected in the UI immediately after this operation completes.
  ///
  /// [item] The updated watchlist item.
  /// Throws an exception if the operation fails.
  Future<void> updateItem(WatchlistItem item) async {
    try {
      await _service.updateWatchlistItem(item);
      final updatedItems = _service.getAllItems();
      state = state.copyWith(
        items: updatedItems,
        filteredItems: _applyFilters(updatedItems),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Update item with specific fields
  Future<void> updateItemWith(
    String itemId, {
    List<String>? categories,
    double? userRating,
    String? notes,
    int? priority,
    bool? isWatched,
  }) async {
    try {
      await _service.updateItemWith(
        itemId,
        categories: categories,
        userRating: userRating,
        notes: notes,
        priority: priority,
        isWatched: isWatched,
      );
      final updatedItems = _service.getAllItems();
      state = state.copyWith(
        items: updatedItems,
        filteredItems: _applyFilters(updatedItems),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Toggle watched status
  Future<void> toggleWatchedStatus(String itemId) async {
    try {
      await _service.toggleWatchedStatus(itemId);
      final updatedItems = _service.getAllItems();
      state = state.copyWith(
        items: updatedItems,
        filteredItems: _applyFilters(updatedItems),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Add category
  Future<void> addCategory(String category) async {
    try {
      await _service.addCategory(category);
      final updatedCategories = _service.getAllCategories();
      state = state.copyWith(categories: updatedCategories);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Remove category
  Future<void> removeCategory(String category) async {
    try {
      await _service.removeCategory(category);
      final updatedItems = _service.getAllItems();
      final updatedCategories = _service.getAllCategories();
      state = state.copyWith(
        items: updatedItems,
        categories: updatedCategories,
        filteredItems: _applyFilters(updatedItems),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Set search query and apply filters
  void setSearchQuery(String query) {
    state = state.copyWith(
      searchQuery: query,
      filteredItems: _applyFilters(state.items),
    );
  }

  /// Set selected categories for filtering
  void setSelectedCategories(List<String> categories) {
    state = state.copyWith(
      selectedCategories: categories,
      filteredItems: _applyFilters(state.items),
    );
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedCategories: [],
      filteredItems: state.items,
    );
  }

  /// Refresh watchlist data
  Future<void> refresh() async {
    await _loadInitialData();
  }

  /// Clear all watchlist data
  Future<void> clearAll() async {
    try {
      await _service.clearAll();
      state = state.copyWith(
        items: [],
        filteredItems: [],
        categories: WatchlistCategories.defaultCategories,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Apply current filters to items
  List<WatchlistItem> _applyFilters(List<WatchlistItem> items) {
    var filtered = items;

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      filtered = _service.searchItems(state.searchQuery);
    }

    // Apply category filters
    if (state.selectedCategories.isNotEmpty) {
      filtered = filtered.where((item) {
        return state.selectedCategories
            .any((category) => item.categories.contains(category));
      }).toList();
    }

    return filtered;
  }
}

/// Provider for watchlist state notifier
final watchlistNotifierProvider =
    StateNotifierProvider<WatchlistNotifier, WatchlistState>((ref) {
  final service = ref.watch(watchlistServiceProvider);
  return WatchlistNotifier(service);
});

/// Provider for all watchlist items
final watchlistItemsProvider = Provider<List<WatchlistItem>>((ref) {
  return ref.watch(watchlistNotifierProvider).items;
});

/// Provider for filtered watchlist items
final filteredWatchlistItemsProvider = Provider<List<WatchlistItem>>((ref) {
  return ref.watch(watchlistNotifierProvider).filteredItems;
});

/// Provider for watchlist categories
final watchlistCategoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(watchlistNotifierProvider).categories;
});

/// Provider for search query
final watchlistSearchQueryProvider = Provider<String>((ref) {
  return ref.watch(watchlistNotifierProvider).searchQuery;
});

/// Provider for selected categories filter
final selectedCategoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(watchlistNotifierProvider).selectedCategories;
});

/// Provider for loading state
final watchlistLoadingProvider = Provider<bool>((ref) {
  return ref.watch(watchlistNotifierProvider).isLoading;
});

/// Provider for error state
final watchlistErrorProvider = Provider<String?>((ref) {
  return ref.watch(watchlistNotifierProvider).error;
});

/// Provider for favourite items (filtered from watchlist)
final favouriteItemsProvider = Provider<List<WatchlistItem>>((ref) {
  final items = ref.watch(watchlistItemsProvider);
  return items.where((item) => item.categories.contains('Favorites')).toList();
});

/// Provider for watched items
final watchedItemsProvider = Provider<List<WatchlistItem>>((ref) {
  final items = ref.watch(watchlistItemsProvider);
  return items.where((item) => item.isWatched).toList();
});

/// Provider for unwatched items
final unwatchedItemsProvider = Provider<List<WatchlistItem>>((ref) {
  final items = ref.watch(watchlistItemsProvider);
  return items.where((item) => !item.isWatched).toList();
});

/// Provider for movies in watchlist
final watchlistMoviesProvider = Provider<List<WatchlistItem>>((ref) {
  final items = ref.watch(watchlistItemsProvider);
  return items.where((item) => item.contentType == 'movie').toList();
});

/// Provider for TV shows in watchlist
final watchlistTvShowsProvider = Provider<List<WatchlistItem>>((ref) {
  final items = ref.watch(watchlistItemsProvider);
  return items.where((item) => item.contentType == 'tv').toList();
});

/// Provider for watchlist statistics
final watchlistStatisticsProvider = Provider<Map<String, int>>((ref) {
  final state = ref.watch(watchlistNotifierProvider);
  return state.statistics;
});

/// Provider for checking if item is in watchlist
final isInWatchlistProvider = Provider.family<bool, String>((ref, itemId) {
  final items = ref.watch(watchlistItemsProvider);
  return items.any((item) => item.id == itemId);
});

/// Provider for getting specific watchlist item
final watchlistItemProvider =
    Provider.family<WatchlistItem?, String>((ref, itemId) {
  final items = ref.watch(watchlistItemsProvider);
  return items.firstWhereOrNull((item) => item.id == itemId);
});

/// Provider for items by category
final watchlistItemsByCategoryProvider =
    Provider.family<List<WatchlistItem>, String>((ref, category) {
  final items = ref.watch(watchlistItemsProvider);
  return items.where((item) => item.categories.contains(category)).toList();
});

/// Provider for recently added items (last 7 days)
final recentlyAddedItemsProvider = Provider<List<WatchlistItem>>((ref) {
  final items = ref.watch(watchlistItemsProvider);
  final weekAgo = DateTime.now().subtract(const Duration(days: 7));
  return items.where((item) => item.addedAt.isAfter(weekAgo)).toList();
});

/// Provider for high priority items
final highPriorityItemsProvider = Provider<List<WatchlistItem>>((ref) {
  final items = ref.watch(watchlistItemsProvider);
  return items.where((item) => item.priority >= 4).toList();
});
