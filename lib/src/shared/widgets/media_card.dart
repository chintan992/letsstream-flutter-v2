import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/shared/widgets/optimized_image.dart';
import 'package:lets_stream/src/shared/widgets/watchlist_action_buttons.dart';
import 'package:lets_stream/src/shared/theme/tokens.dart';
import 'package:lets_stream/src/core/services/accessibility_service.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

/// A card widget that displays media content (movies/TV shows) with lazy loading.
///
/// This widget provides an accessible and performant way to display media items
/// in lists and carousels. It includes features like:
/// - Lazy image loading for improved scroll performance
/// - Accessibility support with proper semantic labels
/// - Touch-friendly sizing with accessibility considerations
/// - Optimized image display with loading states
///
/// The widget uses a delayed loading mechanism to improve initial scroll
/// performance by only loading images when they're about to come into view.
///
/// Example usage:
/// ```dart
/// MediaCard(
///   title: 'Movie Title',
///   imagePath: '/path/to/poster.jpg',
///   onTap: () => navigateToDetail(movieId),
/// )
/// ```
class MediaCard extends ConsumerStatefulWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final Movie? movie;
  final TvShow? tvShow;
  final bool showWatchlistButton;

  const MediaCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.movie,
    this.tvShow,
    this.showWatchlistButton = true,
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
          child: Stack(
            children: [
              InkWell(
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
              // Watchlist button overlay
              if (widget.showWatchlistButton &&
                  (widget.movie != null || widget.tvShow != null))
                MediaCardWatchlistButton(
                  item: widget.movie ?? widget.tvShow!,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
