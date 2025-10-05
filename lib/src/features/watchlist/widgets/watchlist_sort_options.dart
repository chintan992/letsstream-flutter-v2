import 'package:flutter/material.dart';
import '../../../core/providers/watchlist_providers.dart';
import '../../../shared/theme/tokens.dart';

/// Sort options bottom sheet for watchlist items.
///
/// This widget provides a modal bottom sheet interface for selecting
/// different sorting criteria for watchlist items. It supports various
/// sorting options like date added, priority, rating, and alphabetical order.
///
/// Features:
/// - Multiple sorting criteria (date, priority, rating, title)
/// - Ascending/descending order options
/// - Visual feedback for selected options
/// - Consistent design with the app's theme
/// - Accessibility support
///
/// Example usage:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (context) => WatchlistSortOptions(
///     onSortSelected: (option) {
///       // Handle sort selection
///       Navigator.pop(context);
///     },
///   ),
/// );
/// ```
class WatchlistSortOptions extends StatefulWidget {
  /// Callback when a sort option is selected.
  final Function(WatchlistSortOptionWithOrder) onSortSelected;

  /// Current sort option
  final WatchlistSortOption? currentOption;

  /// Current sort order (descending)
  final bool? currentIsDescending;

  const WatchlistSortOptions({
    super.key,
    required this.onSortSelected,
    this.currentOption,
    this.currentIsDescending,
  });

  @override
  State<WatchlistSortOptions> createState() => _WatchlistSortOptionsState();
}

class _WatchlistSortOptionsState extends State<WatchlistSortOptions> {
  late WatchlistSortOption _selectedOption;
  late bool _isDescending;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.currentOption ?? WatchlistSortOption.dateAdded;
    _isDescending = widget.currentIsDescending ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Tokens.spaceL),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort Watchlist',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                ),
              ],
            ),

            const SizedBox(height: Tokens.spaceL),

            // Sort criteria
            Text(
              'Sort by',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Tokens.spaceS),

            _buildSortCriteriaOptions(),

            const SizedBox(height: Tokens.spaceL),

            // Sort order
            Text(
              'Order',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Tokens.spaceS),

            _buildSortOrderOptions(),

            const SizedBox(height: Tokens.spaceL),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _applySort,
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortCriteriaOptions() {
    return Column(
      children: WatchlistSortOption.values.map((option) {
        return ListTile(
          title: Text(_getSortOptionTitle(option)),
          subtitle: Text(_getSortOptionSubtitle(option)),
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          leading: Radio<WatchlistSortOption>(
            value: option,
            groupValue: _selectedOption,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedOption = value;
                });
              }
            },
          ),
          onTap: () {
            setState(() {
              _selectedOption = option;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSortOrderOptions() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: const Text('Ascending'),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            leading: Radio<bool>(
              value: false,
              groupValue: _isDescending,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _isDescending = value;
                  });
                }
              },
            ),
            onTap: () {
              setState(() {
                _isDescending = false;
              });
            },
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Descending'),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            leading: Radio<bool>(
              value: true,
              groupValue: _isDescending,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _isDescending = value;
                  });
                }
              },
            ),
            onTap: () {
              setState(() {
                _isDescending = true;
              });
            },
          ),
        ),
      ],
    );
  }

  void _applySort() {
    final sortOption = WatchlistSortOptionWithOrder(
      option: _selectedOption,
      isDescending: _isDescending,
    );

    widget.onSortSelected(sortOption);
  }

  String _getSortOptionTitle(WatchlistSortOption option) {
    return switch (option) {
      WatchlistSortOption.dateAdded => 'Date Added',
      WatchlistSortOption.priority => 'Priority',
      WatchlistSortOption.rating => 'Rating',
      WatchlistSortOption.title => 'Title',
      WatchlistSortOption.contentType => 'Type',
      WatchlistSortOption.watchedStatus => 'Watched Status',
    };
  }

  String _getSortOptionSubtitle(WatchlistSortOption option) {
    return switch (option) {
      WatchlistSortOption.dateAdded => 'When items were added to watchlist',
      WatchlistSortOption.priority => 'Priority level (1-5)',
      WatchlistSortOption.rating => 'User rating or TMDB rating',
      WatchlistSortOption.title => 'Alphabetical order',
      WatchlistSortOption.contentType => 'Movies first, then TV shows',
      WatchlistSortOption.watchedStatus => 'Watched items first',
    };
  }
}

/// Wrapper class that combines sort option with sort order.
class WatchlistSortOptionWithOrder {
  final WatchlistSortOption option;
  final bool isDescending;

  const WatchlistSortOptionWithOrder({
    required this.option,
    required this.isDescending,
  });
}
