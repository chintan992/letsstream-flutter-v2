import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/features/tv_shows/application/tv_list_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';

class TvListScreen extends ConsumerStatefulWidget {
  final String feed; // trending | airing_today | popular | top_rated
  final int? genreId;
  final String? genreName;

  const TvListScreen({
    super.key,
    required this.feed,
    this.genreId,
    this.genreName,
  });

  @override
  ConsumerState<TvListScreen> createState() => _TvListScreenState();
}

class _TvListScreenState extends ConsumerState<TvListScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final notifier = ref.read(
      tvListNotifierProvider((
        feed: widget.feed,
        genreId: widget.genreId,
      )).notifier,
    );
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      notifier.load();
    }
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TvListState state,
    AutoDisposeStateNotifierProvider<TvListNotifier, TvListState> provider,
  ) {
    if (state.isInitialLoad) {
      return _buildLoadingGrid();
    }

    if (state.error != null && state.tvShows.isEmpty) {
      return _buildErrorWidget(context, ref, state.error!, provider);
    }

    if (state.tvShows.isEmpty) {
      return const EmptyState(
        type: EmptyStateType.noResults,
        title: 'No TV shows found',
        message:
            'Try adjusting your search criteria or check back later for new content.',
        icon: Icons.tv_outlined,
      );
    }

    return _buildGrid(context, state);
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2 / 3,
      ),
      itemCount: 12,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const ShimmerBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, TvListState state) {
    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2 / 3,
      ),
      itemCount: state.tvShows.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.tvShows.length) {
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
        final tvShow = state.tvShows[index];
        return _buildTvShowCard(context, tvShow);
      },
    );
  }

  Widget _buildTvShowCard(BuildContext context, TvShow tvShow) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final poster = tvShow.posterPath;
    final url = (poster != null && poster.isNotEmpty)
        ? '$imageBaseUrl/w500$poster'
        : null;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'tv-detail',
          pathParameters: {'id': tvShow.id.toString()},
          extra: tvShow,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: url != null
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              )
            : Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
      ),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    WidgetRef ref,
    Object error,
    AutoDisposeStateNotifierProvider<TvListNotifier, TvListState> provider,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Could not load TV shows',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(provider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.genreName != null
        ? '${_titleForFeed(widget.feed)} ${widget.genreName}'
        : _titleForFeed(widget.feed);

    final provider = tvListNotifierProvider((
      feed: widget.feed,
      genreId: widget.genreId,
    ));
    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(provider.notifier).refresh(),
        child: _buildBody(context, ref, state, provider),
      ),
    );
  }

  String _titleForFeed(String feed) {
    switch (feed) {
      case 'trending':
        return 'Trending';
      case 'airing_today':
        return 'Airing Today';
      case 'popular':
        return 'Popular';
      case 'top_rated':
        return 'Top Rated';
      default:
        return 'TV Shows';
    }
  }
}
