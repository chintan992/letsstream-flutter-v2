import 'package:lets_stream/src/core/models/video_source.dart';

class VideoPlayerState {
  final List<VideoSource> sources;
  final VideoSource? selectedSource;
  final bool isLoading;
  final String? errorMessage;
  final String? videoUrl;
  final bool isSwitchingSource;
  final int? seasonNumber;
  final int? episodeNumber;
  final int totalEpisodes;

  const VideoPlayerState({
    this.sources = const [],
    this.selectedSource,
    this.isLoading = true,
    this.errorMessage,
    this.videoUrl,
    this.isSwitchingSource = false,
    this.seasonNumber,
    this.episodeNumber,
    this.totalEpisodes = 0,
  });

  VideoPlayerState copyWith({
    List<VideoSource>? sources,
    VideoSource? selectedSource,
    bool? isLoading,
    String? errorMessage,
    String? videoUrl,
    bool? isSwitchingSource,
    int? seasonNumber,
    int? episodeNumber,
    int? totalEpisodes,
  }) {
    //print('VideoPlayerState.copyWith called with:');
    //if (selectedSource != null) print('  selectedSource: ${selectedSource.name}');
    //if (videoUrl != null) print('  videoUrl: $videoUrl');
    //if (isSwitchingSource != null) print('  isSwitchingSource: $isSwitchingSource');

    return VideoPlayerState(
      sources: sources ?? this.sources,
      selectedSource: selectedSource ?? this.selectedSource,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      videoUrl: videoUrl ?? this.videoUrl,
      isSwitchingSource: isSwitchingSource ?? this.isSwitchingSource,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
    );
  }
}
