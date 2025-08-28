
import 'package:lets_stream/src/core/api/video_sources_api.dart';
import 'package:lets_stream/src/core/models/video_source.dart';

class VideoSourcesRepository {
  final VideoSourcesApi _api;

  VideoSourcesRepository(this._api);

  Future<List<VideoSource>> getVideoSources() {
    return _api.getVideoSources();
  }
}

// You might want to provide the repository using Riverpod like other services.
// For example, in a new file like `video_sources_provider.dart` or directly where you list your providers:

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dio/dio.dart';

// final videoSourcesApiProvider = Provider((ref) => VideoSourcesApi(Dio()));

// final videoSourcesRepositoryProvider = Provider((ref) => VideoSourcesRepository(ref.watch(videoSourcesApiProvider)));
