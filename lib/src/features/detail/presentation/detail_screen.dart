import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/shared/widgets/media_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/watchlist_action_buttons.dart';

class DetailScreen extends ConsumerWidget {
  final Object? item; // Movie or TvShow

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

    String title;
    String overview;
    String? posterPath;
    String subtitle;
    double voteAverage;

    if (item is Movie) {
      final m = item as Movie;
      title = m.title;
      overview = m.overview;
      posterPath = m.posterPath;
      final date = m.releaseDate?.toLocal().toIso8601String().split('T').first;
      subtitle = date != null ? 'Release: $date' : '';
      voteAverage = m.voteAverage;
    } else if (item is TvShow) {
      final t = item as TvShow;
      title = t.name;
      overview = t.overview;
      posterPath = t.posterPath;
      final date = t.firstAirDate?.toLocal().toIso8601String().split('T').first;
      subtitle = date != null ? 'First air: $date' : '';
      voteAverage = t.voteAverage;
    } else {
      title = 'Details';
      overview = 'Unknown item type';
      posterPath = null;
      subtitle = '';
      voteAverage = 0.0;
    }

    final fullImageUrl = (posterPath != null && posterPath.isNotEmpty)
        ? '$imageBaseUrl/w500$posterPath'
        : null;

    final repo = ref.read(tmdbRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fullImageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: CachedNetworkImage(
                      imageUrl: fullImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerBox(
                          width: double.infinity, height: double.infinity),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              if (subtitle.isNotEmpty)
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text(voteAverage.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 16),
              Text('Overview',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(overview, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              // Watchlist Action Buttons
              if (item != null)
                WatchlistActionButtons(
                  item: item!,
                  onWatchlistToggle: (isInWatchlist) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isInWatchlist
                            ? 'Added to watchlist'
                            : 'Removed from watchlist'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  onFavoritesToggle: (isFavorite) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite
                            ? 'Added to favorites'
                            : 'Removed from favorites'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
              // Cast section
              Text('Top Billed Cast',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: FutureBuilder<List<CastMember>>(
                  future: item is Movie
                      ? repo.getMovieCast((item as Movie).id)
                      : item is TvShow
                          ? repo.getTvCast((item as TvShow).id)
                          : Future.value(const []),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    final cast = snapshot.data ?? const <CastMember>[];
                    if (cast.isEmpty) {
                      return const Center(child: Text('No cast available'));
                    }
                    final imageBase = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cast.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final c = cast[index];
                        final imageUrl =
                            (c.profilePath != null && c.profilePath!.isNotEmpty)
                                ? '$imageBase/w185${c.profilePath}'
                                : null;
                        return Semantics(
                          label:
                              '${c.name}${c.character != null && c.character!.isNotEmpty ? ' as ${c.character}' : ''}',
                          child: SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl == null
                                      ? const Icon(Icons.person_outline)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  c.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  c.character ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Theme.of(context).hintColor),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Trailers section
              Text('Trailers',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: FutureBuilder<List<Video>>(
                  future: item is Movie
                      ? repo.getMovieVideos((item as Movie).id)
                      : item is TvShow
                          ? repo.getTvVideos((item as TvShow).id)
                          : Future.value(const []),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    final videos = (snapshot.data ?? const <Video>[])
                        .where((v) => (v.site.toLowerCase() == 'youtube'))
                        .toList();
                    if (videos.isEmpty) {
                      return const Center(child: Text('No trailers available'));
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: videos.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final v = videos[index];
                        final thumbUrl =
                            'https://img.youtube.com/vi/${v.key}/0.jpg';
                        return Semantics(
                          label: '${v.name} • Trailer',
                          hint: 'Opens YouTube',
                          button: true,
                          child: GestureDetector(
                            onTap: () async {
                              final url = Uri.parse(
                                  'https://www.youtube.com/watch?v=${v.key}');
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: thumbUrl,
                                        width: 160,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const ShimmerBox(
                                                width: 160, height: 90),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest,
                                          child: const Icon(
                                              Icons.broken_image_outlined),
                                        ),
                                      ),
                                      const Positioned.fill(
                                        child: Center(
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.black54,
                                            child: Icon(Icons.play_arrow,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    v.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Similar section
              Text('Similar', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: FutureBuilder<List<dynamic>>(
                  future: item is Movie
                      ? repo.getSimilarMovies((item as Movie).id)
                      : item is TvShow
                          ? repo.getSimilarTvShows((item as TvShow).id)
                          : Future.value(const []),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    final items = snapshot.data ?? const [];
                    if (items.isEmpty) {
                      return const Center(child: Text('No similar titles'));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final it = items[index];
                        if (it is Movie) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MediaCard(
                              title: it.title,
                              imagePath: it.posterPath,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(item: it),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (it is TvShow) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MediaCard(
                              title: it.name,
                              imagePath: it.posterPath,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(item: it),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
