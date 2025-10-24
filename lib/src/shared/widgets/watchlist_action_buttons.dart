import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/watchlist_item.dart';
import 'package:lets_stream/src/core/providers/watchlist_providers.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

/// A widget that displays watchlist action buttons (Add to Watchlist and Add to Favorites)
/// for movies and TV shows in detail screens.
///
/// This widget provides a consistent interface for adding/removing items from watchlist
/// and favorites with proper state management and visual feedback.
///
/// ```dart
/// WatchlistActionButtons(
///   item: movie, // Movie or TvShow object
///   onWatchlistToggle: (isInWatchlist) {
///     // Handle watchlist state change
///   },
///   onFavoritesToggle: (isFavorite) {
///     // Handle favorites state change
///   },
/// )
/// ```
class WatchlistActionButtons extends ConsumerStatefulWidget {
  /// The movie or TV show item to manage in the watchlist.
  final Object item; // Movie or TvShow

  /// Callback function called when watchlist status changes.
  final Function(bool)? onWatchlistToggle;

  /// Callback function called when favorites status changes.
  final Function(bool)? onFavoritesToggle;

  /// Creates watchlist action buttons widget.
  ///
  /// The [item] is the movie or TV show to manage.
  /// The [onWatchlistToggle] callback is triggered when watchlist status changes.
  /// The [onFavoritesToggle] callback is triggered when favorites status changes.
  const WatchlistActionButtons({
    super.key,
    required this.item,
    this.onWatchlistToggle,
    this.onFavoritesToggle,
  });

  @override
  ConsumerState<WatchlistActionButtons> createState() =>
      _WatchlistActionButtonsState();
}

