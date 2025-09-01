import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/services/simple_cached_repository.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:logger/logger.dart';

part 'detail_notifier.freezed.dart';

@freezed
class DetailState with _$DetailState {
  const factory DetailState({
    Object? item,
    @Default([]) List<Video> videos,
    @Default([]) List<CastMember> cast,
    @Default([]) List<dynamic> similar,
    @Default([]) List<SeasonSummary> seasons,
    @Default(false) bool isLoading,
    Object? error,
  }) = _DetailState;
}

class DetailNotifier extends StateNotifier<DetailState> {
  final SimpleCachedRepository _repo;
  final Object? _item;
  final Logger _logger = Logger();

  DetailNotifier(this._repo, this._item) : super(DetailState(item: _item)) {
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final id = _item is Movie ? (_item).id : (_item as TvShow).id;
      final isMovie = _item is Movie;
      final itemType = isMovie ? 'Movie' : 'TV Show';

      _logger.i('Fetching details for $itemType with ID: $id');

      final videosFuture = isMovie
          ? _repo.getMovieVideos(id)
          : _repo.getTvVideos(id);
      final castFuture = isMovie ? _repo.getMovieCast(id) : _repo.getTvCast(id);
      final similarFuture = isMovie
          ? _repo.getSimilarMovies(id)
          : _repo.getSimilarTvShows(id);
      final seasonsFuture = isMovie
          ? Future.value(<SeasonSummary>[])
          : _repo.getTvSeasons(id);

      final results = await Future.wait([
        videosFuture,
        castFuture,
        similarFuture,
        seasonsFuture,
      ]);

      final videos = results[0] as List<Video>;
      final cast = results[1] as List<CastMember>;
      final similar = results[2];
      final seasons = results[3] as List<SeasonSummary>;

      _logger.i(
        'Fetched ${videos.length} videos, ${cast.length} cast members, ${similar.length} similar items, ${seasons.length} seasons',
      );

      state = state.copyWith(
        videos: videos,
        cast: cast,
        similar: similar,
        seasons: seasons,
        isLoading: false,
      );
    } catch (e) {
      _logger.e('Error fetching details: $e');
      state = state.copyWith(error: e, isLoading: false);
    }
  }
}

final detailNotifierProvider = StateNotifierProvider.autoDispose
    .family<DetailNotifier, DetailState, Object?>((ref, item) {
      final repo = ref.watch(tmdbRepositoryProvider);
      return DetailNotifier(repo, item);
    });
