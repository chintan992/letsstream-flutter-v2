import 'package:flutter/material.dart';
import 'package:lets_stream/src/shared/widgets/optimized_image.dart';
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
    final imageWidget = OptimizedImage(
      imagePath: imagePath,
      size: ImageSize.large,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

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
