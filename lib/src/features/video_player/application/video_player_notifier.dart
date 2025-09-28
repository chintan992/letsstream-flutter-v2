import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/api/tmdb_api.dart';
import 'package:lets_stream/src/core/models/video_source.dart';
import 'package:lets_stream/src/core/services/pip_service.dart';
import 'package:lets_stream/src/core/services/video_sources_provider.dart';
import 'package:lets_stream/src/features/video_player/application/video_player_state.dart';

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  final Ref _ref;
  final int mediaId;
  final String mediaType;

  VideoPlayerNotifier(
    this._ref, {
    required this.mediaId,
    required this.mediaType,
    int? seasonNumber,
    int? episodeNumber,
  }) : super(
         VideoPlayerState(
           seasonNumber: seasonNumber,
           episodeNumber: episodeNumber,
         ),
       ) {
    getSources();
  }

  Future<void> getSources() async {
    try {
      state = state.copyWith(isLoading: true);
      final sources = await _ref
          .read(videoSourcesRepositoryProvider)
          .getVideoSources();

      if (mediaType == 'tv' && state.seasonNumber != null) {
        final seasonDetails = await TmdbApi.instance.getSeasonDetails(
          mediaId,
          state.seasonNumber!,
        );
        state = state.copyWith(totalEpisodes: seasonDetails.episodes.length);
      }

      state = state.copyWith(
        sources: sources,
        isLoading: false,
        selectedSource: sources.isNotEmpty ? sources.first : null,
      );
      _updateVideoUrl();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  void selectSource(VideoSource source) {
    state = state.copyWith(isSwitchingSource: true);
    // Immediately update the selected source and video URL
    state = state.copyWith(selectedSource: source, isSwitchingSource: false);
    _updateVideoUrl();
  }

  void nextEpisode() {
    if (state.episodeNumber != null &&
        state.episodeNumber! < state.totalEpisodes) {
      state = state.copyWith(
        episodeNumber: state.episodeNumber! + 1,
        isSwitchingSource: true,
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        state = state.copyWith(isSwitchingSource: false);
        _updateVideoUrl();
      });
    }
  }

  void previousEpisode() {
    if (state.episodeNumber != null && state.episodeNumber! > 1) {
      state = state.copyWith(
        episodeNumber: state.episodeNumber! - 1,
        isSwitchingSource: true,
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        state = state.copyWith(isSwitchingSource: false);
        _updateVideoUrl();
      });
    }
  }

  void _updateVideoUrl() {
    if (state.selectedSource != null) {
      String url;
      if (mediaType == 'movie') {
        url = state.selectedSource!.movieUrlPattern.replaceAll(
          '{id}',
          mediaId.toString(),
        );
      } else {
        url = state.selectedSource!.tvUrlPattern
            .replaceAll('{id}', mediaId.toString())
            .replaceAll('{season}', state.seasonNumber.toString())
            .replaceAll('{episode}', state.episodeNumber.toString());
      }
      // Add some debugging information
      // sprint('Updating video URL to: $url');
      state = state.copyWith(videoUrl: url);
    }
  }

  Future<void> initializePip() async {
    try {
      final pipService = _ref.read(pipServiceProvider);
      final availability = pipService.availability;

      // Delay state modifications to avoid build-time updates
      Future(() {
        state = state.copyWith(
          pipAvailability: availability,
          pipState: pipService.currentState,
          isPipActive: pipService.isPipActive,
        );
      });

      // Listen to PIP state changes
      pipService.stateStream.listen((pipState) {
        print('🔊 PIP state stream update: $pipState (active: ${pipState == PipState.active})');
        // Update state immediately when PIP state changes
        state = state.copyWith(
          pipState: pipState,
          isPipActive: pipState == PipState.active,
        );
        print('✅ Stream state updated: isPipActive=${state.isPipActive}, pipState=${state.pipState}');
      });
    } catch (e) {
      // Handle PIP initialization error
      Future(() {
        state = state.copyWith(
          pipAvailability: PipAvailability.unknown,
          pipState: PipState.error,
        );
      });
    }
  }

  Future<bool> togglePipMode() async {
    try {
      final pipService = _ref.read(pipServiceProvider);

      print('🔄 Toggle PIP requested. Current state: isPipActive=${state.isPipActive}, pipState=${state.pipState}');

      // Create a simple PIP widget to avoid WebView conflicts
      final pipWidget = SimplePipWidget(
        videoUrl: state.videoUrl,
        selectedSourceName: state.selectedSource?.name ?? 'Unknown Source',
      );

      print('🔧 Created PIP widget, calling pipService.togglePip...');

      final success = await pipService.togglePip(
        pipWidget: pipWidget,
        rational: null,
        aspectRatio: null,
        videoUrl: state.videoUrl, // Pass the video URL directly
      );

      print('🔄 PIP toggle result: success=$success, pipService.currentState=${pipService.currentState}, pipService.isPipActive=${pipService.isPipActive}');

      // Update state immediately (not delayed) after the toggle operation
      if (success) {
        state = state.copyWith(
          pipState: pipService.currentState,
          isPipActive: pipService.isPipActive,
        );
        print('✅ State updated: isPipActive=${state.isPipActive}, pipState=${state.pipState}');
      } else {
        print('⚠️ PIP toggle returned false, not updating state');
      }

      // Add a small delay to allow state propagation before any UI updates
      await Future.delayed(const Duration(milliseconds: 100));
      print('🏁 togglePipMode completed successfully');

      return success;
    } catch (e, stackTrace) {
      print('❌ Error in togglePipMode: $e');
      print('❌ Stack trace: $stackTrace');
      // Update state with error immediately
      state = state.copyWith(pipState: PipState.error);
      return false;
    }
  }

  Future<bool> enablePipMode() async {
    try {
      final pipService = _ref.read(pipServiceProvider);

      final pipWidget = Container(
        width: 320,
        height: 180,
        color: Colors.black,
        child: const Center(
          child: Text('Video Player', style: TextStyle(color: Colors.white)),
        ),
      );

      final success = await pipService.enablePip(
        pipWidget: pipWidget,
        rational: null,
        aspectRatio: null,
      );

      if (success) {
        state = state.copyWith(
          pipState: pipService.currentState,
          isPipActive: pipService.isPipActive,
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(pipState: PipState.error);
      return false;
    }
  }

  Future<bool> disablePipMode() async {
    try {
      final pipService = _ref.read(pipServiceProvider);
      final success = await pipService.disablePip();

      if (success) {
        state = state.copyWith(
          pipState: pipService.currentState,
          isPipActive: pipService.isPipActive,
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(pipState: PipState.error);
      return false;
    }
  }

  /// Update PIP active state directly (used by UI to sync with native PIP changes)
  void setPipActive(bool isActive) {
    final newPipState = isActive ? PipState.active : PipState.inactive;
    state = state.copyWith(
      isPipActive: isActive,
      pipState: newPipState,
    );
    print('🔧 setPipActive called: isActive=$isActive, newState=${state.isPipActive}');
  }
}

final videoPlayerNotifierProvider = StateNotifierProvider.autoDispose
    .family<
      VideoPlayerNotifier,
      VideoPlayerState,
      ({int mediaId, String mediaType, int? seasonNumber, int? episodeNumber})
    >(
      (ref, params) => VideoPlayerNotifier(
        ref,
        mediaId: params.mediaId,
        mediaType: params.mediaType,
        seasonNumber: params.seasonNumber,
        episodeNumber: params.episodeNumber,
      ),
    );
