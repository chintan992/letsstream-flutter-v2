import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/watchlist_item.dart';
import '../../../core/providers/watchlist_providers.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/shimmer_row.dart';
import '../widgets/watchlist_filter_bar.dart';
import '../widgets/watchlist_item_card.dart';
import '../widgets/watchlist_sort_options.dart';

/// Comprehensive watchlist screen with filtering, search, and item management.
///
/// This screen provides a full-featured watchlist interface that allows users to:
/// - View all their saved movies and TV shows
/// - Search through their watchlist
/// - Filter by categories, content type, and viewing status
/// - Sort items by various criteria
/// - Edit item details, ratings, and categories
/// - Mark items as watched/unwatched
/// - Remove items from watchlist
///
/// The screen follows Material Design 3 principles and integrates seamlessly
/// with the app's existing design system and state management architecture.
class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchlistState = ref.watch(watchlistNotifierProvider);
    final filteredItems = ref.watch(filteredWatchlistItemsProvider);
    final isLoading = ref.watch(watchlistLoadingProvider);
    final error = ref.watch(watchlistErrorProvider);
    final statistics = ref.watch(watchlistStatisticsProvider);

    // Show loading state
    if (isLoading && watchlistState.items.isEmpty) {
      return const Scaffold(
        body: SafeArea(
          child: ShimmerRow(
            count: 10,
            itemHeight: 200,
          ),
        ),
      );
    }

    // Show error state
    if (error != null && watchlistState.items.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: ErrorState(
            message: error,
            onRetry: () =>
                ref.read(watchlistNotifierProvider.notifier).refresh(),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with statistics
            _buildHeader(statistics),

            // Search and filters
            WatchlistFilterBar(
              searchController: _searchController,
              onSearchChanged: (query) {
                ref
                    .read(watchlistNotifierProvider.notifier)
                    .setSearchQuery(query);
              },
            ),

            // Content area
            Expanded(
              child: filteredItems.isEmpty
                  ? _buildEmptyState(watchlistState.searchQuery.isNotEmpty)
                  : _buildWatchlistGrid(filteredItems),
            ),
          ],
        ),
      ),

      // Floating action button for sort options
      floatingActionButton: ScaleTransition(
        scale: _fabAnimationController,
        child: FloatingActionButton(
          onPressed: _showSortOptions,
          tooltip: 'Sort options',
          child: const Icon(Icons.sort),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, int> statistics) {
    return Container(
      padding: const EdgeInsets.all(Tokens.spaceL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Watchlist',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              _buildStatisticsChip(statistics),
            ],
          ),
          const SizedBox(height: Tokens.spaceS),
          Text(
            '${statistics['total'] ?? 0} items • ${statistics['watched'] ?? 0} watched',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsChip(Map<String, int> statistics) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Tokens.spaceM,
        vertical: Tokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(Tokens.radiusM),
      ),
      child: Text(
        '${statistics['total'] ?? 0}',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearchResult) {
    return isSearchResult
        ? EmptyState.noResults(
            query: _searchController.text,
            actions: [
              FilledButton.icon(
                onPressed: () {
                  _searchController.clear();
                  ref.read(watchlistNotifierProvider.notifier).clearFilters();
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear filters'),
              ),
            ],
          )
        : EmptyState.noWatchlist();
  }

  Widget _buildWatchlistGrid(List<WatchlistItem> items) {
    return RefreshIndicator(
      onRefresh: () => ref.read(watchlistNotifierProvider.notifier).refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.all(Tokens.spaceL),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: Tokens.spaceM,
          mainAxisSpacing: Tokens.spaceL,
          childAspectRatio: Tokens.posterAspect,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return WatchlistItemCard(
            item: item,
            onTap: () => _navigateToDetail(item),
            onEdit: () => _showEditDialog(item),
            onDelete: () => _showDeleteDialog(item),
            onToggleWatched: () => _toggleWatchedStatus(item),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: (index * 50).ms)
              .slideY(begin: 0.2, duration: 300.ms, delay: (index * 50).ms);
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => WatchlistSortOptions(
        onSortSelected: (sortOptionWithOrder) {
          // TODO: Implement sorting logic using sortOptionWithOrder.option and sortOptionWithOrder.isDescending
          Navigator.pop(context);
        },
      ),
    );
  }

  void _navigateToDetail(WatchlistItem item) {
    if (item.contentType == 'movie') {
      context.pushNamed('movie-detail',
          extra: _createMovieFromWatchlistItem(item));
    } else {
      context.pushNamed('tv-detail',
          extra: _createTvShowFromWatchlistItem(item));
    }
  }

  void _showEditDialog(WatchlistItem item) {
    showDialog(
      context: context,
      builder: (context) => _EditWatchlistItemDialog(item: item),
    );
  }

  void _showDeleteDialog(WatchlistItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Watchlist'),
        content: Text(
            'Are you sure you want to remove "${item.title}" from your watchlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(watchlistNotifierProvider.notifier).removeItem(item.id);
              Navigator.pop(context);
              _showSnackBar('Removed from watchlist');
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _toggleWatchedStatus(WatchlistItem item) {
    ref.read(watchlistNotifierProvider.notifier).toggleWatchedStatus(item.id);
    final isWatched = !item.isWatched;
    _showSnackBar(
      isWatched ? 'Marked as watched' : 'Marked as unwatched',
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Helper methods to create movie/TV show objects from watchlist items
  dynamic _createMovieFromWatchlistItem(WatchlistItem item) {
    // This would need the actual Movie model structure
    // For now, return a basic map that can be handled by the detail screen
    return {
      'id': item.contentId,
      'title': item.title,
      'posterPath': item.posterPath,
      'overview': item.overview,
      'releaseDate': item.releaseDate,
      'voteAverage': item.voteAverage,
    };
  }

  dynamic _createTvShowFromWatchlistItem(WatchlistItem item) {
    // This would need the actual TvShow model structure
    return {
      'id': item.contentId,
      'name': item.title,
      'posterPath': item.posterPath,
      'overview': item.overview,
      'firstAirDate': item.releaseDate,
      'voteAverage': item.voteAverage,
    };
  }
}

/// Dialog for editing watchlist item details
class _EditWatchlistItemDialog extends ConsumerStatefulWidget {
  final WatchlistItem item;

  const _EditWatchlistItemDialog({required this.item});

  @override
  ConsumerState<_EditWatchlistItemDialog> createState() =>
      _EditWatchlistItemDialogState();
}

class _EditWatchlistItemDialogState
    extends ConsumerState<_EditWatchlistItemDialog> {
  late TextEditingController _notesController;
  late double _userRating;
  late int _priority;
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.item.notes ?? '');
    _userRating = widget.item.userRating ?? 0.0;
    _priority = widget.item.priority;
    _selectedCategories = List.from(widget.item.categories);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = ref.watch(watchlistCategoriesProvider);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(Tokens.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit ${widget.item.title}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Tokens.spaceL),

            // User Rating
            Text(
              'Your Rating',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Tokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _userRating,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _userRating > 0
                        ? _userRating.toStringAsFixed(1)
                        : 'Not rated',
                    onChanged: (value) {
                      setState(() {
                        _userRating = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: Tokens.spaceS),
                Text(
                  _userRating > 0 ? _userRating.toStringAsFixed(1) : '—',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: Tokens.spaceL),

            // Priority
            Text(
              'Priority',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Tokens.spaceS),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Low')),
                ButtonSegment(value: 2, label: Text('Medium')),
                ButtonSegment(value: 3, label: Text('High')),
              ],
              selected: {_priority},
              onSelectionChanged: (values) {
                setState(() {
                  _priority = values.first;
                });
              },
            ),
            const SizedBox(height: Tokens.spaceL),

            // Categories
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Tokens.spaceS),
            Wrap(
              spacing: Tokens.spaceXS,
              runSpacing: Tokens.spaceXS,
              children: availableCategories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: Tokens.spaceL),

            // Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add your thoughts about this item...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: Tokens.spaceL),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: Tokens.spaceS),
                FilledButton(
                  onPressed: _saveChanges,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    ref.read(watchlistNotifierProvider.notifier).updateItemWith(
          widget.item.id,
          userRating: _userRating > 0 ? _userRating : null,
          priority: _priority,
          categories: _selectedCategories,
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
        );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Watchlist item updated')),
    );
  }
}
