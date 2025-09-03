import 'package:flutter/material.dart';
import 'package:lets_stream/src/shared/widgets/optimized_image.dart';
import 'package:lets_stream/src/shared/theme/tokens.dart';
import 'package:lets_stream/src/core/services/accessibility_service.dart';

class MediaCard extends StatefulWidget {
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
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Delay image loading slightly to improve initial scroll performance
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService();
    final touchTargetSize = accessibilityService.getRecommendedTouchTargetSize(
      context,
    );

    final imageWidget = _isVisible
        ? OptimizedImage(
            imagePath: widget.imagePath,
            size: ImageSize.large,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );

    return Semantics(
      label: widget.title,
      hint: 'Double tap to open details',
      button: true,
      image: true,
      child: Container(
        width: Tokens.posterCardWidth,
        margin: const EdgeInsets.only(right: Tokens.spaceM),
        constraints: BoxConstraints(
          minHeight: touchTargetSize,
          minWidth: touchTargetSize,
        ),
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
            onTap: widget.onTap,
            focusColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
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
