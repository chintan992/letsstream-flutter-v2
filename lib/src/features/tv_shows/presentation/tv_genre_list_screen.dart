import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/widgets/empty_state.dart';

class TvGenreListScreen extends ConsumerStatefulWidget {
  final int genreId;
  final String genreName;
  const TvGenreListScreen({super.key, required this.genreId, required this.genreName});

  @override
  ConsumerState<TvGenreListScreen> createState() => _TvGenreListScreenState();
}

class _TvGenreListScreenState extends ConsumerState<TvGenreListScreen> {
  final _scroll = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasMore = true;
  final List<TvShow> _items = [];
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
    final pageItems = await repo.getTvByGenre(widget.genreId, page: _page);
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.genreName), centerTitle: true),
      body: FutureBuilder<void>(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _items.isEmpty) {
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (_items.isEmpty) return const EmptyState(message: 'No shows in this genre', icon: Icons.category_outlined);

          final showFooter = _loadingMore || _hasMore;
          final count = _items.length + (showFooter ? 1 : 0);
          return RefreshIndicator(
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
              final t = _items[index];
              final poster = t.posterPath;
              final url = (poster != null && poster.isNotEmpty)
                  ? '$imageBaseUrl/w500$poster'
                  : null;
              return GestureDetector(
                onTap: () {
                  context.pushNamed('tv-detail', pathParameters: {'id': t.id.toString()}, extra: t);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: url != null
                      ? CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Center(child: Icon(Icons.image_not_supported_outlined)),
                        ),
                ),
              );
            },
          ),
          );
        },
      ),
    );
  }
}
