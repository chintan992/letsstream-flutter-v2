import 'package:lets_stream/src/core/models/video_source.dart';

class VideoPlayerState {
  final List<VideoSource> sources;
  final VideoSource? selectedSource;
  final bool isLoading;
  final String? errorMessage;
  final String? videoUrl;
  final bool isSwitchingSource;

  const VideoPlayerState({
    this.sources = const [],
    this.selectedSource,
    this.isLoading = true,
    this.errorMessage,
    this.videoUrl,
    this.isSwitchingSource = false,
  });

  VideoPlayerState copyWith({
    List<VideoSource>? sources,
    VideoSource? selectedSource,
    bool? isLoading,
    String? errorMessage,
    String? videoUrl,
    bool? isSwitchingSource,
  }) {
    return VideoPlayerState(
      sources: sources ?? this.sources,
      selectedSource: selectedSource ?? this.selectedSource,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      videoUrl: videoUrl ?? this.videoUrl,
      isSwitchingSource: isSwitchingSource ?? this.isSwitchingSource,
    );
  }
}