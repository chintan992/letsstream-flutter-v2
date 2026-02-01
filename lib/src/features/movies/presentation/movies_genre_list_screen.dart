import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/movies/application/movies_list_notifier.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Netflix-style Movies Genre List Screen with filter chips.
class MoviesGenreListScreen extends ConsumerStatefulWidget {
  final int genreId;
  final String genreName;
  final String feed;

  const MoviesGenreListScreen({
    super.key,
    required this.genreId,
    required this.genreName,
    required this.feed,
  });

  @override
  ConsumerState<MoviesGenreListScreen> createState() =>
      _MoviesGenreListScreenState();
}

class _MoviesGenreListScreenState extends ConsumerState<MoviesGenreListScreen> {
  final ScrollController _scrollController = ScrollController();

  // Filter options for movies
  final List<String> _filters = [
    'Trending',
    'Now Playing',
    'Popular',
    'Top Rated',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterSelected(String filter) {
    final feedMap = {
      'Trending': 'trending',
      'Now Playing': 'now_playing',
      'Popular': 'popular',
      'Top Rated': 'top_rated',
    };
    
    final feed = feedMap[filter] ?? 'popular';
    context.pushReplacementNamed(
      'movies-genre',
      pathParameters: {'id': widget.genreId.toString()},
      queryParameters: {
        'name': widget.genreName,
        'feed': feed,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = moviesListNotifierProvider((feed: widget.feed, genreId: widget.genreId));
    final state = ref.watch(provider);

    return Scaffold(
      backgroundColor: NetflixColors.backgroundBlack,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Netflix-style App Bar
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: NetflixColors.backgroundBlack,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: NetflixColors.textPrimary),
                onPressed: () => context.pop(),
              ),
              title: Text(
                widget.genreName.toUpperCase(),
                style: GoogleFonts.bebasNeue(
                  fontSize: 24,
                  color: NetflixColors.textPrimary,
                  letterSpacing: 1.0,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: NetflixColors.textPrimary),
                  onPressed: () => context.pushNamed('search'),
                ),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: _buildFilterChips(),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () => ref.read(provider.notifier).refresh(),
          color: NetflixColors.primaryRed,
          backgroundColor: NetflixColors.surfaceDark,
          child: _buildBody(context, ref, state, provider),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = false;
          
          return _NetflixFilterChip(
            label: filter,
            isSelected: isSelected,
            onTap: () => _onFilterSelected(filter),
          );
        },
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
        type: EmptyStateType.noResults,
        title: 'No movies found',
        message: 'Try a different genre or check back later.',
        icon: Icons.movie_outlined,
      );
    }

    return _buildGrid(context, state);
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2 / 3,
      ),
      itemCount: 12,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: const ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, MoviesListState state) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2 / 3,
      ),
      itemCount: state.movies.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.movies.length) {
          return state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: NetflixColors.primaryRed,
                    strokeWidth: 2,
                  ),
                )
              : const SizedBox.shrink();
        }
        final movie = state.movies[index];
        return _NetflixMovieCard(
          movie: movie,
          imageBaseUrl: imageBaseUrl,
        );
      },
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    WidgetRef ref,
    Object error,
    AutoDisposeStateNotifierProvider<MoviesListNotifier, MoviesListState>
    provider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: NetflixColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'Could not load movies',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: NetflixColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NetflixColors.textSecondary,
              ),
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

/// Netflix-style filter chip
class _NetflixFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NetflixFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? NetflixColors.textPrimary
              : NetflixColors.surfaceMedium,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? NetflixColors.backgroundBlack
                : NetflixColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Netflix-style movie poster card
class _NetflixMovieCard extends StatelessWidget {
  final Movie movie;
  final String imageBaseUrl;

  const _NetflixMovieCard({
    required this.movie,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final poster = movie.posterPath;
    final url = (poster != null && poster.isNotEmpty)
        ? '$imageBaseUrl/w342$poster'
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
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: NetflixColors.surfaceDark,
          child: url != null
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerBox(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.zero,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: NetflixColors.surfaceMedium,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: NetflixColors.textSecondary,
                    ),
                  ),
                )
              : Container(
                  color: NetflixColors.surfaceMedium,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: NetflixColors.textSecondary,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
