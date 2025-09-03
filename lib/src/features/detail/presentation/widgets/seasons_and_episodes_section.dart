import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/features/detail/application/season_episodes_notifier.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

    // Find the last season with episodes or the most recent season
    final lastSeason = widget.seasons.last;
    if (lastSeason.seasonNumber > 0) {
      return lastSeason.seasonNumber;
    }

    // Fallback: find the highest season number
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
    final theme = Theme.of(context);
    final episodesState = ref.watch(
      seasonEpisodesNotifierProvider((
        tvId: widget.tvId,
        seasonNumber: _selectedSeason,
      )),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(theme),
        const SizedBox(height: 16),
        _buildSeasonSelector(theme),
        const SizedBox(height: 16),
        _buildEpisodesList(context, theme, episodesState),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.tv_outlined,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Episodes',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonSelector(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.seasons.length,
        itemBuilder: (context, index) {
          final season = widget.seasons[index];
          final isSelected = season.seasonNumber == _selectedSeason;
          return Padding(
            padding: EdgeInsets.only(right: 8, left: index == 0 ? 0 : 0),
            child: FilterChip(
              label: Text(
                season.name.isNotEmpty
                    ? season.name
                    : 'Season ${season.seasonNumber}',
                style: isSelected
                    ? TextStyle(color: theme.colorScheme.onPrimary)
                    : null,
              ),
              selected: isSelected,
              onSelected: (sel) {
                setState(() => _selectedSeason = season.seasonNumber);
              },
              selectedColor: theme.colorScheme.primary,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodesList(
    BuildContext context,
    ThemeData theme,
    SeasonEpisodesState state,
  ) {
    if (state.isLoading) {
      return _buildLoadingEpisodes();
    }

    if (state.error != null) {
      return _buildError(theme, state.error.toString());
    }

    if (state.episodes.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.episodes.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final ep = state.episodes[i];
        return _buildEpisodeCard(context, theme, ep);
      },
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
                borderRadius: BorderRadius.circular(8),
                child: const ShimmerBox(width: 120, height: 68),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: 100, height: 16),
                    const SizedBox(height: 8),
                    const ShimmerBox(width: double.infinity, height: 14),
                    const SizedBox(height: 4),
                    const ShimmerBox(width: 150, height: 14),
                  ],
                ),
              ),
            ],
          ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn(),
        );
      }),
    );
  }

  Widget _buildError(ThemeData theme, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Failed to load episodes: $error',
        style: TextStyle(color: theme.colorScheme.onErrorContainer),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'No episodes available',
        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildEpisodeCard(
    BuildContext context,
    ThemeData theme,
    EpisodeSummary ep,
  ) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final thumb = ep.stillPath != null && ep.stillPath!.isNotEmpty
        ? '$imageBaseUrl/w300${ep.stillPath}'
        : null;

    Color ratingColor(double rating) {
      if (rating >= 8.0) return Colors.green;
      if (rating >= 6.0) return Colors.orange;
      return Colors.red;
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.pushNamed(
            'episode-detail',
            pathParameters: {
              'id': widget.tvId.toString(),
              'season': _selectedSeason.toString(),
              'ep': ep.episodeNumber.toString(),
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 120,
                  height: 68,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: thumb != null
                      ? CachedNetworkImage(
                          imageUrl: thumb,
                          width: 120,
                          height: 68,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ShimmerBox(width: 120, height: 68),
                          errorWidget: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image_outlined, size: 24),
                        )
                      : const Icon(Icons.movie_outlined, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${ep.episodeNumber}',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ep.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (ep.airDate != null) ...[
                      Text(
                        ep.airDate!
                            .toLocal()
                            .toIso8601String()
                            .split('T')
                            .first,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (ep.voteAverage > 0) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: ratingColor(ep.voteAverage),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ep.voteAverage.toStringAsFixed(1),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (ep.overview != null && ep.overview!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        ep.overview!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
