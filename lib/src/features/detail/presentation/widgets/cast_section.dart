import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';

class CastSection extends StatelessWidget {
  final List<CastMember> cast;
  final bool isLoading;
  final Object? error;

  const CastSection({
    super.key,
    required this.cast,
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
              Icons.people_outline,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Top Billed Cast',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: isLoading ? _buildLoading() : _buildCastList(context, theme),
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
        child: Column(
          children: [
            ShimmerBox(
              width: 80,
              height: 80,
              borderRadius: BorderRadius.circular(40),
            ),
            const SizedBox(height: 8),
            const ShimmerBox(width: 80, height: 12),
            const SizedBox(height: 4),
            const ShimmerBox(width: 60, height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCastList(BuildContext context, ThemeData theme) {
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 32),
            const SizedBox(height: 8),
            Text(
              'Failed to load cast',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
        ),
      );
    }

    if (cast.isEmpty) {
      return const Center(child: Text('No cast available'));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cast.length,
      itemBuilder: (context, index) {
        final member = cast[index];
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _buildCastCard(context, theme, member)
              .animate(delay: Duration(milliseconds: 100 * index))
              .slideY(begin: 0.2, duration: const Duration(milliseconds: 300))
              .fadeIn(),
        );
      },
    );
  }

  Widget _buildCastCard(
    BuildContext context,
    ThemeData theme,
    CastMember member,
  ) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final imageUrl =
        (member.profilePath != null && member.profilePath!.isNotEmpty)
        ? '$imageBaseUrl/w185${member.profilePath}'
        : null;

    return SizedBox(
      width: 110,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Icon(
                      Icons.person_outline,
                      size: 32,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (member.character != null && member.character!.isNotEmpty)
            Text(
              member.character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
