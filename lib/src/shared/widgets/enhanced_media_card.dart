import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/watchlist_action_buttons.dart';
import 'package:lets_stream/src/shared/theme/tokens.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

/// An enhanced media card widget with animations and overlay information.
///
/// This widget provides a rich, interactive media card with features like:
/// - Smooth hover and tap animations
/// - Overlay with rating and release year information
/// - Hero animations for smooth transitions
/// - Loading states with shimmer effects
/// - Error handling with fallback icons
/// - Accessibility support with semantic labels
///
/// The card responds to user interactions with scale animations and
/// shows additional information on hover/focus for better user experience.
///
/// Example usage:
/// ```dart
/// EnhancedMediaCard(
///   title: 'Movie Title',
///   imagePath: '/path/to/poster.jpg',
///   onTap: () => navigateToDetail(movieId),
///   rating: 8.5,
///   releaseYear: '2023',
///   heroTag: 'movie_${movie.id}',
/// )
/// ```
class EnhancedMediaCard extends ConsumerStatefulWidget {
  /// The title of the media item.
  final String title;

  /// The path to the poster image.
  final String? imagePath;

  /// Callback function called when the card is tapped.
  final VoidCallback onTap;

  /// The rating of the media item (optional).
  final double? rating;

  /// The release year of the media item (optional).
  final String? releaseYear;

  /// Whether to show the overlay with rating and year information.
  final bool showOverlay;

  /// The hero tag for hero animations (optional).
  final String? heroTag;

  /// The movie object for watchlist functionality (optional).
  final Movie? movie;

  /// The TV show object for watchlist functionality (optional).
  final TvShow? tvShow;

  /// Whether to show the watchlist button overlay.
  final bool showWatchlistButton;

  /// Creates an enhanced media card widget.
  ///
  /// The [title] is the title of the media item.
  /// The [imagePath] is the path to the poster image.
  /// The [onTap] callback is triggered when the card is tapped.
  /// The [rating] is the rating of the media item (optional).
  /// The [releaseYear] is the release year of the media item (optional).
  /// The [showOverlay] controls whether to show the overlay with rating and year information.
  /// The [heroTag] is used for hero animations (optional).
  /// The [movie] object is used for watchlist functionality (optional).
  /// The [tvShow] object is used for watchlist functionality (optional).
  /// The [showWatchlistButton] controls whether to show the watchlist button overlay.
  const EnhancedMediaCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.rating,
    this.releaseYear,
    this.showOverlay = true,
    this.heroTag,
    this.movie,
    this.tvShow,
    this.showWatchlistButton = true,
  });

  @override
  ConsumerState<EnhancedMediaCard> createState() => _EnhancedMediaCardState();
}

class _EnhancedMediaCardState extends ConsumerState<EnhancedMediaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _overlayAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _overlayAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final String? fullImageUrl =
        (widget.imagePath != null && widget.imagePath!.isNotEmpty)
            ? '$imageBaseUrl/w500${widget.imagePath}'
            : null;

    Widget imageWidget;
    if (fullImageUrl != null) {
      imageWidget = widget.heroTag != null
          ? Hero(
              tag: widget.heroTag!,
              child: CachedNetworkImage(
                imageUrl: fullImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                ),
              ),
            )
          : CachedNetworkImage(
              imageUrl: fullImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerBox(
                width: double.infinity,
                height: double.infinity,
              ),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 32,
                ),
              ),
            );
    } else {
      imageWidget = Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 32,
          ),
        ),
      );
    }

    return Semantics(
      label: widget.title,
      hint: 'Opens details',
      button: true,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: Tokens.posterCardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Tokens.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _isHovered ? 0.3 : 0.15,
                    ),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: Offset(0, _isHovered ? 6 : 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(Tokens.radiusM),
                child: InkWell(
                  borderRadius: BorderRadius.circular(Tokens.radiusM),
                  onTap: widget.onTap,
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  onHover: (isHovered) {
                    setState(() {
                      _isHovered = isHovered;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Tokens.radiusM),
                    child: Stack(
                      children: [
                        // Image
                        AspectRatio(aspectRatio: 2 / 3, child: imageWidget),

                        // Gradient overlay and info
                        if (widget.showOverlay)
                          AnimatedBuilder(
                            animation: _overlayAnimation,
                            builder: (context, child) {
                              return Positioned.fill(
                                child: AnimatedOpacity(
                                  opacity: _isHovered ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.3),
                                          Colors.black.withValues(alpha: 0.8),
                                        ],
                                        stops: const [0.4, 0.7, 1.0],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              shadows: [
                                                const Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(0, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (widget.rating != null ||
                                              widget.releaseYear != null)
                                            const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              if (widget.rating != null) ...[
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  widget.rating!
                                                      .toStringAsFixed(1),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                if (widget.releaseYear != null)
                                                  const SizedBox(width: 8),
                                              ],
                                              if (widget.releaseYear != null)
                                                Text(
                                                  widget.releaseYear!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.white70,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        // Play indicator for hover state
                        if (_isHovered)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0, 0),
                                duration: 200.ms,
                              )
                              .fadeIn(),

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
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A simple animated media card widget for backward compatibility.
///
/// This widget provides basic animation functionality with slide and fade
/// transitions. It's designed for simpler use cases where the full feature
/// set of [EnhancedMediaCard] is not needed but some animation is desired.
///
/// Features:
/// - Slide-in animation from left to right
/// - Fade-in effect
/// - Scale animation for smooth appearance
/// - Configurable animation delay
///
/// Example usage:
/// ```dart
/// AnimatedMediaCard(
///   title: 'Movie Title',
///   imagePath: '/path/to/poster.jpg',
///   onTap: () => navigateToDetail(movieId),
///   delay: const Duration(milliseconds: 200),
/// )
/// ```
class AnimatedMediaCard extends ConsumerWidget {
  /// The title of the media item.
  final String title;

  /// The path to the poster image.
  final String? imagePath;

  /// Callback function called when the card is tapped.
  final VoidCallback onTap;

  /// The delay before the animation starts.
  final Duration delay;

  /// The movie object for watchlist functionality (optional).
  final Movie? movie;

  /// The TV show object for watchlist functionality (optional).
  final TvShow? tvShow;

  /// Whether to show the watchlist button overlay.
  final bool showWatchlistButton;

  /// Creates an animated media card widget.
  ///
  /// The [title] is the title of the media item.
  /// The [imagePath] is the path to the poster image.
  /// The [onTap] callback is triggered when the card is tapped.
  /// The [delay] is the delay before the animation starts.
  /// The [movie] object is used for watchlist functionality (optional).
  /// The [tvShow] object is used for watchlist functionality (optional).
  /// The [showWatchlistButton] controls whether to show the watchlist button overlay.
  const AnimatedMediaCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.delay = Duration.zero,
    this.movie,
    this.tvShow,
    this.showWatchlistButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final String? fullImageUrl = (imagePath != null && imagePath!.isNotEmpty)
        ? '$imageBaseUrl/w500$imagePath'
        : null;

    Widget imageWidget;
    if (fullImageUrl != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: fullImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const ShimmerBox(width: double.infinity, height: double.infinity),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.broken_image_outlined),
        ),
      );
    } else {
      imageWidget = Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      );
    }

    return Container(
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
            child: AspectRatio(aspectRatio: 2 / 3, child: imageWidget),
          ),
        ),
      ),
    )
        .animate(delay: delay)
        .slideX(begin: 0.2, duration: 300.ms)
        .fadeIn()
        .scale(begin: const Offset(0.8, 0.8), duration: 400.ms);
  }
}
