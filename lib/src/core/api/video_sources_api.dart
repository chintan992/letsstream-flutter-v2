import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lets_stream/src/core/models/video_source.dart';

/// API client for fetching video sources from external configuration.
///
/// This class handles communication with the video sources endpoint
/// to retrieve available streaming sources for the application.
class VideoSourcesApi {
  /// The HTTP client used for making API requests.
  final Dio _dio;

  /// Creates a new VideoSourcesApi instance.
  ///
  /// [_dio] The HTTP client to use for API requests.
  VideoSourcesApi(this._dio);

  /// Fetches the list of available video sources from the configuration endpoint.
  ///
  /// This method retrieves video streaming sources from a remote JSON configuration
  /// file. The sources are used to provide streaming options to users.
  ///
  /// Returns a [Future] that completes with a [List] of [VideoSource] objects
  /// representing the available streaming sources.
  ///
  /// Throws an [Exception] if the request fails or the response cannot be parsed.
  Future<List<VideoSource>> getVideoSources() async {
    try {
      final response = await _dio.get(
        'https://raw.githubusercontent.com/chintan992/letsstream2/refs/heads/main/src/utils/video-sources.json',
      );
      final decoded = json.decode(response.data);
      final List<dynamic> sources = decoded['videoSources'];
      return sources.map((json) => VideoSource.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load video sources: $e');
    }
  }
}
