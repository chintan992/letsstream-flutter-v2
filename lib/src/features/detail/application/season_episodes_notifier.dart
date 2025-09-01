import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lets_stream/src/core/models/episode.dart';
import 'package:lets_stream/src/core/services/simple_cached_repository.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';

part 'season_episodes_notifier.freezed.dart';

@freezed
class SeasonEpisodesState with _$SeasonEpisodesState {
  const factory SeasonEpisodesState({
    @Default([]) List<EpisodeSummary> episodes,
    @Default(false) bool isLoading,
    Object? error,
  }) = _SeasonEpisodesState;
}

class SeasonEpisodesNotifier extends StateNotifier<SeasonEpisodesState> {
  final SimpleCachedRepository _repo;
  final int tvId;
  final int seasonNumber;

  SeasonEpisodesNotifier(this._repo, this.tvId, this.seasonNumber)
      : super(const SeasonEpisodesState()) {
    _fetchEpisodes();
  }

  Future<void> _fetchEpisodes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final episodes = await _repo.getSeasonEpisodes(tvId, seasonNumber);
      state = state.copyWith(episodes: episodes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }
}

final seasonEpisodesNotifierProvider = StateNotifierProvider.autoDispose
    .family<SeasonEpisodesNotifier, SeasonEpisodesState, ({int tvId, int seasonNumber})>(
  (ref, params) {
    final repo = ref.watch(tmdbRepositoryProvider);
    return SeasonEpisodesNotifier(repo, params.tvId, params.seasonNumber);
  },
);
