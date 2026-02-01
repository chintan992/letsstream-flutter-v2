import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/movie.dart';
import '../../../../core/models/tv_show.dart';
import '../../../../shared/widgets/enhanced_media_card.dart';
import '../../../../shared/widgets/desktop_scroll_wrapper.dart';
import '../../../../shared/theme/netflix_colors.dart';
import '../../../../shared/theme/netflix_typography.dart';

/// A Netflix-style horizontal media list with section header.
///
/// Features:
/// - Section title with Netflix typography
/// - "View All" button
/// - Horizontal scrolling with desktop navigation arrows
/// - Top 10 rank support
/// - 2:3 poster ratio cards
/// - Dark Netflix styling
class MediaHorizontalList extends ConsumerStatefulWidget {
  final String title;
  final List<dynamic> items;
  final String? viewAllRoute;
  final Map<String, String>? viewAllParams;
  final void Function(dynamic item)? onItemTap;
  final bool showViewAll;
  final String? heroTagPrefix;
  final bool isTop10;

  const MediaHorizontalList({
    super.key,
    required this.title,
    required this.items,
    this.viewAllRoute,
    this.viewAllParams,
    this.onItemTap,
    this.showViewAll = true,
    this.heroTagPrefix,
    this.isTop10 = false,
  });

  @override
  ConsumerState<MediaHorizontalList> createState() =>
      _MediaHorizontalListState();
}

class _MediaHorizontalListState extends ConsumerState<MediaHorizontalList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final cardWidth = isDesktop ? 180.0 : 120.0;
    final cardHeight = cardWidth * 1.5; // 2:3 ratio

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Netflix-style section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title with Netflix typography
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NetflixTypography.sectionTitle.copyWith(
                    fontSize: isDesktop ? 20 : 16,
                  ),
                ),
              ),

              if (widget.showViewAll) ...[
                const SizedBox(width: 8),
                _buildViewAllButton(context),
              ],
            ],
          ),
        ),

        // Horizontal list
        SizedBox(
          height: cardHeight,
          child: DesktopScrollWrapper(
            controller: _scrollController,
            child: ListView.separated(
              controller: _scrollController,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: isDesktop ? 12 : 8),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final title = _getTitle(item);
                final imagePath = _getImagePath(item);
                final rating = _getRating(item);
                final year = _getYear(item);

                return EnhancedMediaCard(
                  title: title,
                  imagePath: imagePath,
                  onTap: () {
                    if (widget.onItemTap != null) {
                      widget.onItemTap!(item);
                    } else {
                      _navigateToDetail(context, item);
                    }
                  },
                  rating: rating,
                  releaseYear: year,
                  width: cardWidth,
                  isTop10: widget.isTop10 && index < 10,
                  top10Rank: widget.isTop10 ? index + 1 : null,
                  heroTag: widget.heroTagPrefix != null
                      ? '${widget.heroTagPrefix}_${_getId(item)}'
                      : null,
                  movie: item is Movie ? item : null,
                  tvShow: item is TvShow ? item : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.viewAllRoute != null) {
          context.pushNamed(
            widget.viewAllRoute!,
            pathParameters: widget.viewAllParams ?? {},
          );
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: NetflixColors.surfaceMedium,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View All',
              style: NetflixTypography.textTheme.labelSmall?.copyWith(
                color: NetflixColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: NetflixColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, dynamic item) {
    final id = _getId(item);

    if (item is Movie) {
      context.pushNamed(
        'movie-detail',
        pathParameters: {'id': id.toString()},
        extra: item,
      );
    } else if (item is TvShow) {
      context.pushNamed(
        'tv-detail',
        pathParameters: {'id': id.toString()},
        extra: item,
      );
    }
  }

  String _getTitle(dynamic item) {
    if (item is Movie) return item.title;
    if (item is TvShow) return item.name;
    return 'Unknown';
  }

  String? _getImagePath(dynamic item) {
    if (item is Movie) return item.posterPath;
    if (item is TvShow) return item.posterPath;
    return null;
  }

  double? _getRating(dynamic item) {
    if (item is Movie) return item.voteAverage;
    if (item is TvShow) return item.voteAverage;
    return null;
  }

  String? _getYear(dynamic item) {
    try {
      if (item is Movie && item.releaseDate != null) {
        return item.releaseDate!.year.toString();
      }
      if (item is TvShow && item.firstAirDate != null) {
        return item.firstAirDate!.year.toString();
      }
    } catch (_) {}
    return null;
  }

  int _getId(dynamic item) {
    if (item is Movie) return item.id;
    if (item is TvShow) return item.id;
    return 0;
  }
}
