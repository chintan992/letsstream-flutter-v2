import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/features/movies/presentation/movies_list_screen.dart';
import 'package:lets_stream/src/features/movies/presentation/movies_genre_list_screen.dart';
import 'package:lets_stream/src/features/tv_shows/presentation/tv_list_screen.dart';
import 'package:lets_stream/src/features/tv_shows/presentation/tv_genre_list_screen.dart';
import 'package:lets_stream/src/shared/widgets/media_carousel.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_row.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

class MoviesHubScreen extends ConsumerWidget {
  const MoviesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Preload some data (no UI dependency required here, but could warm caches)
    ref.read(tmdbRepositoryProvider).getPopularMovies();
    return Scaffold(
      appBar: AppBar(title: const Text('Movies'), centerTitle: true),
      body: _MoviesHubBody(),
    );
  }
}

class _MoviesHubBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(tmdbRepositoryProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<Movie>>(
            future: repo.getTrendingMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Trending'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Trending',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MoviesListScreen(feed: 'trending')),
                ),
              );
            },
          ),
          FutureBuilder<List<Movie>>(
            future: repo.getNowPlayingMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Now Playing'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Now Playing',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MoviesListScreen(feed: 'now_playing')),
                ),
              );
            },
          ),
          FutureBuilder<List<Movie>>(
            future: repo.getPopularMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Popular'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Popular',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MoviesListScreen(feed: 'popular')),
                ),
              );
            },
          ),
          FutureBuilder<List<Movie>>(
            future: repo.getTopRatedMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Top Rated'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Top Rated',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MoviesListScreen(feed: 'top_rated')),
                ),
              );
            },
          ),
        // Genres - Movies
        FutureBuilder<List<Movie>>(
          future: repo.getMoviesByGenre(28), // Action
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Action'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Action',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MoviesGenreListScreen(genreId: 28, genreName: 'Action'),
                  ),
                ),
              );
          },
        ),
        FutureBuilder<List<Movie>>(
          future: repo.getMoviesByGenre(35), // Comedy
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Comedy'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
              title: 'Comedy',
              items: items,
              onViewAll: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MoviesGenreListScreen(genreId: 35, genreName: 'Comedy'),
                ),
              ),
            );
          },
        ),
        FutureBuilder<List<Movie>>(
          future: repo.getMoviesByGenre(18), // Drama
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Drama'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Drama',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MoviesGenreListScreen(genreId: 18, genreName: 'Drama'),
                  ),
                ),
              );
          },
        ),
        FutureBuilder<List<Movie>>(
          future: repo.getMoviesByGenre(878), // Sci-Fi
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Science Fiction'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Science Fiction',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MoviesGenreListScreen(genreId: 878, genreName: 'Science Fiction'),
                  ),
                ),
              );
          },
        ),
      ],
    ),
  );
}
}

class TvHubScreen extends ConsumerWidget {
  const TvHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(tmdbRepositoryProvider).getPopularTvShows();
    return Scaffold(
      appBar: AppBar(title: const Text('TV Shows'), centerTitle: true),
      body: _TvHubBody(),
    );
  }
}

class _TvHubBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(tmdbRepositoryProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<TvShow>>(
            future: repo.getTrendingTvShows(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Trending'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Trending',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TvListScreen(feed: 'trending')),
                ),
              );
            },
          ),
          FutureBuilder<List<TvShow>>(
            future: repo.getAiringTodayTvShows(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Airing Today'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Airing Today',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TvListScreen(feed: 'airing_today')),
                ),
              );
            },
          ),
          FutureBuilder<List<TvShow>>(
            future: repo.getPopularTvShows(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Popular'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Popular',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TvListScreen(feed: 'popular')),
                ),
              );
            },
          ),
          FutureBuilder<List<TvShow>>(
            future: repo.getTopRatedTvShows(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerRow();
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Failed to load Top Rated'),
                );
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Top Rated',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TvListScreen(feed: 'top_rated')),
                ),
              );
            },
          ),
        // Genres - TV
        FutureBuilder<List<TvShow>>(
          future: repo.getTvByGenre(10759), // Action & Adventure
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Action & Adventure'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Action & Adventure',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TvGenreListScreen(genreId: 10759, genreName: 'Action & Adventure'),
                  ),
                ),
              );
            },
          ),
        FutureBuilder<List<TvShow>>(
          future: repo.getTvByGenre(35), // Comedy
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Comedy'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Comedy',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TvGenreListScreen(genreId: 35, genreName: 'Comedy'),
                  ),
                ),
              );
            },
          ),
        FutureBuilder<List<TvShow>>(
          future: repo.getTvByGenre(18), // Drama
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Drama'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Drama',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TvGenreListScreen(genreId: 18, genreName: 'Drama'),
                  ),
                ),
              );
            },
          ),
        FutureBuilder<List<TvShow>>(
          future: repo.getTvByGenre(10765), // Sci-Fi & Fantasy
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerRow();
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Failed to load Sci‑Fi & Fantasy'),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const SizedBox.shrink();
              return MediaCarousel(
                title: 'Sci‑Fi & Fantasy',
                items: items,
                onViewAll: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TvGenreListScreen(genreId: 10765, genreName: 'Sci‑Fi & Fantasy'),
                  ),
                ),
              );
            },
          ),
      ],
    ),
  );
}
}

