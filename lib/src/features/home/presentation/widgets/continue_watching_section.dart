import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/widgets/shimmer_box.dart';
import '../../../../shared/widgets/desktop_scroll_wrapper.dart';
import '../../application/watch_progress_service.dart';

/// A "Continue Watching" section for the home screen.
///
/// Displays media that the user has started watching but not completed.
/// Shows progress bars on each item indicating how much is left.
class ContinueWatchingSection extends ConsumerStatefulWidget {
  const ContinueWatchingSection({super.key});

  @override
  ConsumerState<ContinueWatchingSection> createState() =>
      _ContinueWatchingSectionState();
}

class _ContinueWatchingSectionState
    extends ConsumerState<ContinueWatchingSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final continueWatchingAsync = ref.watch(continueWatchingProvider);

    return continueWatchingAsync.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();

        return _buildSection(context, items);
      },
      loading: () => _buildShimmer(context),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(BuildContext context, List<WatchProgress> items) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final cardWidth = isDesktop ? 280.0 : 200.0;
    final cardHeight = isDesktop ? 170.0 : 120.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with blue accent
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Continue Watching',
                    style: TextStyle(
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: isDesktop ? 30 : 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Horizontal list
        SizedBox(
          height: cardHeight + 60, // Extra space for progress info
          child: DesktopScrollWrapper(
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return _ContinueWatchingCard(
                  progress: item,
                  width: cardWidth,
                  height: cardHeight,
                  onTap: () => _navigateToPlayer(context, item),
                  onDismiss: () => _dismissItem(item),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final cardWidth = isDesktop ? 280.0 : 200.0;
    final cardHeight = isDesktop ? 170.0 : 120.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: ShimmerBox(
            width: 180,
            height: isDesktop ? 26 : 22,
          ),
        ),
        SizedBox(
          height: cardHeight + 60,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ShimmerBox(width: cardWidth, height: cardHeight),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToPlayer(BuildContext context, WatchProgress item) {
    if (item.contentType == 'movie') {
      context.pushNamed(
        'movie-player',
        pathParameters: {'id': item.contentId},
        queryParameters: {
          'position': item.position.inSeconds.toString(),
        },
      );
    } else {
      context.pushNamed(
        'tv-player',
        pathParameters: {
          'id': item.contentId,
          'season': item.seasonNumber.toString(),
          'episode': item.episodeNumber.toString(),
        },
        queryParameters: {
          'position': item.position.inSeconds.toString(),
        },
      );
    }
  }

  void _dismissItem(WatchProgress item) {
    // Remove from continue watching
    ref.read(watchProgressServiceProvider).removeProgress(
      item.contentId,
      episodeId: item.episodeId,
    );
    // Refresh the provider
    ref.invalidate(continueWatchingProvider);
  }
}

/// A card showing continue watching item with progress bar
class _ContinueWatchingCard extends StatelessWidget {
  final WatchProgress progress;
  final double width;
  final double height;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _ContinueWatchingCard({
    required this.progress,
    required this.width,
    required this.height,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageBaseUrl = const String.fromEnvironment(
      'TMDB_IMAGE_BASE_URL',
      defaultValue: 'https://image.tmdb.org/t/p',
    );
    final imageUrl = progress.posterPath != null
        ? '$imageBaseUrl/w500${progress.posterPath}'
        : null;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card with image and progress
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Thumbnail
                Container(
                  width: width,
                  height: height,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const ShimmerBox(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(Icons.image_not_supported, size: 40),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.movie, size: 40),
                        ),
                ),

                // Gradient overlay for better visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                // Play button overlay
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Progress bar at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress background
                      Container(
                        height: 4,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      // Progress fill
                      Container(
                        height: 4,
                        width: width * progress.progressPercent,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),

                // Dismiss button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: onDismiss,
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            progress.title ?? 'Unknown',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Time remaining
          Text(
            progress.remainingTime,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
