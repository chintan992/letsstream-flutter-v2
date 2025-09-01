import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/services/simple_cached_repository.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movies_list_notifier.freezed.dart';

@freezed
class MoviesListState with _$MoviesListState {
  const factory MoviesListState({
    @Default([]) List<Movie> movies,
    @Default(true) bool hasMore,
    @Default(false) bool isLoading,
    @Default(false) bool isInitialLoad,
    Object? error,
  }) = _MoviesListState;
}

class MoviesListNotifier extends StateNotifier<MoviesListState> {
  final SimpleCachedRepository _repo;
  final String feed;
  final int? genreId;
  int _page = 1;

  MoviesListNotifier(this._repo, {required this.feed, this.genreId})
      : super(const MoviesListState(isInitialLoad: true)) {
    load();
  }

  Future<void> load() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pageItems = await _fetchMovies();
      state = state.copyWith(
        movies: [...state.movies, ...pageItems],
        hasMore: pageItems.isNotEmpty,
        isLoading: false,
        isInitialLoad: false,
      );
      _page++;
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false, isInitialLoad: false);
    }
  }

  Future<void> refresh() async {
    _page = 1;
    state = const MoviesListState(isInitialLoad: true);
    await load();
  }

  Future<List<Movie>> _fetchMovies() {
    if (genreId != null) {
      switch (feed) {
        case 'trending':
          return _repo.getTrendingMoviesByGenre(genreId!, page: _page);
        case 'now_playing':
          return _repo.getNowPlayingMoviesByGenre(genreId!, page: _page);
        case 'popular':
          return _repo.getPopularMoviesByGenre(genreId!, page: _page);
        case 'top_rated':
          return _repo.getTopRatedMoviesByGenre(genreId!, page: _page);
        default:
          return _repo.getTrendingMoviesByGenre(genreId!, page: _page);
      }
    } else {
      return _repo.getMovies(feed: feed, page: _page);
    }
  }
}

final moviesListNotifierProvider = StateNotifierProvider.autoDispose.family<
    MoviesListNotifier, MoviesListState, ({String feed, int? genreId})>(
  (ref, params) {
    final repo = ref.watch(tmdbRepositoryProvider);
    return MoviesListNotifier(repo, feed: params.feed, genreId: params.genreId);
  },
);
