import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/movie.dart';
import '../../../../core/models/tv_show.dart';
import '../../../../shared/theme/netflix_colors.dart';
import '../../../../shared/theme/netflix_typography.dart';
import '../../../../shared/widgets/shimmer_box.dart';

/// A Netflix-style hero carousel widget.
///
/// Features:
/// - Full-width hero with backdrop image
/// - Netflix gradient overlay (transparent to black)
/// - Auto-play with 15-second intervals
/// - Title with Bebas Neue typography
/// - Movie/TV metadata with rating
/// - Pagination dots
/// - Desktop navigation arrows
class HeroCarousel extends StatefulWidget {
  final List<dynamic> items;
  final ScrollController? scrollController;
  final void Function(dynamic item)? onTap;

  const HeroCarousel({
    super.key,
    required this.items,
    this.scrollController,
    this.onTap,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;
    final heroHeight = size.height * 0.65;
    final isDesktop = size.width > 900;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        children: [
          // Carousel
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: widget.items.length,
            options: CarouselOptions(
              height: heroHeight,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 15),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final item = widget.items[index];
              return _buildCarouselItem(context, item, heroHeight);
            },
          ),

          // Netflix gradient overlay at top for app bar blending
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    NetflixColors.backgroundBlack,
                    NetflixColors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Pagination dots - Netflix style
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.items.asMap().entries.map((entry) {
                final isActive = _currentIndex == entry.key;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 24.0 : 8.0,
                  height: 4.0,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isActive
                        ? NetflixColors.textPrimary
                        : NetflixColors.textSecondary.withValues(alpha: 0.5),
                  ),
                );
              }).toList(),
            ),
          ),

          // Left navigation button (desktop only)
          if (isDesktop)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavButton(Icons.arrow_back_ios_new, () {
                  _carouselController.previousPage();
                }),
              ),
            ),

          // Right navigation button (desktop only)
          if (isDesktop)
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavButton(Icons.arrow_forward_ios, () {
                  _carouselController.nextPage();
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: NetflixColors.blackWithOpacity(0.5),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Icon(
            icon,
            color: NetflixColors.textPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(
    BuildContext context,
    dynamic item,
    double height,
  ) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final posterPath = _getPosterPath(item);
    final backdropPath = _getBackdropPath(item);

    // Use backdrop if available, otherwise poster
    final imagePath = backdropPath ?? posterPath;
    final imageUrl =
        imagePath != null ? '$imageBaseUrl/original$imagePath' : null;

    final title = _getTitle(item);
    final isMovie = item is Movie;
    final year = _getYear(item);
    final voteAverage = _getVoteAverage(item);
    final overview = _getOverview(item);

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(item);
        } else {
          _navigateToDetails(context, item);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          _buildBackgroundImage(imageUrl, height),

          // Netflix gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  NetflixColors.transparent,
                  NetflixColors.transparent,
                  NetflixColors.backgroundBlack,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Content
          Positioned(
            left: 24,
            right: 24,
            bottom: 80,
            child: _buildContent(
              context,
              title,
              isMovie,
              year,
              voteAverage,
              overview,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(String? imageUrl, double height) {
    if (imageUrl == null) {
      return Container(
        color: NetflixColors.surfaceMedium,
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 64,
            color: NetflixColors.textSecondary,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      height: height,
      width: double.infinity,
      memCacheWidth: 1080,
      placeholder: (context, url) => const ShimmerBox(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.zero,
      ),
      errorWidget: (context, url, error) => Container(
        color: NetflixColors.surfaceMedium,
        child: const Center(
          child: Icon(
            Icons.error_outline,
            size: 64,
            color: NetflixColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    String title,
    bool isMovie,
    String? year,
    double? rating,
    String? overview,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title - Netflix style with Bebas Neue
        Text(
          title,
          style: NetflixTypography.heroTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 12),

        // Metadata row - Netflix style
        Row(
          children: [
            if (year != null) ...[
              Text(
                year,
                style: NetflixTypography.textTheme.bodyMedium?.copyWith(
                  color: NetflixColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: NetflixColors.surfaceMedium,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isMovie ? 'Movie' : 'TV Show',
                style: NetflixTypography.textTheme.bodySmall?.copyWith(
                  color: NetflixColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (rating != null && rating > 0) ...[
              const SizedBox(width: 12),
              const Icon(
                Icons.star,
                color: NetflixColors.warning,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: NetflixTypography.textTheme.bodyMedium?.copyWith(
                  color: NetflixColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),

        // Overview text (optional, 2 lines max)
        if (overview != null && overview.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            overview,
            style: NetflixTypography.textTheme.bodyMedium?.copyWith(
              color: NetflixColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  void _navigateToDetails(BuildContext context, dynamic item) {
    final id = _getId(item);
    final isMovie = item is Movie;

    if (isMovie) {
      context.pushNamed(
        'movie-detail',
        pathParameters: {'id': id.toString()},
        extra: item,
      );
    } else {
      context.pushNamed(
        'tv-detail',
        pathParameters: {'id': id.toString()},
        extra: item,
      );
    }
  }

  // Helper methods
  String? _getPosterPath(dynamic item) {
    if (item is Movie) return item.posterPath;
    if (item is TvShow) return item.posterPath;
    return null;
  }

  String? _getBackdropPath(dynamic item) {
    if (item is Movie) return item.backdropPath;
    if (item is TvShow) return item.backdropPath;
    return null;
  }

  String _getTitle(dynamic item) {
    if (item is Movie) return item.title;
    if (item is TvShow) return item.name;
    return 'Unknown';
  }

  String? _getOverview(dynamic item) {
    if (item is Movie) return item.overview;
    if (item is TvShow) return item.overview;
    return null;
  }

  int _getId(dynamic item) {
    if (item is Movie) return item.id;
    if (item is TvShow) return item.id;
    return 0;
  }

  String? _getYear(dynamic item) {
    try {
      if (item is Movie && item.releaseDate != null) {
        return item.releaseDate!.year.toString();
      }
      if (item is TvShow && item.firstAirDate != null) {
        return item.firstAirDate!.year.toString();
      }
    } catch (_) {}
    return null;
  }

  double? _getVoteAverage(dynamic item) {
    if (item is Movie) return item.voteAverage;
    if (item is TvShow) return item.voteAverage;
    return null;
  }
}