class _WatchlistActionButtonsState
    extends ConsumerState<WatchlistActionButtons> {
  bool _isLoading = false;

  String get _itemId => widget.item is Movie
      ? 'movie_${(widget.item as Movie).id}'
      : 'tv_${(widget.item as TvShow).id}';

  Future<void> _toggleWatchlist(bool isInWatchlist) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (isInWatchlist) {
        // Remove from watchlist
        await watchlistNotifier.removeItem(_itemId);
        widget.onWatchlistToggle?.call(false);
      } else {
        // Add to watchlist
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(widget.item as Movie)
            : WatchlistItem.fromTvShow(widget.item as TvShow);

        await watchlistNotifier.addItem(watchlistItem);
        widget.onWatchlistToggle?.call(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating watchlist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleFavorites(bool isInWatchlist, bool isFavorite) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (!isInWatchlist) {
        // Item not in watchlist - add it with Favorites category
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(
                widget.item as Movie,
                categories: [WatchlistCategories.favorites],
              )
            : WatchlistItem.fromTvShow(
                widget.item as TvShow,
                categories: [WatchlistCategories.favorites],
              );

        await watchlistNotifier.addItem(watchlistItem);
        widget.onWatchlistToggle?.call(true);
        widget.onFavoritesToggle?.call(true);
      } else {
        // Item already in watchlist - preserve existing categories
        final items = ref.read(watchlistItemsProvider);
        final existingItem = items.firstWhere((item) => item.id == _itemId);
        final currentCategories = List<String>.from(existingItem.categories);

        final updatedCategories = isFavorite
            ? currentCategories
                .where((c) => c != WatchlistCategories.favorites)
                .toList()
            : [
                ...currentCategories,
                if (!currentCategories.contains(WatchlistCategories.favorites))
                  WatchlistCategories.favorites,
              ];

        await watchlistNotifier.updateItemWith(
          _itemId,
          categories: updatedCategories,
        );
        widget.onFavoritesToggle?.call(!isFavorite);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating favorites: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the watchlist items to reactively update UI
    final watchlistItems = ref.watch(watchlistItemsProvider);
    final isInWatchlist = watchlistItems.any((item) => item.id == _itemId);
    final isFavorite = watchlistItems
        .where((item) => item.id == _itemId)
        .firstOrNull
        ?.categories
        .contains(WatchlistCategories.favorites) ?? false;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : () => _toggleWatchlist(isInWatchlist),
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(isInWatchlist ? Icons.bookmark : Icons.bookmark_border),
            label: Text(isInWatchlist ? 'In Watchlist' : 'Add to Watchlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isInWatchlist
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: isInWatchlist
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () => _toggleFavorites(isInWatchlist, isFavorite),
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
            label: Text(isFavorite ? 'Favorited' : 'Add to Favorites'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isFavorite
                    ? Colors.red
                    : Theme.of(context).colorScheme.outline,
              ),
              foregroundColor: isFavorite
                  ? Colors.red
                  : Theme.of(context).colorScheme.onSurface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// An ultra-compact watchlist button for overlay on media cards.
/// This widget shows a single bookmark icon that toggles watchlist status.
/// Perfect for small spaces like media cards where space is at a premium.
///
class MediaCardWatchlistButton extends ConsumerStatefulWidget {
  final Object item; // Movie or TvShow
  final double size;
  final VoidCallback? onToggle;

  const MediaCardWatchlistButton({
    super.key,
    required this.item,
    this.size = 24,
    this.onToggle,
  });

  @override
  ConsumerState<MediaCardWatchlistButton> createState() =>
      _MediaCardWatchlistButtonState();
}

class _MediaCardWatchlistButtonState
    extends ConsumerState<MediaCardWatchlistButton> {
  bool _isLoading = false;

  String get _itemId => widget.item is Movie
      ? 'movie_${(widget.item as Movie).id}'
      : 'tv_${(widget.item as TvShow).id}';

  Future<void> _toggleWatchlist(bool isInWatchlist) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (isInWatchlist) {
        await watchlistNotifier.removeItem(_itemId);
      } else {
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(widget.item as Movie)
            : WatchlistItem.fromTvShow(widget.item as TvShow);

        await watchlistNotifier.addItem(watchlistItem);
      }

      widget.onToggle?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating watchlist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchlistItems = ref.watch(watchlistItemsProvider);
    final isInWatchlist = watchlistItems.any((item) => item.id == _itemId);

    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        width: widget.size + 8,
        height: widget.size + 8,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          iconSize: widget.size,
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : () => _toggleWatchlist(isInWatchlist),
          tooltip:
              isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
          icon: _isLoading
              ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}

/// A very compact watchlist button for overlay on media cards.
/// This widget shows a single bookmark icon that toggles watchlist status.
///
/// ```dart
/// CompactWatchlistButtons(
///   item: movie,
///   size: 32,
/// )
/// ```
class CompactWatchlistButtons extends ConsumerStatefulWidget {
  final Object item; // Movie or TvShow
  final double size;
  final Function(bool)? onWatchlistToggle;
  final Function(bool)? onFavoritesToggle;

  const CompactWatchlistButtons({
    super.key,
    required this.item,
    this.size = 32,
    this.onWatchlistToggle,
    this.onFavoritesToggle,
  });

  @override
  ConsumerState<CompactWatchlistButtons> createState() =>
      _CompactWatchlistButtonsState();
}

class _CompactWatchlistButtonsState
    extends ConsumerState<CompactWatchlistButtons> {
  bool _isLoading = false;

  String get _itemId => widget.item is Movie
      ? 'movie_${(widget.item as Movie).id}'
      : 'tv_${(widget.item as TvShow).id}';

  Future<void> _toggleWatchlist(bool isInWatchlist) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (isInWatchlist) {
        await watchlistNotifier.removeItem(_itemId);
        widget.onWatchlistToggle?.call(false);
      } else {
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(widget.item as Movie)
            : WatchlistItem.fromTvShow(widget.item as TvShow);

        await watchlistNotifier.addItem(watchlistItem);
        widget.onWatchlistToggle?.call(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating watchlist: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleFavorites(bool isInWatchlist, bool isFavorite) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (!isInWatchlist) {
        // Item not in watchlist - add it with Favorites category
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(
                widget.item as Movie,
                categories: [WatchlistCategories.favorites],
              )
            : WatchlistItem.fromTvShow(
                widget.item as TvShow,
                categories: [WatchlistCategories.favorites],
              );

        await watchlistNotifier.addItem(watchlistItem);
        widget.onWatchlistToggle?.call(true);
        widget.onFavoritesToggle?.call(true);
      } else {
        // Item already in watchlist - preserve existing categories
        final items = ref.read(watchlistItemsProvider);
        final existingItem = items.firstWhere((item) => item.id == _itemId);
        final currentCategories = List<String>.from(existingItem.categories);

        final updatedCategories = isFavorite
            ? currentCategories
                .where((c) => c != WatchlistCategories.favorites)
                .toList()
            : [
                ...currentCategories,
                if (!currentCategories.contains(WatchlistCategories.favorites))
                  WatchlistCategories.favorites,
              ];

        await watchlistNotifier.updateItemWith(
          _itemId,
          categories: updatedCategories,
        );
        widget.onFavoritesToggle?.call(!isFavorite);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating favorites: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the watchlist items to reactively update UI
    final watchlistItems = ref.watch(watchlistItemsProvider);
    final isInWatchlist = watchlistItems.any((item) => item.id == _itemId);
    final isFavorite = watchlistItems
        .where((item) => item.id == _itemId)
        .firstOrNull
        ?.categories
        .contains(WatchlistCategories.favorites) ?? false;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _isLoading ? null : () => _toggleWatchlist(isInWatchlist),
          iconSize: widget.size,
          tooltip:
              isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
          icon: _isLoading
              ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                  color: isInWatchlist
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
        ),
        IconButton(
          onPressed: _isLoading ? null : () => _toggleFavorites(isInWatchlist, isFavorite),
          iconSize: widget.size,
          tooltip: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
          icon: _isLoading
              ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
        ),
      ],
    );
  }
}
