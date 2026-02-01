import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Netflix-style Anime Screen with grid layout and category filters.
class AnimeScreen extends ConsumerStatefulWidget {
  const AnimeScreen({super.key});

  @override
  ConsumerState<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends ConsumerState<AnimeScreen> {
  String _selectedCategory = 'All';

  // Anime categories
  final List<String> _categories = [
    'All',
    'Action',
    'Adventure',
    'Fantasy',
    'Sci-Fi',
    'Romance',
    'Comedy',
  ];

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(tmdbRepositoryProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                  'ANIME',
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
                  preferredSize: const Size.fromHeight(110),
                  child: Column(
                    children: [
                      // Category filter chips
                      _buildCategoryChips(),
                      const SizedBox(height: 8),
                      // Tab bar for Movies/TV
                      TabBar(
                        indicatorColor: NetflixColors.primaryRed,
                        indicatorWeight: 3,
                        labelColor: NetflixColors.textPrimary,
                        unselectedLabelColor: NetflixColors.textSecondary,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: const [
                          Tab(text: 'Movies'),
                          Tab(text: 'TV Shows'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Anime Movies Tab
              _AnimeMoviesGrid(
                future: repo.getAnimeMovies(),
              ),
              // Anime TV Shows Tab
              _AnimeTvGrid(
                future: repo.getAnimeTvShows(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return _NetflixCategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }
}

/// Netflix-style category chip
class _NetflixCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NetflixCategoryChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? NetflixColors.textPrimary
              : NetflixColors.surfaceMedium,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
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

/// Anime Movies Grid
class _AnimeMoviesGrid extends StatelessWidget {
  final Future<List<Movie>> future;

  const _AnimeMoviesGrid({required this.future});

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

    return FutureBuilder<List<Movie>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingGrid();
        }
        if (snapshot.hasError) {
          return EmptyState.error(errorMessage: snapshot.error.toString());
        }
        final movies = snapshot.data ?? [];
        if (movies.isEmpty) {
          return const EmptyState(
            type: EmptyStateType.noResults,
            title: 'No anime movies found',
            message: 'Check back later for new anime content.',
            icon: Icons.movie_outlined,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2 / 3,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _NetflixAnimeCard(
              posterPath: movie.posterPath,
              title: movie.title,
              onTap: () {
                context.pushNamed(
                  'movie-detail',
                  pathParameters: {'id': movie.id.toString()},
                  extra: movie,
                );
              },
              imageBaseUrl: imageBaseUrl,
            );
          },
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
}

/// Anime TV Shows Grid
class _AnimeTvGrid extends StatelessWidget {
  final Future<List<TvShow>> future;

  const _AnimeTvGrid({required this.future});

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

    return FutureBuilder<List<TvShow>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingGrid();
        }
        if (snapshot.hasError) {
          return EmptyState.error(errorMessage: snapshot.error.toString());
        }
        final shows = snapshot.data ?? [];
        if (shows.isEmpty) {
          return const EmptyState(
            type: EmptyStateType.noResults,
            title: 'No anime TV shows found',
            message: 'Check back later for new anime content.',
            icon: Icons.tv_outlined,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2 / 3,
          ),
          itemCount: shows.length,
          itemBuilder: (context, index) {
            final show = shows[index];
            return _NetflixAnimeCard(
              posterPath: show.posterPath,
              title: show.name,
              onTap: () {
                context.pushNamed(
                  'tv-detail',
                  pathParameters: {'id': show.id.toString()},
                  extra: show,
                );
              },
              imageBaseUrl: imageBaseUrl,
            );
          },
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
}

/// Netflix-style anime poster card
class _NetflixAnimeCard extends StatelessWidget {
  final String? posterPath;
  final String title;
  final VoidCallback onTap;
  final String imageBaseUrl;

  const _NetflixAnimeCard({
    required this.posterPath,
    required this.title,
    required this.onTap,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final url = (posterPath != null && posterPath!.isNotEmpty)
        ? '$imageBaseUrl/w342$posterPath'
        : null;

    return GestureDetector(
      onTap: onTap,
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
