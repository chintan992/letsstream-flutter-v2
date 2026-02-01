import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/shared/widgets/optimized_image.dart';
import 'package:lets_stream/src/shared/widgets/watchlist_action_buttons.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:lets_stream/src/core/services/accessibility_service.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

/// A Netflix-style poster card widget for displaying media content.
///
/// Features:
/// - 2:3 poster aspect ratio (Netflix standard)
/// - 4px border radius
/// - Minimal chrome, image-focused design
/// - Dark loading placeholder
/// - Watchlist button overlay
/// - Accessibility support
class MediaCard extends ConsumerStatefulWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final Movie? movie;
  final TvShow? tvShow;
  final bool showWatchlistButton;
  final double? width;

  const MediaCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.movie,
    this.tvShow,
    this.showWatchlistButton = true,
    this.width,
  });

  @override
  ConsumerState<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends ConsumerState<MediaCard> {
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

    final cardWidth = widget.width ?? 120.0;

    final imageWidget = _isVisible
        ? OptimizedImage(
            imagePath: widget.imagePath,
            size: ImageSize.large,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Container(
            color: NetflixColors.surfaceMedium,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: NetflixColors.textSecondary,
                ),
              ),
            ),
          );

    return Semantics(
      label: widget.title,
      hint: 'Double tap to open details',
      button: true,
      image: true,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 8),
        constraints: BoxConstraints(
          minHeight: touchTargetSize,
          minWidth: touchTargetSize,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: NetflixColors.surfaceDark,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: widget.onTap,
            focusColor: NetflixColors.surfaceMedium.withValues(alpha: 0.3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageWidget,
                    // Watchlist button overlay
                    if (widget.showWatchlistButton &&
                        (widget.movie != null || widget.tvShow != null))
                      MediaCardWatchlistButton(
                        item: widget.movie ?? widget.tvShow!,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
