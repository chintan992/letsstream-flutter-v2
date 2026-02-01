import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/features/detail/application/detail_notifier.dart';
import 'package:lets_stream/src/features/detail/presentation/widgets/cast_section.dart';
import 'package:lets_stream/src/features/detail/presentation/widgets/seasons_and_episodes_section.dart';
import 'package:lets_stream/src/features/detail/presentation/widgets/similar_section.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:go_router/go_router.dart';

/// Netflix-style detail screen with full-bleed hero image
/// Features:
/// - 60% height hero with gradient overlay
/// - Bebas Neue title typography
/// - Metadata badges (Year, Rating, Duration, Quality)
/// - Large red Play button
/// - Download and My List buttons
/// - Synopsis, Cast, More Like This sections
/// - Episodes section for TV shows
class EnhancedDetailScreen extends ConsumerWidget {
  final Object? item; // Movie or TvShow

  const EnhancedDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(detailNotifierProvider(item));
    final size = MediaQuery.of(context).size;
    final heroHeight = size.height * 0.6;

    return Scaffold(
      backgroundColor: NetflixColors.backgroundBlack,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Section (60% height)
              _buildHeroSection(context, item, heroHeight),
              
              // Content Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action Buttons (Play, Download, My List)
                    _buildActionButtons(context, item),
                    
                    // Synopsis
                    _buildSynopsis(context, item),
                    
                    // Cast Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CastSection(
                        cast: detailState.cast,
                        isLoading: detailState.isLoading,
                        error: detailState.error,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Episodes Section (TV Shows only)
                    if (item is TvShow) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SeasonsAndEpisodesSection(
                          tvId: (item as TvShow).id,
                          seasons: detailState.seasons,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    
                    // More Like This
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SimilarSection(
                        similarItems: detailState.similar,
                        isLoading: detailState.isLoading,
                        error: detailState.error,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
          
          // Top gradient for status bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    NetflixColors.blackWithOpacity(0.7),
                    NetflixColors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: _buildBackButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, Object? item, double height) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final backdropPath =
        item is Movie ? item.backdropPath : (item as TvShow).backdropPath;
    final title = item is Movie ? item.title : (item as TvShow).name;
    final backdropUrl = (backdropPath != null && backdropPath.isNotEmpty)
        ? '$imageBaseUrl/original$backdropPath'
        : null;

    // Metadata
    final year = item is Movie
        ? (item.releaseDate?.year.toString() ?? '')
        : (item is TvShow ? (item.firstAirDate?.year.toString() ?? '') : '');
    final voteAverage =
        item is Movie ? item.voteAverage : (item as TvShow).voteAverage;
    final rating = voteAverage.toStringAsFixed(1);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (backdropUrl != null)
              CachedNetworkImage(
                imageUrl: backdropUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                errorWidget: (context, url, error) => Container(
                  color: NetflixColors.backgroundBlackDark,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    size: 50,
                    color: NetflixColors.textSecondary,
                  ),
                ),
              )
            else
              Container(
                color: NetflixColors.backgroundBlackDark,
                child: const Center(
                  child: Icon(
                    Icons.movie_outlined,
                    size: 80,
                    color: NetflixColors.textSecondary,
                  ),
                ),
              ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    NetflixColors.transparent,
                    NetflixColors.blackWithOpacity(0.3),
                    NetflixColors.blackWithOpacity(0.6),
                    NetflixColors.backgroundBlack,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),

            // Content at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title with Bebas Neue
                  Text(
                    title,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: NetflixColors.textPrimary,
                      letterSpacing: 1.0,
                      height: 1.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ).animate().fadeIn(duration: 400.ms).slideY(
                    begin: 0.2,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Metadata Row
                  _buildMetadataRow(year, rating, item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String year, String rating, Object? item) {
    final List<Widget> metadataItems = [];

    // Year badge
    if (year.isNotEmpty) {
      metadataItems.add(
        _buildMetadataBadge(
          year,
          isBold: true,
        ),
      );
    }

    // Rating badge with star
    metadataItems.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: NetflixColors.success,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            rating,
            style: const TextStyle(
              color: NetflixColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    // Duration/Seasons badge
    if (item is Movie) {
      metadataItems.add(
        _buildMetadataBadge(
          '2h 15m', // Placeholder - actual duration would come from API
        ),
      );
    } else if (item is TvShow) {
      metadataItems.add(
        _buildMetadataBadge(
          item.voteCount > 0 ? '${(item.voteCount / 1000).toStringAsFixed(0)}K' : 'New',
        ),
      );
    }

    // HD badge
    metadataItems.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: NetflixColors.textTertiary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'HD',
          style: TextStyle(
            color: NetflixColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

            // Genre tags (if available)
    final genres = item is Movie ? item.genreIds : (item as TvShow).genreIds;
    if (genres != null && genres.isNotEmpty) {
      metadataItems.add(
        _buildMetadataBadge(
          'Action', // Placeholder - map genreIds to names
          isSecondary: true,
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: metadataItems,
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildMetadataBadge(String text, {
    bool isBold = false,
    bool isSecondary = false,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: isSecondary
            ? NetflixColors.textSecondary
            : NetflixColors.textPrimary,
        fontSize: 14,
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Object? item) {
    final id = item is Movie ? item.id : (item as TvShow).id;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Play Button (Full Width, Red)
          _buildPlayButton(context, item, id),
          const SizedBox(height: 12),
          
          // Download Button (Gray)
          _buildDownloadButton(context),
          const SizedBox(height: 12),
          
          // My List Button
          _buildMyListButton(context, item),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildPlayButton(BuildContext context, Object? item, int id) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          if (item is Movie) {
            context.pushNamed(
              'watch-movie',
              pathParameters: {'id': id.toString()},
            );
          } else if (item is TvShow) {
            context.pushNamed(
              'watch-tv',
              pathParameters: {
                'id': id.toString(),
                'season': '1',
                'ep': '1',
              },
            );
          }
        },
        icon: const Icon(
          Icons.play_arrow,
          color: NetflixColors.textPrimary,
          size: 28,
        ),
        label: Text(
          'Play',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: NetflixColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: NetflixColors.primaryRed,
          foregroundColor: NetflixColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download feature coming soon!'),
              duration: Duration(seconds: 2),
              backgroundColor: NetflixColors.surfaceDark,
            ),
          );
        },
        icon: const Icon(
          Icons.download,
          color: NetflixColors.textPrimary,
          size: 24,
        ),
        label: Text(
          'Download',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: NetflixColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: NetflixColors.surfaceMedium,
          foregroundColor: NetflixColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildMyListButton(BuildContext context, Object? item) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added to My List',
              style: GoogleFonts.inter(color: NetflixColors.textPrimary),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: NetflixColors.surfaceDark,
          ),
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: NetflixColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'My List',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: NetflixColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSynopsis(BuildContext context, Object? item) {
    final overview = item is Movie ? item.overview : (item as TvShow).overview;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            overview,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: NetflixColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Cast names (placeholder - would come from cast data)
          Text(
            'Starring: Featured Cast',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: NetflixColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          
          // Creator info for TV shows
          if (item is TvShow) ...[
            Text(
              'Creator: Show Creator',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: NetflixColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NetflixColors.blackWithOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: NetflixColors.textPrimary,
          size: 24,
        ),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }
}
