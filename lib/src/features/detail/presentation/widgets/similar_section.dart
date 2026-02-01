import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';

/// Netflix-style "More Like This" section with grid layout
class SimilarSection extends StatelessWidget {
  final List<dynamic> similarItems;
  final bool isLoading;
  final Object? error;

  const SimilarSection({
    super.key,
    required this.similarItems,
    required this.isLoading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Like This',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: NetflixColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        isLoading ? _buildLoading() : _buildSimilarGrid(context),
      ],
    );
  }

  Widget _buildLoading() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => ShimmerBox(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSimilarGrid(BuildContext context) {
    if (error != null) {
      return Center(
        child: Text(
          'Failed to load similar titles',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: NetflixColors.textSecondary,
          ),
        ),
      );
    }

    if (similarItems.isEmpty) {
      return Center(
        child: Text(
          'No similar titles available',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: NetflixColors.textSecondary,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: similarItems.length > 9 ? 9 : similarItems.length,
      itemBuilder: (context, index) {
        final item = similarItems[index];
        return _buildSimilarCard(context, item)
            .animate(delay: Duration(milliseconds: 50 * index))
            .fadeIn(duration: const Duration(milliseconds: 300))
            .scale(
              begin: const Offset(0.95, 0.95),
              duration: const Duration(milliseconds: 300),
            );
      },
    );
  }

  Widget _buildSimilarCard(BuildContext context, dynamic item) {
    const String imageBaseUrl = String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );

    String title;
    String? posterPath;
    int id;
    bool isMovie;

    if (item is Movie) {
      title = item.title;
      posterPath = item.posterPath;
      id = item.id;
      isMovie = true;
    } else if (item is TvShow) {
      title = item.name;
      posterPath = item.posterPath;
      id = item.id;
      isMovie = false;
    } else {
      return const SizedBox.shrink();
    }

    final fullPosterUrl = (posterPath != null && posterPath.isNotEmpty)
        ? '$imageBaseUrl/w342$posterPath'
        : null;

    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: NetflixColors.surfaceDark,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (fullPosterUrl != null)
              Image.network(
                fullPosterUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return ShimmerBox(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.circular(4),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: NetflixColors.surfaceDark,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: NetflixColors.textSecondary,
                  ),
                ),
              )
            else
              Container(
                color: NetflixColors.surfaceDark,
                child: const Icon(
                  Icons.movie_outlined,
                  color: NetflixColors.textSecondary,
                ),
              ),
            
            // Gradient overlay at bottom for text readability
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      NetflixColors.transparent,
                      NetflixColors.blackWithOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            
            // Title at bottom
            Positioned(
              left: 6,
              right: 6,
              bottom: 6,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: NetflixColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
