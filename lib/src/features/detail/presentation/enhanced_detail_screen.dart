import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/features/detail/application/detail_notifier.dart';
import 'package:lets_stream/src/features/detail/presentation/widgets/cast_section.dart';
import 'package:lets_stream/src/features/detail/presentation/widgets/seasons_and_episodes_section.dart';
import 'package:lets_stream/src/features/detail/presentation/widgets/similar_section.dart';
import 'package:lets_stream/src/features/detail/presentation/widgets/trailers_section.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:go_router/go_router.dart';

class EnhancedDetailScreen extends ConsumerWidget {
  final Object? item; // Movie or TvShow

  const EnhancedDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(detailNotifierProvider(item));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, item),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, item),
                  const SizedBox(height: 24),
                  _buildOverview(context, item),
                  const SizedBox(height: 32),
                  TrailersSection(
                    videos: detailState.videos,
                    isLoading: detailState.isLoading,
                    error: detailState.error,
                  ),
                  const SizedBox(height: 32),
                  CastSection(
                    cast: detailState.cast,
                    isLoading: detailState.isLoading,
                    error: detailState.error,
                  ),
                  const SizedBox(height: 32),
                  if (item is TvShow) ...[
                    SeasonsAndEpisodesSection(
                      tvId: (item as TvShow).id,
                      seasons: detailState.seasons,
                    ),
                    const SizedBox(height: 32),
                  ],
                  SimilarSection(
                    similarItems: detailState.similar,
                    isLoading: detailState.isLoading,
                    error: detailState.error,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Object? item) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final backdropPath = item is Movie
        ? item.backdropPath
        : (item as TvShow).backdropPath;
    final title = item is Movie ? item.title : (item as TvShow).name;
    final backdropUrl = (backdropPath != null && backdropPath.isNotEmpty)
        ? '$imageBaseUrl/w1280$backdropPath'
        : null;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (backdropUrl != null)
              CachedNetworkImage(
                imageUrl: backdropUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined, size: 50),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Object? item) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final posterPath = item is Movie
        ? item.posterPath
        : (item as TvShow).posterPath;
    final title = item is Movie ? item.title : (item as TvShow).name;
    final id = item is Movie ? item.id : (item as TvShow).id;
    final voteAverage = item is Movie
        ? item.voteAverage
        : (item as TvShow).voteAverage;
    final subtitle = item is Movie
        ? (item.releaseDate != null
              ? 'Release: ${item.releaseDate!.toLocal().toIso8601String().split('T').first}'
              : '')
        : (item is TvShow
              ? (item.firstAirDate != null
                    ? 'First air: ${item.firstAirDate!.toLocal().toIso8601String().split('T').first}'
                    : '')
              : '');

    final fullPosterUrl = (posterPath != null && posterPath.isNotEmpty)
        ? '$imageBaseUrl/w500$posterPath'
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fullPosterUrl != null)
          Hero(
            tag: 'poster_$id',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 180,
                child: CachedNetworkImage(
                  imageUrl: fullPosterUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const ShimmerBox(width: 120, height: 180),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Watch Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
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
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    final filled = index < (voteAverage / 2).floor();
                    return Icon(
                      filled ? Icons.star : Icons.star_outline,
                      color: filled ? Colors.amber : Colors.grey,
                      size: 20,
                    ).animate().scale().fadeIn();
                  }),
                  const SizedBox(width: 8),
                  Text(
                    voteAverage.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverview(BuildContext context, Object? item) {
    final overview = item is Movie ? item.overview : (item as TvShow).overview;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          overview,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}
