import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:lets_stream/src/core/models/anime/anime_info.dart';
import 'package:lets_stream/src/core/models/anime/anime_episode.dart';
import 'package:lets_stream/src/core/models/anime/anime_server.dart';
import 'package:lets_stream/src/core/models/anime/anime_stream.dart';

/// Represents the state of the anime player.
///
/// This state manages all aspects of anime playback including video controllers,
/// streaming data, server selection, and UI state.
class AnimePlayerState {
  /// The detailed anime information.
  final AnimeInfo? animeInfo;

  /// The list of episodes for the anime.
  final List<AnimeEpisode> episodes;

  /// The currently playing episode.
  final AnimeEpisode? currentEpisode;

  /// The list of available servers for the current episode.
  final List<AnimeServer> availableServers;

  /// The currently selected server.
  final AnimeServer? selectedServer;

  /// The streaming data for the current episode and server.
  final AnimeStream? streamData;

  /// The video player controller.
  final VideoPlayerController? videoController;

  /// The Chewie video player controller.
  final ChewieController? chewieController;

  /// Whether the player is currently loading.
  final bool isLoading;

  /// Any error message that occurred.
  final String? error;

  /// The selected audio type ("sub" or "dub").
  final String selectedType;

  /// Whether the server selector is currently visible.
  final bool showServerSelector;

  /// The current playback position in seconds.
  final Duration currentPosition;

  /// The total duration of the current episode.
  final Duration totalDuration;

  /// Whether the video is currently playing.
  final bool isPlaying;

  /// Whether the video is buffering.
  final bool isBuffering;

  /// The current playback speed.
  final double playbackSpeed;

  /// Whether subtitles are enabled.
  final bool subtitlesEnabled;

  /// The selected subtitle track.
  final String? selectedSubtitleTrack;

  /// Whether the intro skip button should be shown.
  final bool showIntroSkip;

  /// Whether the outro skip button should be shown.
  final bool showOutroSkip;

  /// Creates a new AnimePlayerState instance.
  const AnimePlayerState({
    this.animeInfo,
    this.episodes = const [],
    this.currentEpisode,
    this.availableServers = const [],
    this.selectedServer,
    this.streamData,
    this.videoController,
    this.chewieController,
    this.isLoading = false,
    this.error,
    this.selectedType = 'sub',
    this.showServerSelector = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
    this.isBuffering = false,
    this.playbackSpeed = 1.0,
    this.subtitlesEnabled = true,
    this.selectedSubtitleTrack,
    this.showIntroSkip = false,
    this.showOutroSkip = false,
  });

  /// Creates a copy of this state with updated fields.
  AnimePlayerState copyWith({
    AnimeInfo? animeInfo,
    List<AnimeEpisode>? episodes,
    AnimeEpisode? currentEpisode,
    List<AnimeServer>? availableServers,
    AnimeServer? selectedServer,
    AnimeStream? streamData,
    VideoPlayerController? videoController,
    ChewieController? chewieController,
    bool? isLoading,
    String? error,
    String? selectedType,
    bool? showServerSelector,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? isPlaying,
    bool? isBuffering,
    double? playbackSpeed,
    bool? subtitlesEnabled,
    String? selectedSubtitleTrack,
    bool? showIntroSkip,
    bool? showOutroSkip,
  }) {
    return AnimePlayerState(
      animeInfo: animeInfo ?? this.animeInfo,
      episodes: episodes ?? this.episodes,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      availableServers: availableServers ?? this.availableServers,
      selectedServer: selectedServer ?? this.selectedServer,
      streamData: streamData ?? this.streamData,
      videoController: videoController ?? this.videoController,
      chewieController: chewieController ?? this.chewieController,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedType: selectedType ?? this.selectedType,
      showServerSelector: showServerSelector ?? this.showServerSelector,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      subtitlesEnabled: subtitlesEnabled ?? this.subtitlesEnabled,
      selectedSubtitleTrack: selectedSubtitleTrack ?? this.selectedSubtitleTrack,
      showIntroSkip: showIntroSkip ?? this.showIntroSkip,
      showOutroSkip: showOutroSkip ?? this.showOutroSkip,
    );
  }

  /// Returns true if the player has successfully loaded a stream.
  bool get hasStream => streamData != null && videoController != null;

  /// Returns true if the player can play the current episode.
  bool get canPlay => hasStream && !isLoading && error == null;

  /// Returns true if there are multiple episodes available.
  bool get hasMultipleEpisodes => episodes.length > 1;

