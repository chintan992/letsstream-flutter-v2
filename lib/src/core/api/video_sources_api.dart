
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lets_stream/src/core/models/video_source.dart';

class VideoSourcesApi {
  final Dio _dio;

  VideoSourcesApi(this._dio);

  Future<List<VideoSource>> getVideoSources() async {
    try {
      final response = await _dio.get('https://raw.githubusercontent.com/chintan992/letsstream2/refs/heads/main/src/utils/video-sources.json');
      final decoded = json.decode(response.data);
      final List<dynamic> sources = decoded['videoSources'];
      return sources.map((json) => VideoSource.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load video sources: $e');
    }
  }
}
