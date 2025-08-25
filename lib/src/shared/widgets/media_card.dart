import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/theme/tokens.dart';

class MediaCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;

  const MediaCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final String? fullImageUrl =
        (imagePath != null && imagePath!.isNotEmpty) ? '$imageBaseUrl/w500$imagePath' : null;

    Widget imageWidget;
    if (fullImageUrl != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: fullImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const ShimmerBox(width: double.infinity, height: double.infinity),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.error),
        ),
      );
    } else {
      imageWidget = Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      );
    }

    return Semantics(
      label: title,
      hint: 'Opens details',
      button: true,
      child: Container(
        width: Tokens.posterCardWidth,
        margin: const EdgeInsets.only(right: Tokens.spaceM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Tokens.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(Tokens.radiusM),
          child: InkWell(
            borderRadius: BorderRadius.circular(Tokens.radiusM),
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Tokens.radiusM),
              child: imageWidget,
            ),
          ),
        ),
      ),
    );
  }
}
