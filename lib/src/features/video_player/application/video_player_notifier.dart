import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/video_source.dart';
import 'package:lets_stream/src/core/services/video_sources_provider.dart';
import 'package:lets_stream/src/features/video_player/application/video_player_state.dart';

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  final Ref _ref;
  final int mediaId;
  final String mediaType;
  final int? seasonNumber;
  final int? episodeNumber;

  VideoPlayerNotifier(this._ref, {
    required this.mediaId,
    required this.mediaType,
    this.seasonNumber,
    this.episodeNumber,
  }) : super(const VideoPlayerState()) {
    getSources();
  }

  Future<void> getSources() async {
    try {
      state = state.copyWith(isLoading: true);
      final sources = await _ref.read(videoSourcesRepositoryProvider).getVideoSources();
      state = state.copyWith(sources: sources, isLoading: false, selectedSource: sources.isNotEmpty ? sources.first : null);
      _updateVideoUrl();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  void selectSource(VideoSource source) {
    state = state.copyWith(isSwitchingSource: true);
    Future.delayed(const Duration(milliseconds: 500), () {
      state = state.copyWith(selectedSource: source, isSwitchingSource: false);
      _updateVideoUrl();
    });
  }

  void _updateVideoUrl() {
    if (state.selectedSource != null) {
      String url;
      if (mediaType == 'movie') {
        url = state.selectedSource!.movieUrlPattern
            .replaceAll('{id}', mediaId.toString());
      } else {
        url = state.selectedSource!.tvUrlPattern
            .replaceAll('{id}', mediaId.toString())
            .replaceAll('{season}', seasonNumber.toString())
            .replaceAll('{episode}', episodeNumber.toString());
      }
      state = state.copyWith(videoUrl: url);
    }
  }
}

final videoPlayerNotifierProvider = StateNotifierProvider.autoDispose.family<
    VideoPlayerNotifier,
    VideoPlayerState,
    ({int mediaId, String mediaType, int? seasonNumber, int? episodeNumber})>(
  (ref, params) => VideoPlayerNotifier(
    ref,
    mediaId: params.mediaId,
    mediaType: params.mediaType,
    seasonNumber: params.seasonNumber,
    episodeNumber: params.episodeNumber,
  ),
);