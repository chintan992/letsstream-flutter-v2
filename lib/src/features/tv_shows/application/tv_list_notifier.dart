import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/simple_cached_repository.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_list_notifier.freezed.dart';

@freezed
class TvListState with _$TvListState {
  const factory TvListState({
    @Default([]) List<TvShow> tvShows,
    @Default(true) bool hasMore,
    @Default(false) bool isLoading,
    @Default(false) bool isInitialLoad,
    Object? error,
  }) = _TvListState;
}

class TvListNotifier extends StateNotifier<TvListState> {
  final SimpleCachedRepository _repo;
  final String feed;
  final int? genreId;
  int _page = 1;

  TvListNotifier(this._repo, {required this.feed, this.genreId})
    : super(const TvListState(isInitialLoad: true)) {
    load();
  }

  Future<void> load() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pageItems = await _fetchTvShows();
      state = state.copyWith(
        tvShows: [...state.tvShows, ...pageItems],
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
    state = const TvListState(isInitialLoad: true);
    await load();
  }

  Future<List<TvShow>> _fetchTvShows() {
    if (genreId != null) {
      switch (feed) {
        case 'trending':
          return _repo.getTrendingTvByGenre(genreId!, page: _page);
        case 'airing_today':
          return _repo.getAiringTodayTvByGenre(genreId!, page: _page);
        case 'popular':
          return _repo.getPopularTvByGenre(genreId!, page: _page);
        case 'top_rated':
          return _repo.getTopRatedTvByGenre(genreId!, page: _page);
        default:
          return _repo.getTrendingTvByGenre(genreId!, page: _page);
      }
    } else {
      return _repo.getTvShows(feed: feed, page: _page);
    }
  }
}

final tvListNotifierProvider = StateNotifierProvider.autoDispose
    .family<TvListNotifier, TvListState, ({String feed, int? genreId})>((
      ref,
      params,
    ) {
      final repo = ref.watch(tmdbRepositoryProvider);
      return TvListNotifier(repo, feed: params.feed, genreId: params.genreId);
    });
