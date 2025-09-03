import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/search/application/search_notifier.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/features/search/application/search_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';

const List<String> kSearchSuggestions = [
  'Avengers',
  'Breaking Bad',
  'Naruto',
  'Inception',
  'Stranger Things',
  'Interstellar',
  'One Piece',
  'The Batman',
  'The Witcher',
  'Jujutsu Kaisen',
];

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _PosterThumb extends StatelessWidget {
  final String? imageUrl;
  const _PosterThumb({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = const Size(56, 84);
    if (imageUrl == null) {
      return SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      );
    }
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load persisted query/filter and trigger initial search if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchNotifierProvider.notifier).loadPersisted().then((q) {
        if (!mounted) return;
        _controller.text = q;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    // Prefetch when within last 20% of the list
    if (offset >= max * 0.8) {
      ref.read(searchNotifierProvider.notifier).fetchNextPage();
    }
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Filters',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (searchState.advancedFilters.hasActiveFilters)
                  TextButton(
                    onPressed: () {
                      notifier.clearAdvancedFilters();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Clear All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Sort By
            Text('Sort by', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<SortBy>(
              segments: const [
                ButtonSegment(value: SortBy.popularity, label: Text('Popular')),
                ButtonSegment(value: SortBy.releaseDate, label: Text('Latest')),
                ButtonSegment(value: SortBy.rating, label: Text('Rating')),
                ButtonSegment(value: SortBy.title, label: Text('Title')),
              ],
              selected: {searchState.advancedFilters.sortBy},
              onSelectionChanged: (selection) {
                notifier.updateSortBy(selection.first);
              },
            ),
            const SizedBox(height: 24),
            // Release Year
            Text(
              'Release Year',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: searchState.advancedFilters.releaseYear
                        ?.toString(),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 2023',
                      labelText: 'Year',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final year = int.tryParse(value);
                      notifier.updateYearFilter(year);
                    },
                  ),
                ),
                if (searchState.advancedFilters.releaseYear != null)
                  IconButton(
                    onPressed: () => notifier.updateYearFilter(null),
                    icon: const Icon(Icons.clear),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Minimum Rating
            Text(
              'Minimum Rating',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: searchState.advancedFilters.minRating ?? 0,
                    min: 0,
                    max: 10,
                    divisions: 20,
                    label: (searchState.advancedFilters.minRating ?? 0)
                        .toStringAsFixed(1),
                    onChanged: (value) {
                      notifier.updateRatingFilter(value > 0 ? value : null);
                    },
                  ),
                ),
                if (searchState.advancedFilters.minRating != null)
                  IconButton(
                    onPressed: () => notifier.updateRatingFilter(null),
                    icon: const Icon(Icons.clear),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search movies or TV shows',
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Clear',
                  onPressed: () {
                    _controller.clear();
                    ref
                        .read(searchNotifierProvider.notifier)
                        .onQueryChanged('');
                  },
                  icon: const Icon(Icons.clear),
                ),
                IconButton(
                  tooltip: 'Filters',
                  onPressed: () => _showFilterDialog(context, ref),
                  icon: Icon(
                    Icons.filter_list,
                    color: searchState.advancedFilters.hasActiveFilters
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ],
            ),
          ),
          textInputAction: TextInputAction.search,
          onChanged: (value) =>
              ref.read(searchNotifierProvider.notifier).onQueryChanged(value),
          onSubmitted: (value) =>
              ref.read(searchNotifierProvider.notifier).onQueryChanged(value),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (searchState.query.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  EmptyState.search(),
                  const SizedBox(height: 32),
                  Text(
                    'Try searching for',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in kSearchSuggestions)
                        ActionChip(
                          label: Text(s),
                          onPressed: () {
                            _controller.text = s;
                            ref
                                .read(searchNotifierProvider.notifier)
                                .onQueryChanged(s);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            );
          }
          if (searchState.isLoading && searchState.items.isEmpty) {
            // Shimmer list placeholder
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 8,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 56, height: 84),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: double.infinity, height: 16),
                          SizedBox(height: 8),
                          ShimmerBox(width: 120, height: 14),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          if (searchState.error != null && searchState.items.isEmpty) {
            return EmptyState.error(
              errorMessage: searchState.error,
              actions: [
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(searchNotifierProvider.notifier).retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            );
          }
          if (searchState.items.isEmpty) {
            return EmptyState.noResults(
              query: searchState.query,
              actions: [
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(searchNotifierProvider.notifier).retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            );
          }

          final visibleItems = searchState.filteredItems();
          final itemCount =
              visibleItems.length +
              ((searchState.isLoadingMore || searchState.hasMore) ? 1 : 0);
          final imageBase = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SegmentedButton<SearchFilter>(
                  segments: const [
                    ButtonSegment(
                      value: SearchFilter.all,
                      label: Text('All'),
                      icon: Icon(Icons.all_inclusive),
                    ),
                    ButtonSegment(
                      value: SearchFilter.movies,
                      label: Text('Movies'),
                      icon: Icon(Icons.movie_outlined),
                    ),
                    ButtonSegment(
                      value: SearchFilter.tv,
                      label: Text('TV'),
                      icon: Icon(Icons.tv_outlined),
                    ),
                  ],
                  selected: {searchState.filter},
                  onSelectionChanged: (selection) => ref
                      .read(searchNotifierProvider.notifier)
                      .setFilter(selection.first),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Results: ${visibleItems.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(searchNotifierProvider.notifier).retry();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: itemCount,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index >= visibleItems.length) {
                        if (searchState.isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (searchState.hasMore) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: OutlinedButton.icon(
                                onPressed: () => ref
                                    .read(searchNotifierProvider.notifier)
                                    .fetchNextPage(),
                                icon: const Icon(Icons.expand_more),
                                label: const Text('Load more'),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      final item = visibleItems[index];
                      if (item is Movie) {
                        final title = item.title.isNotEmpty
                            ? item.title
                            : 'Untitled Movie';
                        final posterPath = item.posterPath;
                        final imageUrl =
                            (posterPath != null && posterPath.isNotEmpty)
                            ? '$imageBase/w154$posterPath'
                            : null;
                        final year = item.releaseDate?.year;
                        final rating = item.voteAverage;
                        final subtitle = [
                          if (year != null) year.toString(),
                          if (rating > 0) '${rating.toStringAsFixed(1)} ★',
                        ].join(' • ');

                        return Semantics(
                          label:
                              '$title${year != null ? ' • $year' : ''} • Movie',
                          hint: 'Opens details',
                          button: true,
                          child: ListTile(
                            leading: _PosterThumb(imageUrl: imageUrl),
                            title: Text(title),
                            subtitle: subtitle.isNotEmpty
                                ? Text(subtitle)
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.pushNamed(
                              'movie-detail',
                              pathParameters: {'id': item.id.toString()},
                              extra: item,
                            ),
                          ),
                        );
                      } else if (item is TvShow) {
                        final title = item.name.isNotEmpty
                            ? item.name
                            : 'Untitled TV Show';
                        final posterPath = item.posterPath;
                        final imageUrl =
                            (posterPath != null && posterPath.isNotEmpty)
                            ? '$imageBase/w154$posterPath'
                            : null;
                        final year = item.firstAirDate?.year;
                        final rating = item.voteAverage;
                        final subtitle = [
                          if (year != null) year.toString(),
                          if (rating > 0) '${rating.toStringAsFixed(1)} ★',
                        ].join(' • ');
                        return Semantics(
                          label:
                              '$title${year != null ? ' • $year' : ''} • TV show',
                          hint: 'Opens details',
                          button: true,
                          child: ListTile(
                            leading: _PosterThumb(imageUrl: imageUrl),
                            title: Text(title),
                            subtitle: subtitle.isNotEmpty
                                ? Text(subtitle)
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.pushNamed(
                              'tv-detail',
                              pathParameters: {'id': item.id.toString()},
                              extra: item,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