  /// Returns true if there are multiple servers available.
  bool get hasMultipleServers => availableServers.length > 1;

  /// Returns the current episode index (0-based).
  int get currentEpisodeIndex {
    if (currentEpisode == null || episodes.isEmpty) return -1;
    return episodes.indexWhere((ep) => ep.id == currentEpisode!.id);
  }

  /// Returns the next episode if available.
  AnimeEpisode? get nextEpisode {
    final index = currentEpisodeIndex;
    if (index >= 0 && index < episodes.length - 1) {
      return episodes[index + 1];
    }
    return null;
  }

  /// Returns the previous episode if available.
  AnimeEpisode? get previousEpisode {
    final index = currentEpisodeIndex;
    if (index > 0 && index < episodes.length) {
      return episodes[index - 1];
    }
    return null;
  }

  /// Returns true if there is a next episode available.
  bool get hasNextEpisode => nextEpisode != null;

  /// Returns true if there is a previous episode available.
  bool get hasPreviousEpisode => previousEpisode != null;

  /// Returns the available servers grouped by type.
  Map<String, List<AnimeServer>> get serversByType {
    final Map<String, List<AnimeServer>> grouped = {};
    for (final server in availableServers) {
      grouped.putIfAbsent(server.type, () => []).add(server);
    }
    return grouped;
  }

  /// Returns the servers for the currently selected type.
  List<AnimeServer> get serversForCurrentType {
    return serversByType[selectedType] ?? [];
  }

  /// Returns true if the current type (sub/dub) has servers available.
  bool get hasServersForCurrentType => serversForCurrentType.isNotEmpty;

  /// Returns the progress percentage (0.0 to 1.0).
  double get progressPercentage {
    if (totalDuration.inMilliseconds == 0) return 0.0;
    return currentPosition.inMilliseconds / totalDuration.inMilliseconds;
  }

  /// Returns the remaining duration.
  Duration get remainingDuration {
    return totalDuration - currentPosition;
  }

  /// Returns a formatted progress string (e.g., "10:30 / 24:00").
  String get formattedProgress {
    final current = _formatDuration(currentPosition);
    final total = _formatDuration(totalDuration);
    return '$current / $total';
  }

  /// Returns a formatted remaining time string (e.g., "13:30 remaining").
  String get formattedRemaining {
    final remaining = _formatDuration(remainingDuration);
    return '$remaining remaining';
  }

  /// Formats a duration as MM:SS or HH:MM:SS.
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Returns true if the player should show intro skip button.
  bool get shouldShowIntroSkip {
    if (!showIntroSkip || streamData?.streamingLink.intro == null) {
      return false;
    }
    
    final intro = streamData!.streamingLink.intro!;
    final currentSeconds = currentPosition.inSeconds;
    
    return currentSeconds >= intro.start && currentSeconds <= intro.end;
  }

  /// Returns true if the player should show outro skip button.
  bool get shouldShowOutroSkip {
    if (!showOutroSkip || streamData?.streamingLink.outro == null) {
      return false;
    }
    
    final outro = streamData!.streamingLink.outro!;
    final currentSeconds = currentPosition.inSeconds;
    
    return currentSeconds >= outro.start && currentSeconds <= outro.end;
  }

  /// Returns the intro skip target position.
  Duration? get introSkipTarget {
    if (streamData?.streamingLink.intro != null) {
      return Duration(seconds: streamData!.streamingLink.intro!.end);
    }
    return null;
  }

  /// Returns the outro skip target position.
  Duration? get outroSkipTarget {
    if (streamData?.streamingLink.outro != null) {
      return Duration(seconds: streamData!.streamingLink.outro!.start);
    }
    return null;
  }

  @override
  String toString() {
    return 'AnimePlayerState('
           'isLoading: $isLoading, '
           'hasStream: $hasStream, '
           'currentEpisode: ${currentEpisode?.episodeNo}, '
           'selectedType: $selectedType, '
           'isPlaying: $isPlaying'
           ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimePlayerState &&
        other.animeInfo?.data.id == animeInfo?.data.id &&
        other.currentEpisode?.id == currentEpisode?.id &&
        other.selectedServer?.serverId == selectedServer?.serverId &&
        other.selectedType == selectedType &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isPlaying == isPlaying &&
        other.currentPosition == currentPosition;
  }

  @override
  int get hashCode {
    return Object.hash(
      animeInfo?.data.id,
      currentEpisode?.id,
      selectedServer?.serverId,
      selectedType,
      isLoading,
      error,
      isPlaying,
      currentPosition,
    );
  }
}
