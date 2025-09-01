import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/simple_cached_repository.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';

part 'hub_notifier.freezed.dart';

@freezed
class HubState with _$HubState {
  const factory HubState({
    @Default([]) List<Movie> trendingMovies,
    @Default([]) List<Movie> nowPlayingMovies,
    @Default([]) List<Movie> popularMovies,
    @Default([]) List<Movie> topRatedMovies,
    @Default([]) List<TvShow> trendingTvShows,
    @Default([]) List<TvShow> airingTodayTvShows,
    @Default([]) List<TvShow> popularTvShows,
    @Default([]) List<TvShow> topRatedTvShows,
    @Default({}) Map<int, String> movieGenres,
    @Default({}) Map<int, String> tvGenres,
    @Default(true) bool isLoading,
    Object? error,
  }) = _HubState;
}

class HubNotifier extends StateNotifier<HubState> {
  final SimpleCachedRepository _repo;

  HubNotifier(this._repo) : super(const HubState()) {
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await Future.wait([
        _repo.getTrendingMovies(),
        _repo.getNowPlayingMovies(),
        _repo.getPopularMovies(),
        _repo.getTopRatedMovies(),
        _repo.getTrendingTvShows(),
        _repo.getAiringTodayTvShows(),
        _repo.getPopularTvShows(),
        _repo.getTopRatedTvShows(),
        _repo.getMovieGenres(),
        _repo.getTvGenres(),
      ]);

      state = state.copyWith(
        trendingMovies: results[0] as List<Movie>,
        nowPlayingMovies: results[1] as List<Movie>,
        popularMovies: results[2] as List<Movie>,
        topRatedMovies: results[3] as List<Movie>,
        trendingTvShows: results[4] as List<TvShow>,
        airingTodayTvShows: results[5] as List<TvShow>,
        popularTvShows: results[6] as List<TvShow>,
        topRatedTvShows: results[7] as List<TvShow>,
        movieGenres: results[8] as Map<int, String>,
        tvGenres: results[9] as Map<int, String>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }
}

final hubNotifierProvider = StateNotifierProvider<HubNotifier, HubState>((ref) {
  final repo = ref.watch(tmdbRepositoryProvider);
  return HubNotifier(repo);
});
