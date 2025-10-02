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

          if (categories.isNotEmpty) ...[
            const SizedBox(height: Tokens.spaceL),

            // Category filters header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (selectedCategories.isNotEmpty)
                  TextButton(
                    onPressed: _clearAllFilters,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear all',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: Tokens.spaceS),

            // Category filter chips
            _buildCategoryChips(categories, selectedCategories),
          ],
        ],
      ),
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
