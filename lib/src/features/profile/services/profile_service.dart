import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/services/cache_service.dart';
import 'package:lets_stream/src/core/services/watchlist_service.dart';
import 'package:lets_stream/src/core/services/simkl/simkl_api_client.dart';
import 'package:lets_stream/src/core/models/watchlist_item.dart';
import 'package:lets_stream/src/core/models/simkl/simkl_media_models.dart'
    as simkl_models;
import 'package:lets_stream/src/features/simkl_auth/services/simkl_auth_service.dart';
import 'package:lets_stream/src/shared/theme/theme_providers.dart';
import 'package:lets_stream/src/shared/theme/theme_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class ProfileService {
  final SimklAuthService _authService;
  final SimklApiClient _apiClient;
  final Logger _logger = Logger();

  ProfileService(this._authService, this._apiClient);

  Future<void> handleLogout(BuildContext context) async {
    try {
      await _authService.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed out from Simkl'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> handleSync(BuildContext context) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Syncing with Simkl...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Check authentication first
      final isAuthenticated = await _authService.isAuthenticated();
      if (!isAuthenticated) {
        throw Exception('User not authenticated. Please sign in first.');
      }

      // Get access token
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available. Please sign in again.');
      }

      _logger.i('Starting sync with Simkl...');

      // Get all items from Simkl
      final remoteItems = await _apiClient.getAllItems(
        accessToken: accessToken,
        extended: 'full',
      );

      _logger.d('Retrieved ${remoteItems.length} item types from Simkl');

      // Get local watchlist items
      final localItems = WatchlistService.instance.getAllItems();
      _logger.d('Found ${localItems.length} local watchlist items');

      // Sync movies
      if (remoteItems.containsKey('movies')) {
        await _syncMovies(remoteItems['movies']!, localItems, accessToken);
      }

      // Sync shows
      if (remoteItems.containsKey('shows')) {
        await _syncShows(remoteItems['shows']!, localItems, accessToken);
      }

      // Sync anime
      if (remoteItems.containsKey('anime')) {
        await _syncAnime(remoteItems['anime']!, localItems, accessToken);
      }

      _logger.i('Sync completed successfully');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync completed successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.e('Sync failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> clearCache(BuildContext context) async {
    try {
      await CacheService.instance.clearAllCache();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear cache: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> openSimklSettings(BuildContext context) async {
    const simklUrl = 'https://simkl.com/settings/';
    try {
      final uri = Uri.parse(simklUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Simkl settings'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening Simkl settings: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> authenticateWithOAuth(BuildContext context) async {
    try {
      await _authService.authenticateWithOAuth();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication successful!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> authenticateWithPin(BuildContext context) async {
    try {
      await _authService.authenticateWithPin();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device authentication initiated'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> setTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemeType themeType,
    ThemeNotifier themeNotifier,
  ) async {
    await themeNotifier.setTheme(themeType);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Sync movies between local and remote
  Future<void> _syncMovies(
    List<SimklWatchlistItem> remoteMovies,
    List<WatchlistItem> localItems,
    String accessToken,
  ) async {
    _logger.d('Syncing ${remoteMovies.length} movies...');

    for (final remoteMovie in remoteMovies) {
      try {
        final movie = remoteMovie.show as simkl_models.SimklMovie?;
        if (movie == null) continue;

        // Find matching local item by content ID (TMDB ID)
        final tmdbId = movie.ids.tmdb;
        final localItem = localItems.where((item) {
          return item.contentType == 'movie' && item.contentId == tmdbId;
        }).firstOrNull;

        if (localItem == null) {
          // Add new movie to local watchlist
          final newItem = WatchlistItem(
            id: 'movie_$tmdbId',
            contentId: tmdbId ?? 0,
            contentType: 'movie',
            title: movie.title ?? 'Unknown Movie',
            posterPath: null,
            overview: '',
            releaseDate: null,
            voteAverage: null,
            categories: [_mapSimklStatusToCategory(remoteMovie.status)],
            userRating: remoteMovie.userRating?.toDouble(),
            notes: null,
            priority: 3,
            addedAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isWatched: remoteMovie.status == 'completed',
            watchedAt: remoteMovie.lastWatchedAt != null
                ? DateTime.tryParse(remoteMovie.lastWatchedAt!)
                : null,
          );

          await WatchlistService.instance.addToWatchlist(newItem);
          _logger.d('Added new movie to watchlist: ${movie.title}');
        } else {
          // Update existing item if remote is newer
          final shouldUpdate = _shouldUpdateLocalItem(
            localItem.updatedAt,
            remoteMovie.lastWatchedAt,
          );

          if (shouldUpdate) {
            final updatedCategories = <String>{
              ...localItem.categories,
              _mapSimklStatusToCategory(remoteMovie.status),
            }.toList();

            final updatedItem = localItem.copyWith(
              categories: updatedCategories,
              userRating:
                  remoteMovie.userRating?.toDouble() ?? localItem.userRating,
              isWatched:
                  remoteMovie.status == 'completed' || localItem.isWatched,
              watchedAt: remoteMovie.lastWatchedAt != null
                  ? DateTime.tryParse(remoteMovie.lastWatchedAt!)
                  : localItem.watchedAt,
              updatedAt: DateTime.now(),
            );

            await WatchlistService.instance.updateWatchlistItem(updatedItem);
            _logger.d('Updated existing movie: ${movie.title}');
          }
        }
      } catch (e) {
        _logger.w('Failed to sync movie: $e');
      }
    }
  }

  /// Sync TV shows between local and remote
  Future<void> _syncShows(
    List<SimklWatchlistItem> remoteShows,
    List<WatchlistItem> localItems,
    String accessToken,
  ) async {
    _logger.d('Syncing ${remoteShows.length} TV shows...');

    for (final remoteShow in remoteShows) {
      try {
        final show = remoteShow.show as simkl_models.SimklShow?;
        if (show == null) continue;

        // Find matching local item by content ID (TMDB ID)
        final tmdbId = show.ids.tmdb;
        final localItem = localItems.where((item) {
          return item.contentType == 'tv' && item.contentId == tmdbId;
        }).firstOrNull;

        if (localItem == null) {
          // Add new show to local watchlist
          final newItem = WatchlistItem(
            id: 'tv_$tmdbId',
            contentId: tmdbId ?? 0,
            contentType: 'tv',
            title: show.title ?? 'Unknown Show',
            posterPath: null,
            overview: '',
            releaseDate: null,
            voteAverage: null,
            categories: [_mapSimklStatusToCategory(remoteShow.status)],
            userRating: remoteShow.userRating?.toDouble(),
            notes: null,
            priority: 3,
            addedAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isWatched: remoteShow.status == 'completed',
            watchedAt: remoteShow.lastWatchedAt != null
                ? DateTime.tryParse(remoteShow.lastWatchedAt!)
                : null,
          );

          await WatchlistService.instance.addToWatchlist(newItem);
          _logger.d('Added new TV show to watchlist: ${show.title}');
        } else {
          // Update existing item if remote is newer
          final shouldUpdate = _shouldUpdateLocalItem(
            localItem.updatedAt,
            remoteShow.lastWatchedAt,
          );

          if (shouldUpdate) {
            final updatedCategories = <String>{
              ...localItem.categories,
              _mapSimklStatusToCategory(remoteShow.status),
            }.toList();

            final updatedItem = localItem.copyWith(
              categories: updatedCategories,
              userRating:
                  remoteShow.userRating?.toDouble() ?? localItem.userRating,
              isWatched:
                  remoteShow.status == 'completed' || localItem.isWatched,
              watchedAt: remoteShow.lastWatchedAt != null
                  ? DateTime.tryParse(remoteShow.lastWatchedAt!)
                  : localItem.watchedAt,
              updatedAt: DateTime.now(),
            );

            await WatchlistService.instance.updateWatchlistItem(updatedItem);
            _logger.d('Updated existing TV show: ${show.title}');
          }
        }
      } catch (e) {
        _logger.w('Failed to sync TV show: $e');
      }
    }
  }

  /// Sync anime between local and remote
  Future<void> _syncAnime(
    List<SimklWatchlistItem> remoteAnime,
    List<WatchlistItem> localItems,
    String accessToken,
  ) async {
    _logger.d('Syncing ${remoteAnime.length} anime...');

    for (final remoteAnimeItem in remoteAnime) {
      try {
        final anime = remoteAnimeItem.show as simkl_models.SimklAnime?;
        if (anime == null) continue;

        // Find matching local item by content ID (MAL ID or TMDB ID)
        final malId = anime.ids.mal;
        final tmdbId = anime.ids.tmdb;
        final localItem = localItems.where((item) {
          return item.contentType == 'anime' &&
              (item.contentId == malId || item.contentId == tmdbId);
        }).firstOrNull;

        if (localItem == null) {
          // Add new anime to local watchlist
          final newItem = WatchlistItem(
            id: 'anime_${malId ?? tmdbId}',
            contentId: malId ?? tmdbId ?? 0,
            contentType: 'anime',
            title: anime.title ?? 'Unknown Anime',
            posterPath: null,
            overview: '',
            releaseDate: null,
            voteAverage: null,
            categories: [_mapSimklStatusToCategory(remoteAnimeItem.status)],
            userRating: remoteAnimeItem.userRating?.toDouble(),
            notes: null,
            priority: 3,
            addedAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isWatched: remoteAnimeItem.status == 'completed',
            watchedAt: remoteAnimeItem.lastWatchedAt != null
                ? DateTime.tryParse(remoteAnimeItem.lastWatchedAt!)
                : null,
          );

          await WatchlistService.instance.addToWatchlist(newItem);
          _logger.d('Added new anime to watchlist: ${anime.title}');
        } else {
          // Update existing item if remote is newer
          final shouldUpdate = _shouldUpdateLocalItem(
            localItem.updatedAt,
            remoteAnimeItem.lastWatchedAt,
          );

          if (shouldUpdate) {
            final updatedCategories = <String>{
              ...localItem.categories,
              _mapSimklStatusToCategory(remoteAnimeItem.status),
            }.toList();

            final updatedItem = localItem.copyWith(
              categories: updatedCategories,
              userRating:
                  remoteAnimeItem.userRating?.toDouble() ??
                  localItem.userRating,
              isWatched:
                  remoteAnimeItem.status == 'completed' || localItem.isWatched,
              watchedAt: remoteAnimeItem.lastWatchedAt != null
                  ? DateTime.tryParse(remoteAnimeItem.lastWatchedAt!)
                  : localItem.watchedAt,
              updatedAt: DateTime.now(),
            );

            await WatchlistService.instance.updateWatchlistItem(updatedItem);
            _logger.d('Updated existing anime: ${anime.title}');
          }
        }
      } catch (e) {
        _logger.w('Failed to sync anime: $e');
      }
    }
  }

  /// Map Simkl status to watchlist category
  String _mapSimklStatusToCategory(String simklStatus) {
    switch (simklStatus) {
      case 'watching':
        return 'Currently Watching';
      case 'plantowatch':
        return 'Want to Watch';
      case 'completed':
        return 'Watched';
      case 'hold':
        return 'On Hold';
      case 'dropped':
        return 'Dropped';
      default:
        return 'Watch Later';
    }
  }

  /// Determine if local item should be updated based on timestamps
  bool _shouldUpdateLocalItem(
    DateTime? localUpdatedAt,
    String? remoteWatchedAt,
  ) {
    if (remoteWatchedAt == null) return false;
    if (localUpdatedAt == null) return true;

    final remoteDate = DateTime.tryParse(remoteWatchedAt);
    if (remoteDate == null) return false;

    return remoteDate.isAfter(localUpdatedAt);
  }
}
