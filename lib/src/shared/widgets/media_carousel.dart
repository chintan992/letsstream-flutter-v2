import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/shared/widgets/media_card.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              String title = '';
              String? imagePath;

              if (item is Movie) {
                title = item.title;
                imagePath = item.posterPath;
              } else if (item is TvShow) {
                title = item.name;
                imagePath = item.posterPath;
              }

              return MediaCard(
                title: title,
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
              );
            },
          ),
        ),
      ],
    );
  }
}