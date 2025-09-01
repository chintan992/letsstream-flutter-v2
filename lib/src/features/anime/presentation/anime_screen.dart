import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/movies/presentation/movies_genre_list_screen.dart';
import 'package:lets_stream/src/features/tv_shows/presentation/tv_genre_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_row.dart';

class AnimeScreen extends ConsumerStatefulWidget {
  const AnimeScreen({super.key});

  @override
  ConsumerState<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends ConsumerState<AnimeScreen> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<TvShow>> _tvFuture;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(tmdbRepositoryProvider);
    _moviesFuture = repo.getAnimeMovies();
    _tvFuture = repo.getAnimeTvShows();
  }

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Anime'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Anime Movies',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              _HorizontalList<Movie>(
                future: _moviesFuture,
                buildUrl: (m) => '$imageBaseUrl/w500${m.posterPath}',
                onTap: (m) => context.pushNamed(
                  'movie-detail',
                  pathParameters: {'id': m.id.toString()},
                  extra: m,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MoviesGenreListScreen(
                          genreId: 16,
                          genreName: 'Anime Movies',
                          feed: 'popular',
                        ),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Popular Anime TV',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              _HorizontalList<TvShow>(
                future: _tvFuture,
                buildUrl: (t) => '$imageBaseUrl/w500${t.posterPath}',
                onTap: (t) => context.pushNamed(
                  'tv-detail',
                  pathParameters: {'id': t.id.toString()},
                  extra: t,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TvGenreListScreen(
                          genreId: 16,
                          genreName: 'Anime TV',
                        ),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HorizontalList<T> extends StatelessWidget {
  final Future<List<T>> future;
  final String? Function(T) buildUrl;
  final void Function(T) onTap;

  const _HorizontalList({
    required this.future,
    required this.buildUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: FutureBuilder<List<T>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerRow();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No items'));
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = items[index];
              final url = buildUrl(item);
              return GestureDetector(
                onTap: () => onTap(item),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (url != null && url.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: url,
                          width: 120,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.error),
                          ),
                        )
                      : Container(
                          width: 120,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: Icon(Icons.image_not_supported_outlined),
                          ),
                        ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
