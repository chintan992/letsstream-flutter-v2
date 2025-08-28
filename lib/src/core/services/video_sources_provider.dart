
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/api/video_sources_api.dart';
import 'package:lets_stream/src/core/services/video_sources_repository.dart';

final videoSourcesApiProvider = Provider((ref) => VideoSourcesApi(Dio()));

final videoSourcesRepositoryProvider = Provider((ref) => VideoSourcesRepository(ref.watch(videoSourcesApiProvider)));
