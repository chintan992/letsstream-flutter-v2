import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/shared/widgets/media_card.dart';
import 'package:lets_stream/src/core/services/accessibility_service.dart';

class MediaCarousel extends StatelessWidget {
  final String title;
  final List<dynamic> items; // Can be List<Movie> or List<TvShow>
  final VoidCallback onViewAll;

  const MediaCarousel({
    super.key,
    required this.title,
    required this.items,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final accessibilityService = AccessibilityService();

    return Semantics(
      label: '$title carousel with ${items.length} items',
      hint:
          'Swipe horizontally to browse items, double tap View All to see complete list',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: accessibilityService.getAccessibleTextStyle(
                    context,
                    Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Semantics(
                  label: 'View all $title',
                  hint: 'Opens full list of ${items.length} items',
                  button: true,
                  child: TextButton(
                    onPressed: onViewAll,
                    style: TextButton.styleFrom(
                      minimumSize: Size(
                        accessibilityService.getRecommendedTouchTargetSize(
                          context,
                        ),
                        accessibilityService.getRecommendedTouchTargetSize(
                          context,
                        ),
                      ),
                    ),
                    child: const Text('View All'),
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            label: '$title items list',
            hint: 'Horizontal scrolling list of ${items.length} items',
            child: SizedBox(
              height: 220, // Increased from 180 to accommodate title text below poster
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  String itemTitle = '';
                  String? imagePath;
                  String itemType = '';

                  if (item is Movie) {
                    itemTitle = item.title;
                    imagePath = item.posterPath;
                    itemType = 'movie';
                  } else if (item is TvShow) {
                    itemTitle = item.name;
                    imagePath = item.posterPath;
                    itemType = 'TV show';
                  }

                  return Semantics(
                    label: '$itemTitle, $itemType',
                    hint:
                        'Item ${index + 1} of ${items.length}, double tap to open details',
                    child: MediaCard(
                      title: itemTitle,
                      imagePath: imagePath,
                      onTap: () {
                        if (item is Movie) {
                          context.pushNamed(
                            'movie-detail',
                            pathParameters: {'id': item.id.toString()},
                            extra: item,
                          );
                        } else if (item is TvShow) {
                          context.pushNamed(
                            'tv-detail',
                            pathParameters: {'id': item.id.toString()},
                            extra: item,
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
