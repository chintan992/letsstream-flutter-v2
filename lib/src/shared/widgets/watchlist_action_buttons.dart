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
  bool _isInWatchlist = false;
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkWatchlistStatus();
  }

  @override
  void didUpdateWidget(WatchlistActionButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _checkWatchlistStatus();
    }
  }

  void _checkWatchlistStatus() {
    final items = ref.read(watchlistItemsProvider);

    final itemId = widget.item is Movie
        ? 'movie_${(widget.item as Movie).id}'
        : 'tv_${(widget.item as TvShow).id}';

    final watchlistItem = items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => WatchlistItem(
        id: itemId,
        contentId: widget.item is Movie
            ? (widget.item as Movie).id
            : (widget.item as TvShow).id,
        contentType: widget.item is Movie ? 'movie' : 'tv',
        title: widget.item is Movie
            ? (widget.item as Movie).title
            : (widget.item as TvShow).name,
        posterPath: widget.item is Movie
            ? (widget.item as Movie).posterPath
            : (widget.item as TvShow).posterPath,
        overview: widget.item is Movie
            ? (widget.item as Movie).overview
            : (widget.item as TvShow).overview,
        releaseDate: widget.item is Movie
            ? (widget.item as Movie).releaseDate
            : (widget.item as TvShow).firstAirDate,
        voteAverage: widget.item is Movie
            ? (widget.item as Movie).voteAverage
            : (widget.item as TvShow).voteAverage,
        categories: [],
        addedAt: DateTime.now(),
      ),
    );

    setState(() {
      _isInWatchlist = items.any((item) => item.id == itemId);
      _isFavorite = watchlistItem.categories.contains('Favorites');
    });
  }

  Future<void> _toggleWatchlist() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (_isInWatchlist) {
        // Remove from watchlist
        final itemId = widget.item is Movie
            ? 'movie_${(widget.item as Movie).id}'
            : 'tv_${(widget.item as TvShow).id}';
        await watchlistNotifier.removeItem(itemId);
        setState(() => _isInWatchlist = false);
        widget.onWatchlistToggle?.call(false);
      } else {
        // Add to watchlist
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(widget.item as Movie)
            : WatchlistItem.fromTvShow(widget.item as TvShow);

        await watchlistNotifier.addItem(watchlistItem);
        setState(() => _isInWatchlist = true);
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
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorites() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);
      final itemId = widget.item is Movie
          ? 'movie_${(widget.item as Movie).id}'
          : 'tv_${(widget.item as TvShow).id}';

      if (_isFavorite) {
        // Remove from favorites
        await watchlistNotifier.updateItemWith(
          itemId,
          categories: ['Watch Later'], // Remove Favorites category
        );
        setState(() => _isFavorite = false);
        widget.onFavoritesToggle?.call(false);
      } else {
        // Add to favorites
        await watchlistNotifier.updateItemWith(
          itemId,
          categories: ['Watch Later', 'Favorites'], // Add Favorites category
        );
        setState(() => _isFavorite = true);
        widget.onFavoritesToggle?.call(true);
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _toggleWatchlist,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_isInWatchlist ? Icons.bookmark : Icons.bookmark_border),
            label: Text(_isInWatchlist ? 'In Watchlist' : 'Add to Watchlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isInWatchlist
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: _isInWatchlist
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
            onPressed: _isLoading ? null : _toggleFavorites,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
            label: Text(_isFavorite ? 'Favorited' : 'Add to Favorites'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: _isFavorite
                    ? Colors.red
                    : Theme.of(context).colorScheme.outline,
              ),
              foregroundColor: _isFavorite
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
  bool _isInWatchlist = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkWatchlistStatus();
  }

  @override
  void didUpdateWidget(MediaCardWatchlistButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _checkWatchlistStatus();
    }
  }

  void _checkWatchlistStatus() {
    final items = ref.read(watchlistItemsProvider);
    final itemId = widget.item is Movie
        ? 'movie_${(widget.item as Movie).id}'
        : 'tv_${(widget.item as TvShow).id}';

    setState(() {
      _isInWatchlist = items.any((item) => item.id == itemId);
    });
  }

  Future<void> _toggleWatchlist() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (_isInWatchlist) {
        final itemId = widget.item is Movie
            ? 'movie_${(widget.item as Movie).id}'
            : 'tv_${(widget.item as TvShow).id}';
        await watchlistNotifier.removeItem(itemId);
        setState(() => _isInWatchlist = false);
      } else {
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(widget.item as Movie)
            : WatchlistItem.fromTvShow(widget.item as TvShow);

        await watchlistNotifier.addItem(watchlistItem);
        setState(() => _isInWatchlist = true);
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
          onPressed: _isLoading ? null : _toggleWatchlist,
          tooltip:
              _isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
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
                  _isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
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
  bool _isInWatchlist = false;
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkWatchlistStatus();
  }

  @override
  void didUpdateWidget(CompactWatchlistButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _checkWatchlistStatus();
    }
  }

  void _checkWatchlistStatus() {
    final items = ref.read(watchlistItemsProvider);
    final itemId = widget.item is Movie
        ? 'movie_${(widget.item as Movie).id}'
        : 'tv_${(widget.item as TvShow).id}';

    setState(() {
      _isInWatchlist = items.any((item) => item.id == itemId);
      _isFavorite = items
          .firstWhere(
            (item) => item.id == itemId,
            orElse: () => WatchlistItem(
              id: itemId,
              contentId: widget.item is Movie
                  ? (widget.item as Movie).id
                  : (widget.item as TvShow).id,
              contentType: widget.item is Movie ? 'movie' : 'tv',
              title: '',
              categories: [],
              addedAt: DateTime.now(),
            ),
          )
          .categories
          .contains('Favorites');
    });
  }

  Future<void> _toggleWatchlist() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);

      if (_isInWatchlist) {
        final itemId = widget.item is Movie
            ? 'movie_${(widget.item as Movie).id}'
            : 'tv_${(widget.item as TvShow).id}';
        await watchlistNotifier.removeItem(itemId);
        setState(() => _isInWatchlist = false);
        widget.onWatchlistToggle?.call(false);
      } else {
        final watchlistItem = widget.item is Movie
            ? WatchlistItem.fromMovie(widget.item as Movie)
            : WatchlistItem.fromTvShow(widget.item as TvShow);

        await watchlistNotifier.addItem(watchlistItem);
        setState(() => _isInWatchlist = true);
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
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorites() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final watchlistNotifier = ref.read(watchlistNotifierProvider.notifier);
      final itemId = widget.item is Movie
          ? 'movie_${(widget.item as Movie).id}'
          : 'tv_${(widget.item as TvShow).id}';

      if (_isFavorite) {
        await watchlistNotifier.updateItemWith(
          itemId,
          categories: ['Watch Later'],
        );
        setState(() => _isFavorite = false);
        widget.onFavoritesToggle?.call(false);
      } else {
        await watchlistNotifier.updateItemWith(
          itemId,
          categories: ['Watch Later', 'Favorites'],
        );
        setState(() => _isFavorite = true);
        widget.onFavoritesToggle?.call(true);
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _isLoading ? null : _toggleWatchlist,
          iconSize: widget.size,
          tooltip:
              _isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
          icon: _isLoading
              ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  _isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                  color: _isInWatchlist
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
        ),
        IconButton(
          onPressed: _isLoading ? null : _toggleFavorites,
          iconSize: widget.size,
          tooltip: _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
          icon: _isLoading
              ? SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
        ),
      ],
    );
  }
}
