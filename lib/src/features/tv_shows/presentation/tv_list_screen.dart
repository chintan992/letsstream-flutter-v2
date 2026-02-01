import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/features/tv_shows/application/tv_list_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Netflix-style TV Shows List Screen with filter chips and 3-column grid.
class TvListScreen extends ConsumerStatefulWidget {
  final String feed;
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

  // Filter options
  final List<String> _filters = [
    'Trending',
    'Airing Today',
    'Popular',
    'Top Rated',
  ];

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
      ),).notifier,
    );
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      notifier.load();
    }
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

  void _onFilterSelected(String filter) {
    final feedMap = {
      'Trending': 'trending',
      'Airing Today': 'airing_today',
      'Popular': 'popular',
      'Top Rated': 'top_rated',
    };
    
    final feed = feedMap[filter] ?? widget.feed;
    context.pushReplacementNamed(
      'tv-list',
      pathParameters: {'feed': feed},
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.genreName != null
        ? widget.genreName!
        : _titleForFeed(widget.feed);

    final provider = tvListNotifierProvider((
      feed: widget.feed,
      genreId: widget.genreId,
    ),);
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
                title.toUpperCase(),
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
          final isSelected = _titleForFeed(widget.feed) == filter;
          
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

  Widget _buildGrid(BuildContext context, TvListState state) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2 / 3,
      ),
      itemCount: state.tvShows.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.tvShows.length) {
          return state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: NetflixColors.primaryRed,
                    strokeWidth: 2,
                  ),
                )
              : const SizedBox.shrink();
        }
        final tvShow = state.tvShows[index];
        return _NetflixTvShowCard(
          tvShow: tvShow,
          imageBaseUrl: imageBaseUrl,
        );
      },
    );
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

  Widget _buildErrorWidget(
    BuildContext context,
    WidgetRef ref,
    Object error,
    AutoDisposeStateNotifierProvider<TvListNotifier, TvListState> provider,
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
              'Could not load TV shows',
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

/// Netflix-style TV show poster card
class _NetflixTvShowCard extends StatelessWidget {
  final TvShow tvShow;
  final String imageBaseUrl;

  const _NetflixTvShowCard({
    required this.tvShow,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final poster = tvShow.posterPath;
    final url = (poster != null && poster.isNotEmpty)
        ? '$imageBaseUrl/w342$poster'
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
