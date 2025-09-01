import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/movies/application/movies_list_notifier.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  final String feed;
  final int? genreId;
  final String? genreName;

  const MoviesListScreen({
    super.key,
    required this.feed,
    this.genreId,
    this.genreName,
  });

  @override
  ConsumerState<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends ConsumerState<MoviesListScreen> {
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
      moviesListNotifierProvider((
        feed: widget.feed,
        genreId: widget.genreId,
      )).notifier,
    );
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      notifier.load();
    }
  }

  String _titleForFeed(String feed) {
    switch (feed) {
      case 'trending':
        return 'Trending';
      case 'now_playing':
        return 'Now Playing';
      case 'popular':
        return 'Popular';
      case 'top_rated':
        return 'Top Rated';
      default:
        return 'Movies';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.genreName != null
        ? '${_titleForFeed(widget.feed)} ${widget.genreName}'
        : _titleForFeed(widget.feed);

    final provider = moviesListNotifierProvider((
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

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MoviesListState state,
    AutoDisposeStateNotifierProvider<MoviesListNotifier, MoviesListState>
    provider,
  ) {
    if (state.isInitialLoad) {
      return _buildLoadingGrid();
    }

    if (state.error != null && state.movies.isEmpty) {
      return _buildErrorWidget(context, ref, state.error!, provider);
    }

    if (state.movies.isEmpty) {
      return const EmptyState(
        message: 'No movies found',
        icon: Icons.movie_outlined,
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

  Widget _buildGrid(BuildContext context, MoviesListState state) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2 / 3,
      ),
      itemCount: state.movies.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.movies.length) {
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }
        final movie = state.movies[index];
        return _buildMovieCard(context, movie, imageBaseUrl);
      },
    );
  }

  Widget _buildMovieCard(
    BuildContext context,
    Movie movie,
    String imageBaseUrl,
  ) {
    final poster = movie.posterPath;
    final url = (poster != null && poster.isNotEmpty)
        ? '$imageBaseUrl/w500$poster'
        : null;

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'movie-detail',
          pathParameters: {'id': movie.id.toString()},
          extra: movie,
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
                  child: const Icon(Icons.image_not_supported_outlined),
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
    AutoDisposeStateNotifierProvider<MoviesListNotifier, MoviesListState>
    provider,
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
              'Could not load movies',
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
}
