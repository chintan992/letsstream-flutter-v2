import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:lets_stream/src/core/api/anime_api.dart';
import 'package:lets_stream/src/core/models/anime/anime_info.dart';
import 'package:lets_stream/src/core/models/anime/anime_episode.dart';
import 'package:lets_stream/src/core/models/anime/anime_server.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_state.dart';

/// Notifier for managing anime player state and playback.
///
/// This notifier handles all anime playback operations including loading episodes,
/// switching servers, managing video controllers, and handling user interactions.
class AnimePlayerNotifier extends StateNotifier<AnimePlayerState> {
  /// The Anime API client for fetching streaming data.
  final AnimeApi _animeApi;

  /// Timer for updating playback position.
  Timer? _positionTimer;

  /// Timer for checking intro/outro skip availability.
  Timer? _skipTimer;

  /// Creates a new AnimePlayerNotifier instance.
  ///
  /// [_animeApi] The Anime API client to use for fetching data.
  AnimePlayerNotifier(this._animeApi) : super(const AnimePlayerState());

  @override
  void dispose() {
    _positionTimer?.cancel();
    _skipTimer?.cancel();
    state.videoController?.dispose();
    state.chewieController?.dispose();
    super.dispose();
  }

  /// Loads anime information and episodes.
  ///
  /// [animeId] The Anime API ID of the anime to load.
  Future<void> loadAnime(String animeId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Load anime info and episodes in parallel
      final results = await Future.wait([
        _animeApi.getAnimeInfo(animeId),
        _animeApi.getEpisodes(animeId),
      ]);

      final animeInfo = results[0] as AnimeInfo;
      final episodes = results[1] as List<AnimeEpisode>;

      state = state.copyWith(
        animeInfo: animeInfo,
        episodes: episodes,
        isLoading: false,
      );

      // Auto-load the first episode if available
      if (episodes.isNotEmpty) {
        await loadEpisode(episodes.first);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load anime: $e',
      );
    }
  }

  /// Loads a specific episode and its streaming data.
  ///
  /// [episode] The episode to load.
  Future<void> loadEpisode(AnimeEpisode episode) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentEpisode: episode,
      );

      // Dispose previous controllers
      await _disposeControllers();

      // Load available servers for the episode
      final servers = await _animeApi.getServers(episode.id);
      
      state = state.copyWith(
        availableServers: servers,
        isLoading: false,
      );

      // Auto-select the first server of the preferred type
      if (servers.isNotEmpty) {
        final preferredServers = servers
            .where((s) => s.type == state.selectedType)
            .toList();
        
        final selectedServer = preferredServers.isNotEmpty 
            ? preferredServers.first 
            : servers.first;
            
        await selectServer(selectedServer);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load episode: $e',
      );
    }
  }

  /// Selects a server and loads its streaming data.
  ///
  /// [server] The server to select.
  Future<void> selectServer(AnimeServer server) async {
    if (state.currentEpisode == null) return;

    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        selectedServer: server,
      );

      // Dispose previous controllers
      await _disposeControllers();

      // Load streaming data
      final streamData = await _animeApi.getStream(
        state.currentEpisode!.id,
        server.serverId,
        server.type,
      );

      state = state.copyWith(
        streamData: streamData,
        isLoading: false,
      );

      // Initialize video player if we have a stream URL
      if (streamData.streamUrl != null) {
        await _initializeVideoPlayer(streamData.streamUrl!);
      } else {
        state = state.copyWith(
          error: 'No streaming URL available for this server',
        );
      }
    } catch (e) {
      // Try fallback stream
      try {
        final fallbackStream = await _animeApi.getStreamFallback(
          state.currentEpisode!.id,
          server.serverId,
          server.type,
        );
        
        state = state.copyWith(
          streamData: fallbackStream,
          isLoading: false,
        );

        if (fallbackStream.streamUrl != null) {
          await _initializeVideoPlayer(fallbackStream.streamUrl!);
        }
      } catch (fallbackError) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load stream: $e (Fallback: $fallbackError)',
        );
      }
    }
  }

  /// Switches between sub and dub.
  ///
  /// [type] The new type to switch to ("sub" or "dub").
  Future<void> switchType(String type) async {
    if (type == state.selectedType || state.currentEpisode == null) return;

    state = state.copyWith(selectedType: type);

    // Find a server for the new type
    final serversForType = state.serversForCurrentType;
    if (serversForType.isNotEmpty) {
      await selectServer(serversForType.first);
    } else {
      state = state.copyWith(
        error: 'No $type servers available for this episode',
      );
    }
  }

  /// Toggles the server selector visibility.
  void toggleServerSelector() {
    state = state.copyWith(
      showServerSelector: !state.showServerSelector,
    );
  }

  /// Goes to the next episode if available.
  Future<void> nextEpisode() async {
    if (state.nextEpisode != null) {
      await loadEpisode(state.nextEpisode!);
    }
  }

  /// Goes to the previous episode if available.
  Future<void> previousEpisode() async {
    if (state.previousEpisode != null) {
      await loadEpisode(state.previousEpisode!);
    }
  }

  /// Jumps to a specific episode by index.
  ///
  /// [index] The episode index (0-based).
  Future<void> jumpToEpisode(int index) async {
    if (index >= 0 && index < state.episodes.length) {
      await loadEpisode(state.episodes[index]);
    }
  }

  /// Skips the intro if available.
  void skipIntro() {
    if (state.introSkipTarget != null && state.videoController != null) {
      state.videoController!.seekTo(state.introSkipTarget!);
    }
  }

  /// Skips the outro if available.
  void skipOutro() {
    if (state.outroSkipTarget != null && state.videoController != null) {
      state.videoController!.seekTo(state.outroSkipTarget!);
    }
  }

  /// Toggles subtitle visibility.
  void toggleSubtitles() {
    state = state.copyWith(
      subtitlesEnabled: !state.subtitlesEnabled,
    );
  }

  /// Sets the playback speed.
  ///
  /// [speed] The playback speed (e.g., 1.0 for normal, 1.25 for 1.25x).
  void setPlaybackSpeed(double speed) {
    if (state.videoController != null) {
      state.videoController!.setPlaybackSpeed(speed);
      state = state.copyWith(playbackSpeed: speed);
    }
  }

  /// Seeks to a specific position.
  ///
  /// [position] The position to seek to.
  void seekTo(Duration position) {
    if (state.videoController != null) {
      state.videoController!.seekTo(position);
    }
  }

  /// Toggles play/pause.
  void togglePlayPause() {
    if (state.videoController != null) {
      if (state.isPlaying) {
        state.videoController!.pause();
      } else {
        state.videoController!.play();
      }
    }
  }

  /// Initializes the video player with the given stream URL.
  Future<void> _initializeVideoPlayer(String streamUrl) async {
    try {
      final videoController = VideoPlayerController.networkUrl(Uri.parse(streamUrl));
      await videoController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showOptions: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightBlue,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        autoInitialize: true,
      );

      // Set up video controller listeners
      videoController.addListener(_onVideoControllerUpdate);

      state = state.copyWith(
        videoController: videoController,
        chewieController: chewieController,
        totalDuration: videoController.value.duration,
      );

      // Start position and skip timers
      _startPositionTimer();
      _startSkipTimer();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize video player: $e',
      );
    }
  }

  /// Disposes of the current video controllers.
  Future<void> _disposeControllers() async {
    _positionTimer?.cancel();
    _skipTimer?.cancel();

    if (state.videoController != null) {
      state.videoController!.removeListener(_onVideoControllerUpdate);
      await state.videoController!.dispose();
    }

    state.chewieController?.dispose();

    state = state.copyWith(
      videoController: null,
      chewieController: null,
      currentPosition: Duration.zero,
      totalDuration: Duration.zero,
      isPlaying: false,
      isBuffering: false,
    );
  }

  /// Handles video controller updates.
  void _onVideoControllerUpdate() {
    final controller = state.videoController;
    if (controller == null) return;

    state = state.copyWith(
      currentPosition: controller.value.position,
      totalDuration: controller.value.duration,
      isPlaying: controller.value.isPlaying,
      isBuffering: controller.value.isBuffering,
    );
  }

  /// Starts the position update timer.
  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.videoController != null) {
        _onVideoControllerUpdate();
      }
    });
  }

  /// Starts the skip button check timer.
  void _startSkipTimer() {
    _skipTimer?.cancel();
    _skipTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (state.videoController != null) {
        final shouldShowIntro = state.shouldShowIntroSkip;
        final shouldShowOutro = state.shouldShowOutroSkip;
        
        if (shouldShowIntro != state.showIntroSkip || 
            shouldShowOutro != state.showOutroSkip) {
          state = state.copyWith(
            showIntroSkip: shouldShowIntro,
            showOutroSkip: shouldShowOutro,
          );
        }
      }
    });
  }

  /// Clears any error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Resets the player to initial state.
  void reset() {
    _disposeControllers();
    state = const AnimePlayerState();
  }
}
