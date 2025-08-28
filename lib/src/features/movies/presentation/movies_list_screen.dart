import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  final String feed; // trending | now_playing | popular | top_rated
  final int? genreId;
  final String? genreName;

  const MoviesListScreen({super.key, required this.feed, this.genreId, this.genreName});

  @override
  ConsumerState<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  final _scroll = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasMore = true;
  final List<Movie> _items = [];
  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    _initialLoad = _load();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(tmdbRepositoryProvider);
    List<Movie> pageItems;
    
    if (widget.genreId != null) {
      // Fetch movies by genre
      switch (widget.feed) {
        case 'trending':
          pageItems = await repo.getTrendingMoviesByGenre(widget.genreId!, page: _page);
          break;
        case 'now_playing':
          pageItems = await repo.getNowPlayingMoviesByGenre(widget.genreId!, page: _page);
          break;
        case 'popular':
          pageItems = await repo.getPopularMoviesByGenre(widget.genreId!, page: _page);
          break;
        case 'top_rated':
          pageItems = await repo.getTopRatedMoviesByGenre(widget.genreId!, page: _page);
          break;
        default:
          pageItems = await repo.getTrendingMoviesByGenre(widget.genreId!, page: _page);
      }
    } else {
      // Fetch movies by feed
      switch (widget.feed) {
        case 'trending':
          pageItems = await repo.getTrendingMovies(page: _page);
          break;
        case 'now_playing':
          pageItems = await repo.getNowPlayingMovies(page: _page);
          break;
        case 'popular':
          pageItems = await repo.getPopularMovies(page: _page);
          break;
        case 'top_rated':
          pageItems = await repo.getTopRatedMovies(page: _page);
          break;
        default:
          pageItems = await repo.getTrendingMovies(page: _page);
      }
    }
    
    setState(() {
      _items.addAll(pageItems);
      _hasMore = pageItems.isNotEmpty;
    });
  }

  void _onScroll() {
    if (!_hasMore) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300 && !_loadingMore) {
      _loadingMore = true;
      _page += 1;
      _load().whenComplete(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final title = widget.genreName != null 
        ? '${_titleForFeed(widget.feed)} ${widget.genreName}' 
        : _titleForFeed(widget.feed);

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: FutureBuilder<void>(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _items.isEmpty) {
            // Shimmer grid placeholders
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2/3,
              ),
              itemCount: 12,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const ShimmerBox(width: double.infinity, height: double.infinity),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      setState(() {
                        _page = 1;
                        _hasMore = true;
                        _items.clear();
                        _initialLoad = _load();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (_items.isEmpty) {
            return const EmptyState(message: 'No movies found', icon: Icons.movie_outlined);
          }
          final showFooter = _loadingMore || _hasMore;
          final count = _items.length + (showFooter ? 1 : 0);
          return NotificationListener<ScrollNotification>(
            onNotification: (_) => false,
            child: RefreshIndicator(
              onRefresh: () async {
                _page = 1;
                _hasMore = true;
                _items.clear();
                await _load();
              },
              child: GridView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2/3,
              ),
              itemCount: count,
              itemBuilder: (context, index) {
                if (index >= _items.length) {
                  if (_loadingMore) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_hasMore) {
                    return Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_loadingMore || !_hasMore) return;
                          _loadingMore = true;
                          _page += 1;
                          _load().whenComplete(() => _loadingMore = false);
                        },
                        icon: const Icon(Icons.expand_more),
                        label: const Text('Load more'),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
                final m = _items[index];
                final poster = m.posterPath;
                final url = (poster != null && poster.isNotEmpty)
                    ? '$imageBaseUrl/w500$poster'
                    : null;
                return Semantics(
                  label: '${m.title}${m.releaseDate != null ? ' • ${m.releaseDate!.year}' : ''} • Movie',
                  hint: 'Opens details',
                  button: true,
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        'movie-detail',
                        pathParameters: {'id': m.id.toString()},
                        extra: m,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: url != null
                          ? CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.error),
                              ),
                            )
                          : Container(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              child: const Center(child: Icon(Icons.image_not_supported_outlined)),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          );
        },
      ),
    );
  }

  String _titleForFeed(String feed) {
    switch (feed) {
      case 'trending':
        return 'Trending';
      case 'now_playing':
        return 'Now Playing';
      case 'popular':
        return 'Popular';
      case 'top_rated':
        return 'Top Rated';
      default:
        return 'Movies';
    }
  }
}
