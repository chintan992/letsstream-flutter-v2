import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/features/detail/application/season_episodes_notifier.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Netflix-style episodes section with season selector
class SeasonsAndEpisodesSection extends ConsumerStatefulWidget {
  final int tvId;
  final List<SeasonSummary> seasons;

  const SeasonsAndEpisodesSection({
    super.key,
    required this.tvId,
    required this.seasons,
  });

  @override
  ConsumerState<SeasonsAndEpisodesSection> createState() =>
      _SeasonsAndEpisodesSectionState();
}

class _SeasonsAndEpisodesSectionState
    extends ConsumerState<SeasonsAndEpisodesSection> {
  late int _selectedSeason;

  @override
  void initState() {
    super.initState();
    _selectedSeason = _getInitialSeason();
  }

  int _getInitialSeason() {
    if (widget.seasons.isEmpty) {
      return 1;
    }

    final lastSeason = widget.seasons.last;
    if (lastSeason.seasonNumber > 0) {
      return lastSeason.seasonNumber;
    }

    final validSeasons = widget.seasons
        .where((season) => season.seasonNumber > 0)
        .toList();

    if (validSeasons.isNotEmpty) {
      return validSeasons
          .map((season) => season.seasonNumber)
          .reduce((a, b) => a > b ? a : b);
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final episodesState = ref.watch(
      seasonEpisodesNotifierProvider((
        tvId: widget.tvId,
        seasonNumber: _selectedSeason,
      ),),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Episodes header with season selector dropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Episodes',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: NetflixColors.textPrimary,
              ),
            ),
            _buildSeasonDropdown(),
          ],
        ),
        const SizedBox(height: 16),
        _buildEpisodesList(context, episodesState),
      ],
    );
  }

  Widget _buildSeasonDropdown() {
    final validSeasons = widget.seasons
        .where((s) => s.seasonNumber > 0)
        .toList();

    if (validSeasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: NetflixColors.surfaceMedium,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: NetflixColors.transparent,
        child: PopupMenuButton<int>(
          initialValue: _selectedSeason,
          onSelected: (seasonNumber) {
            setState(() => _selectedSeason = seasonNumber);
          },
          offset: const Offset(0, 40),
          color: NetflixColors.surfaceMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Season $_selectedSeason',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: NetflixColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: NetflixColors.textPrimary,
                  size: 18,
                ),
              ],
            ),
          ),
          itemBuilder: (context) {
            return validSeasons.map((season) {
              return PopupMenuItem<int>(
                value: season.seasonNumber,
                child: Text(
                  season.name.isNotEmpty
                      ? season.name
                      : 'Season ${season.seasonNumber}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: NetflixColors.textPrimary,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Widget _buildEpisodesList(
    BuildContext context,
    SeasonEpisodesState state,
  ) {
    if (state.isLoading) {
      return _buildLoadingEpisodes();
    }

    if (state.error != null) {
      return _buildError(state.error.toString());
    }

    if (state.episodes.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: state.episodes.asMap().entries.map((entry) {
        final index = entry.key;
        final ep = entry.value;
        return _buildEpisodeCard(context, ep, index)
            .animate(delay: Duration(milliseconds: 50 * index))
            .fadeIn(duration: const Duration(milliseconds: 300))
            .slideX(begin: 0.1, duration: const Duration(milliseconds: 300));
      }).toList(),
    );
  }

  Widget _buildLoadingEpisodes() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const ShimmerBox(width: 120, height: 68),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 100, height: 16),
                    SizedBox(height: 8),
                    ShimmerBox(width: double.infinity, height: 14),
                    SizedBox(height: 4),
                    ShimmerBox(width: 150, height: 14),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildError(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NetflixColors.surfaceDark,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Failed to load episodes: $error',
        style: GoogleFonts.inter(
          fontSize: 14,
          color: NetflixColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NetflixColors.surfaceDark,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'No episodes available',
        style: GoogleFonts.inter(
          fontSize: 14,
          color: NetflixColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEpisodeCard(
    BuildContext context,
    EpisodeSummary ep,
    int index,
  ) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final thumb = ep.stillPath != null && ep.stillPath!.isNotEmpty
        ? '$imageBaseUrl/w300${ep.stillPath}'
        : null;

    return InkWell(
      onTap: () {
        context.pushNamed(
          'watch-tv',
          pathParameters: {
            'id': widget.tvId.toString(),
            'season': _selectedSeason.toString(),
            'ep': ep.episodeNumber.toString(),
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: NetflixColors.surfaceMedium,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Episode thumbnail with play overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 120,
                    height: 68,
                    color: NetflixColors.surfaceDark,
                    child: thumb != null
                        ? CachedNetworkImage(
                            imageUrl: thumb,
                            width: 120,
                            height: 68,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const ShimmerBox(width: 120, height: 68),
                            errorWidget: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image_outlined,
                                  size: 24,
                                  color: NetflixColors.textSecondary,
                                ),
                          )
                        : const Icon(
                            Icons.movie_outlined,
                            size: 24,
                            color: NetflixColors.textSecondary,
                          ),
                  ),
                ),
                // Play icon overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: NetflixColors.blackWithOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: NetflixColors.textPrimary,
                      size: 32,
                    ),
                  ),
                ),
                // Episode number badge
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: NetflixColors.blackWithOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      '${ep.episodeNumber}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: NetflixColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            
            // Episode info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ep.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: NetflixColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (ep.voteAverage > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: NetflixColors.success,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              ep.voteAverage.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: NetflixColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (ep.overview != null && ep.overview!.isNotEmpty)
                    Text(
                      ep.overview!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: NetflixColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
