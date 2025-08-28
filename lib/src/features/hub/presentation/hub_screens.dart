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

class _MoviesHubBody extends ConsumerStatefulWidget {
  @override
  _MoviesHubBodyState createState() => _MoviesHubBodyState();
}

class _MoviesHubBodyState extends ConsumerState<_MoviesHubBody> {
  int? _selectedGenreId;
  String? _selectedGenreName;
  Map<int, String> _movieGenres = {};

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      final genres = await ref.read(tmdbRepositoryProvider).getMovieGenres();
      setState(() {
        _movieGenres = genres;
      });
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(tmdbRepositoryProvider);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Genre Filter
          if (_movieGenres.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedGenreId == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGenreId = null;
                        _selectedGenreName = null;
                      });
                    },
                  ),
                  ..._movieGenres.entries.map((entry) => FilterChip(
                    label: Text(entry.value),
                    selected: _selectedGenreId == entry.key,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGenreId = selected ? entry.key : null;
                        _selectedGenreName = selected ? entry.value : null;
                      });
                    },
                  )),
                ],
              ),
            ),
            const Divider(),
          ],
          
          // Show different content based on genre selection
          if (_selectedGenreId == null) ...[
            // Default view with all feeds
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
          ] else ...[
            // Genre-specific view
            FutureBuilder<List<Movie>>(
              future: repo.getTrendingMoviesByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Trending $_selectedGenreName' 
                        : 'Failed to load Trending'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Trending $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MoviesListScreen(feed: 'trending', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
            FutureBuilder<List<Movie>>(
              future: repo.getNowPlayingMoviesByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Now Playing $_selectedGenreName' 
                        : 'Failed to load Now Playing'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Now Playing $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MoviesListScreen(feed: 'now_playing', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
            FutureBuilder<List<Movie>>(
              future: repo.getPopularMoviesByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Popular $_selectedGenreName' 
                        : 'Failed to load Popular'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Popular $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MoviesListScreen(feed: 'popular', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
            FutureBuilder<List<Movie>>(
              future: repo.getTopRatedMoviesByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Top Rated $_selectedGenreName' 
                        : 'Failed to load Top Rated'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Top Rated $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MoviesListScreen(feed: 'top_rated', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
          ],
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

class _TvHubBody extends ConsumerStatefulWidget {
  @override
  _TvHubBodyState createState() => _TvHubBodyState();
}

class _TvHubBodyState extends ConsumerState<_TvHubBody> {
  int? _selectedGenreId;
  String? _selectedGenreName;
  Map<int, String> _tvGenres = {};

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      final genres = await ref.read(tmdbRepositoryProvider).getTvGenres();
      setState(() {
        _tvGenres = genres;
      });
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(tmdbRepositoryProvider);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Genre Filter
          if (_tvGenres.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedGenreId == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGenreId = null;
                        _selectedGenreName = null;
                      });
                    },
                  ),
                  ..._tvGenres.entries.map((entry) => FilterChip(
                    label: Text(entry.value),
                    selected: _selectedGenreId == entry.key,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGenreId = selected ? entry.key : null;
                        _selectedGenreName = selected ? entry.value : null;
                      });
                    },
                  )),
                ],
              ),
            ),
            const Divider(),
          ],
          
          // Show different content based on genre selection
          if (_selectedGenreId == null) ...[
            // Default view with all feeds
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
          ] else ...[
            // Genre-specific view
            FutureBuilder<List<TvShow>>(
              future: repo.getTrendingTvByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Trending $_selectedGenreName' 
                        : 'Failed to load Trending'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Trending $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TvListScreen(feed: 'trending', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
            FutureBuilder<List<TvShow>>(
              future: repo.getAiringTodayTvByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Airing Today $_selectedGenreName' 
                        : 'Failed to load Airing Today'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Airing Today $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TvListScreen(feed: 'airing_today', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
            FutureBuilder<List<TvShow>>(
              future: repo.getPopularTvByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Popular $_selectedGenreName' 
                        : 'Failed to load Popular'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Popular $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TvListScreen(feed: 'popular', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
            FutureBuilder<List<TvShow>>(
              future: repo.getTopRatedTvByGenre(_selectedGenreId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerRow();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(_selectedGenreName != null 
                        ? 'Failed to load Top Rated $_selectedGenreName' 
                        : 'Failed to load Top Rated'),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();
                return MediaCarousel(
                  title: 'Top Rated $_selectedGenreName',
                  items: items,
                  onViewAll: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TvListScreen(feed: 'top_rated', genreId: _selectedGenreId, genreName: _selectedGenreName),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

