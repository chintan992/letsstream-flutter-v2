import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/shared/widgets/media_card.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';

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
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.recommend_outlined,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'More Like This',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: isLoading
              ? _buildLoading()
              : _buildSimilarList(context, theme),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ShimmerBox(
          width: 120,
          height: 180,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSimilarList(BuildContext context, ThemeData theme) {
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 32),
            const SizedBox(height: 8),
            Text(
              'Failed to load similar titles',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
        ),
      );
    }

    if (similarItems.isEmpty) {
      return const Center(child: Text('No similar titles available'));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: similarItems.length,
      itemBuilder: (context, index) {
        final item = similarItems[index];
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _buildSimilarCard(context, item)
              .animate(delay: Duration(milliseconds: 100 * index))
              .slideX(begin: 0.2, duration: const Duration(milliseconds: 300))
              .fadeIn(),
        );
      },
    );
  }

  Widget _buildSimilarCard(BuildContext context, dynamic item) {
    if (item is Movie) {
      return MediaCard(
        title: item.title,
        imagePath: item.posterPath,
        onTap: () {
          context.pushNamed(
            'movie-detail',
            pathParameters: {'id': item.id.toString()},
            extra: item,
          );
        },
      );
    } else if (item is TvShow) {
      return MediaCard(
        title: item.name,
        imagePath: item.posterPath,
        onTap: () {
          context.pushNamed(
            'tv-detail',
            pathParameters: {'id': item.id.toString()},
            extra: item,
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
