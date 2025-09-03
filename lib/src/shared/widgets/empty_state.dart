import 'package:flutter/material.dart';

enum EmptyStateType {
  noResults,
  noWatchlist,
  noFavorites,
  offline,
  error,
  noContent,
  search,
}

class EmptyState extends StatelessWidget {
  final String? title;
  final String message;
  final IconData? icon;
  final Widget? illustration;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;
  final EmptyStateType type;

  const EmptyState({
    super.key,
    this.title,
    this.message = 'Nothing here yet',
    this.icon,
    this.illustration,
    this.actions,
    this.padding = const EdgeInsets.all(24),
    this.type = EmptyStateType.noContent,
  });

  factory EmptyState.noResults({String? query, List<Widget>? actions}) {
    return EmptyState(
      type: EmptyStateType.noResults,
      icon: Icons.search_off_outlined,
      title: 'No results found',
      message: query != null && query.isNotEmpty
          ? 'No results found for "$query". Try different keywords or check your spelling.'
          : 'No results found. Try adjusting your search criteria.',
      actions:
          actions ??
          [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
    );
  }

  factory EmptyState.noWatchlist({List<Widget>? actions}) {
    return EmptyState(
      type: EmptyStateType.noWatchlist,
      icon: Icons.bookmark_border_outlined,
      title: 'Your watchlist is empty',
      message:
          'Start building your watchlist by adding movies and TV shows you want to watch later.',
      actions:
          actions ??
          [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore),
              label: const Text('Discover Content'),
            ),
          ],
    );
  }

  factory EmptyState.noFavorites({List<Widget>? actions}) {
    return EmptyState(
      type: EmptyStateType.noFavorites,
      icon: Icons.favorite_border_outlined,
      title: 'No favorites yet',
      message:
          'Mark your favorite movies and TV shows to easily find them later.',
      actions:
          actions ??
          [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.star),
              label: const Text('Find Favorites'),
            ),
          ],
    );
  }

  factory EmptyState.offline({List<Widget>? actions}) {
    return EmptyState(
      type: EmptyStateType.offline,
      icon: Icons.wifi_off_outlined,
      title: 'You\'re offline',
      message:
          'Some content may not be available. Check your connection and try again.',
      actions:
          actions ??
          [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.wifi),
              label: const Text('Check Connection'),
            ),
          ],
    );
  }

  factory EmptyState.error({String? errorMessage, List<Widget>? actions}) {
    return EmptyState(
      type: EmptyStateType.error,
      icon: Icons.error_outline_outlined,
      title: 'Something went wrong',
      message: errorMessage ?? 'We encountered an error. Please try again.',
      actions:
          actions ??
          [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
    );
  }

  factory EmptyState.search({List<Widget>? actions}) {
    return EmptyState(
      type: EmptyStateType.search,
      icon: Icons.search_outlined,
      title: 'Search for content',
      message: 'Find your favorite movies, TV shows, and more.',
      actions: actions,
    );
  }

  IconData _getDefaultIcon() {
    return switch (type) {
      EmptyStateType.noResults => Icons.search_off_outlined,
      EmptyStateType.noWatchlist => Icons.bookmark_border_outlined,
      EmptyStateType.noFavorites => Icons.favorite_border_outlined,
      EmptyStateType.offline => Icons.wifi_off_outlined,
      EmptyStateType.error => Icons.error_outline_outlined,
      EmptyStateType.noContent => Icons.inbox_outlined,
      EmptyStateType.search => Icons.search_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayIcon = icon ?? _getDefaultIcon();

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
              ),
              child:
                  illustration ??
                  Icon(
                    displayIcon,
                    size: 40,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],

            // Message
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 32),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: actions!
                    .map(
                      (action) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: action,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
