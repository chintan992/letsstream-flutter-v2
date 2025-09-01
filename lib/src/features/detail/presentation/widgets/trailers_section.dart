import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailersSection extends StatelessWidget {
  final List<Video> videos;
  final bool isLoading;
  final Object? error;

  const TrailersSection({
    super.key,
    required this.videos,
    required this.isLoading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.play_circle_outline,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Trailers & Videos',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: isLoading ? _buildLoading() : _buildVideoList(context, theme),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ShimmerBox(
          width: 200,
          height: 120,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildVideoList(BuildContext context, ThemeData theme) {
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 32),
            const SizedBox(height: 8),
            Text(
              'Failed to load trailers',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
        ),
      );
    }

    final youtubeVideos = videos
        .where((v) => v.site.toLowerCase() == 'youtube')
        .toList();

    if (youtubeVideos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'No trailers available',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: youtubeVideos.length,
      itemBuilder: (context, index) {
        final video = youtubeVideos[index];
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _buildTrailerCard(context, theme, video)
              .animate(delay: Duration(milliseconds: 100 * index))
              .slideX(begin: 0.2, duration: const Duration(milliseconds: 300))
              .fadeIn(),
        );
      },
    );
  }

  Widget _buildTrailerCard(BuildContext context, ThemeData theme, Video video) {
    final thumbUrl =
        'https://img.youtube.com/vi/${video.key}/maxresdefault.jpg';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final url = Uri.parse('https://www.youtube.com/watch?v=${video.key}');
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: thumbUrl,
                      width: 200,
                      height: 112,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const ShimmerBox(width: 200, height: 112),
                      errorWidget: (context, url, error) => Container(
                        width: 200,
                        height: 112,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  video.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
