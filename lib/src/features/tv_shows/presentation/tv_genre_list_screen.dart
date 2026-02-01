import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Netflix-style TV Genre List Screen.
class TvGenreListScreen extends ConsumerStatefulWidget {
  final int genreId;
  final String genreName;

  const TvGenreListScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  ConsumerState<TvGenreListScreen> createState() => _TvGenreListScreenState();
}

class _TvGenreListScreenState extends ConsumerState<TvGenreListScreen> {
  final _scroll = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasMore = true;
  final List<TvShow> _items = [];
  late Future<void> _initialLoad;

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
    _initialLoad = _load();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(tmdbRepositoryProvider);
    final pageItems = await repo.getTvByGenre(widget.genreId, page: _page);
    if (mounted) {
      setState(() {
        _items.addAll(pageItems);
        _hasMore = pageItems.isNotEmpty;
      });
    }
  }

  void _onScroll() {
    if (!_hasMore) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300 && !_loadingMore) {
      _loadingMore = true;
      _page += 1;
      _load().whenComplete(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    
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
          onRefresh: () async {
            _page = 1;
            _hasMore = true;
            _items.clear();
            await _load();
          },
          color: NetflixColors.primaryRed,
          backgroundColor: NetflixColors.surfaceDark,
          child: FutureBuilder<void>(
            future: _initialLoad,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && _items.isEmpty) {
                return _buildLoadingGrid();
              }
              if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error!);
              }
              if (_items.isEmpty) {
                return const EmptyState(
                  type: EmptyStateType.noResults,
                  title: 'No shows found',
                  message: 'Try a different genre or check back later.',
                  icon: Icons.tv_outlined,
                );
              }

              final showFooter = _loadingMore || _hasMore;
              final count = _items.length + (showFooter ? 1 : 0);
              
              return GridView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2/3,
                ),
                itemCount: count,
                itemBuilder: (context, index) {
                  if (index >= _items.length) {
                    if (_loadingMore) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: NetflixColors.primaryRed,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    if (_hasMore) {
                      return Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (_loadingMore || !_hasMore) return;
                            _loadingMore = true;
                            _page += 1;
                            _load().whenComplete(() => _loadingMore = false);
                          },
                          icon: const Icon(Icons.expand_more),
                          label: const Text('Load more'),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  final tvShow = _items[index];
                  return _NetflixTvShowCard(
                    tvShow: tvShow,
                    imageBaseUrl: imageBaseUrl,
                  );
                },
              );
            },
          ),
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
          
          return _NetflixFilterChip(
            label: filter,
            isSelected: false,
            onTap: () {
              // Handle filter tap
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2/3,
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

  Widget _buildErrorWidget(Object error) {
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
              onPressed: () {
                _page = 1;
                _hasMore = true;
                _items.clear();
                _load();
              },
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
