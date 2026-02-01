import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/watchlist_action_buttons.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:lets_stream/src/shared/theme/netflix_typography.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

/// An enhanced Netflix-style media card with hover animations and overlay.
///
/// Features:
/// - 2:3 poster aspect ratio
/// - 4px border radius
/// - Scale animation on hover/tap
/// - Dark shimmer loading state
/// - Info overlay with rating and year
/// - Play indicator on hover
/// - Watchlist button overlay
class EnhancedMediaCard extends ConsumerStatefulWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final double? rating;
  final String? releaseYear;
  final bool showOverlay;
  final String? heroTag;
  final Movie? movie;
  final TvShow? tvShow;
  final bool showWatchlistButton;
  final double? width;
  final bool isTop10;
  final int? top10Rank;

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
    this.width,
    this.isTop10 = false,
    this.top10Rank,
  });

  @override
  ConsumerState<EnhancedMediaCard> createState() => _EnhancedMediaCardState();
}

class _EnhancedMediaCardState extends ConsumerState<EnhancedMediaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
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

    final cardWidth = widget.width ?? 120.0;

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
                  borderRadius: BorderRadius.zero,
                ),
                errorWidget: (context, url, error) => Container(
                  color: NetflixColors.surfaceMedium,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: NetflixColors.textSecondary,
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
                borderRadius: BorderRadius.zero,
              ),
              errorWidget: (context, url, error) => Container(
                color: NetflixColors.surfaceMedium,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: NetflixColors.textSecondary,
                  size: 32,
                ),
              ),
            );
    } else {
      imageWidget = Container(
        color: NetflixColors.surfaceMedium,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: NetflixColors.textSecondary,
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
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  if (_isHovered)
                    BoxShadow(
                      color: NetflixColors.blackWithOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
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
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        // Image with aspect ratio
                        AspectRatio(
                          aspectRatio: 2 / 3,
                          child: imageWidget,
                        ),

                        // Top 10 rank indicator
                        if (widget.isTop10 && widget.top10Rank != null)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: NetflixColors.primaryRed,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.top10Rank}',
                                  style: NetflixTypography.cardTitle.copyWith(
                                    color: NetflixColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Gradient overlay with info on hover
                        if (widget.showOverlay)
                          AnimatedOpacity(
                            opacity: _isHovered ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    NetflixColors.transparent,
                                    NetflixColors.backgroundBlack,
                                  ],
                                  stops: [0.4, 0.6, 1.0],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: NetflixTypography
                                          .textTheme.labelMedium
                                          ?.copyWith(
                                            color: NetflixColors.textPrimary,
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
                                            color: NetflixColors.warning,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.rating!
                                                .toStringAsFixed(1),
                                            style: NetflixTypography
                                                .textTheme.bodySmall
                                                ?.copyWith(
                                                  color:
                                                      NetflixColors.textPrimary,
                                                ),
                                          ),
                                          if (widget.releaseYear != null)
                                            const SizedBox(width: 8),
                                        ],
                                        if (widget.releaseYear != null)
                                          Text(
                                            widget.releaseYear!,
                                            style: NetflixTypography
                                                .textTheme.bodySmall
                                                ?.copyWith(
                                                  color: NetflixColors
                                                      .textSecondary,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Play button on hover
                        if (_isHovered)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    NetflixColors.blackWithOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: NetflixColors.textPrimary,
                                size: 20,
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
                            size: 24,
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
class AnimatedMediaCard extends ConsumerWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final Duration delay;
  final Movie? movie;
  final TvShow? tvShow;
  final bool showWatchlistButton;

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
    final String? fullImageUrl =
        (imagePath != null && imagePath!.isNotEmpty)
            ? '$imageBaseUrl/w500$imagePath'
            : null;

    Widget imageWidget;
    if (fullImageUrl != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: fullImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.zero,
        ),
        errorWidget: (context, url, error) => Container(
          color: NetflixColors.surfaceMedium,
          child: const Icon(
            Icons.broken_image_outlined,
            color: NetflixColors.textSecondary,
          ),
        ),
      );
    } else {
      imageWidget = Container(
        color: NetflixColors.surfaceMedium,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: NetflixColors.textSecondary,
          ),
        ),
      );
    }

    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: NetflixColors.surfaceDark,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
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
