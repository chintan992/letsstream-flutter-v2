import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/services/user_preferences_service.dart';

/// Provider for the UserPreferencesService singleton
final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  return UserPreferencesService.instance;
});

/// Provider for user's preferred genres
final preferredGenresProvider = FutureProvider<List<int>>((ref) async {
  final prefsService = ref.watch(userPreferencesServiceProvider);
  return prefsService.getPreferredGenres();
});

/// Provider for user's preferred platforms
final preferredPlatformsProvider = FutureProvider<List<int>>((ref) async {
  final prefsService = ref.watch(userPreferencesServiceProvider);
  return prefsService.getPreferredPlatforms();
});

/// Provider for personalization enabled status
final personalizationEnabledProvider = FutureProvider<bool>((ref) async {
  final prefsService = ref.watch(userPreferencesServiceProvider);
  return prefsService.isHubPersonalizationEnabled();
});

/// Provider for recently viewed items
final recentlyViewedProvider = FutureProvider<List<int>>((ref) async {
  final prefsService = ref.watch(userPreferencesServiceProvider);
  return prefsService.getRecentlyViewed();
});

// NOTE: Watchlist provider has been moved to watchlist_providers.dart
// Use watchlistItemsProvider from core/providers/watchlist_providers.dart instead