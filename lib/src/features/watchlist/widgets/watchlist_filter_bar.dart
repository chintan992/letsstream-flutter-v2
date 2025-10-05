import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/watchlist_providers.dart';
import '../../../shared/theme/tokens.dart';

/// Filter bar for watchlist search and category filtering.
///
/// This widget provides a comprehensive filtering interface for the watchlist,
/// including search functionality and category-based filtering with visual chips.
/// The filter bar integrates with the watchlist state management to provide
/// real-time filtering as users type or select categories.
///
/// Features:
/// - Real-time search with debouncing
/// - Category-based filtering with visual chip selection
/// - Clear all filters functionality
/// - Responsive design that adapts to different screen sizes
/// - Accessibility support with proper semantics
///
/// Example usage:
/// ```dart
/// WatchlistFilterBar(
///   searchController: _searchController,
///   onSearchChanged: (query) {
///     ref.read(watchlistNotifierProvider.notifier).setSearchQuery(query);
///   },
/// )
/// ```
class WatchlistFilterBar extends ConsumerStatefulWidget {
  /// Controller for managing the search text field.
  final TextEditingController searchController;

  /// Callback function called when the search query changes.
  final Function(String) onSearchChanged;

  /// Creates a watchlist filter bar widget.
  ///
  /// The [searchController] manages the search text input.
  /// The [onSearchChanged] callback is triggered when the search query changes.
  const WatchlistFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  ConsumerState<WatchlistFilterBar> createState() => _WatchlistFilterBarState();
}

class _WatchlistFilterBarState extends ConsumerState<WatchlistFilterBar> {
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(watchlistCategoriesProvider);
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    final watchlistState = ref.watch(watchlistNotifierProvider);
    final hasActiveFilters = selectedCategories.isNotEmpty ||
        watchlistState.contentTypeFilter != null ||
        watchlistState.watchedStatusFilter != null;

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
          // Search bar
          _buildSearchBar(),

          const SizedBox(height: Tokens.spaceL),

          // Quick filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Filters',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (hasActiveFilters)
                TextButton.icon(
                  onPressed: _clearAllFilters,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: Text(
                    'Clear all',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: Tokens.spaceS),

          // Quick filter chips (Content Type & Watched Status)
          _buildQuickFilterChips(watchlistState),

          if (categories.isNotEmpty) ...[
            const SizedBox(height: Tokens.spaceL),

            // Category filters
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),

            const SizedBox(height: Tokens.spaceS),

            // Category filter chips
            _buildCategoryChips(categories, selectedCategories),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickFilterChips(dynamic watchlistState) {
    return Wrap(
      spacing: Tokens.spaceS,
      runSpacing: Tokens.spaceS,
      children: [
        // Content Type Filters
        ChoiceChip(
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.movie, size: 16),
              SizedBox(width: 4),
              Text('Movies'),
            ],
          ),
          selected: watchlistState.contentTypeFilter == 'movie',
          onSelected: (selected) {
            ref.read(watchlistNotifierProvider.notifier).setContentTypeFilter(
                  selected ? 'movie' : null,
                );
          },
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          side: BorderSide(
            color: watchlistState.contentTypeFilter == 'movie'
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        ChoiceChip(
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tv, size: 16),
              SizedBox(width: 4),
              Text('TV Shows'),
            ],
          ),
          selected: watchlistState.contentTypeFilter == 'tv',
          onSelected: (selected) {
            ref.read(watchlistNotifierProvider.notifier).setContentTypeFilter(
                  selected ? 'tv' : null,
                );
          },
          selectedColor: Theme.of(context).colorScheme.secondaryContainer,
          side: BorderSide(
            color: watchlistState.contentTypeFilter == 'tv'
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),

        // Divider
        Container(
          height: 32,
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
          margin: const EdgeInsets.symmetric(horizontal: 4),
        ),

        // Watched Status Filters
        ChoiceChip(
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 16),
              SizedBox(width: 4),
              Text('Watched'),
            ],
          ),
          selected: watchlistState.watchedStatusFilter == true,
          onSelected: (selected) {
            ref.read(watchlistNotifierProvider.notifier).setWatchedStatusFilter(
                  selected ? true : null,
                );
          },
          selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
          side: BorderSide(
            color: watchlistState.watchedStatusFilter == true
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        ChoiceChip(
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 16),
              SizedBox(width: 4),
              Text('To Watch'),
            ],
          ),
          selected: watchlistState.watchedStatusFilter == false,
          onSelected: (selected) {
            ref.read(watchlistNotifierProvider.notifier).setWatchedStatusFilter(
                  selected ? false : null,
                );
          },
          selectedColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          side: BorderSide(
            color: watchlistState.watchedStatusFilter == false
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Tokens.radiusM),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.searchController,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search your watchlist...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.searchController.clear();
                    widget.onSearchChanged('');
                  },
                  tooltip: 'Clear search',
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Tokens.spaceL,
            vertical: Tokens.spaceM,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(
    List<String> categories,
    List<String> selectedCategories,
  ) {
    return Wrap(
      spacing: Tokens.spaceXS,
      runSpacing: Tokens.spaceXS,
      children: categories.map((category) {
        final isSelected = selectedCategories.contains(category);
        return FilterChip(
          label: Text(
            category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            _toggleCategoryFilter(category, selected);
          },
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        );
      }).toList(),
    );
  }

  void _toggleCategoryFilter(String category, bool selected) {
    final notifier = ref.read(watchlistNotifierProvider.notifier);
    final currentSelected = ref.read(selectedCategoriesProvider);

    if (selected) {
      notifier.setSelectedCategories([...currentSelected, category]);
    } else {
      notifier.setSelectedCategories(
        currentSelected.where((c) => c != category).toList(),
      );
    }
  }

  void _clearAllFilters() {
    widget.searchController.clear();
    widget.onSearchChanged('');
    ref.read(watchlistNotifierProvider.notifier).clearFilters();
  }
}
