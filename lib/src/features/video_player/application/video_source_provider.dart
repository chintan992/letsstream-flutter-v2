import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/video_source.dart';
import '../services/video_source_service.dart';

final videoSourceListProvider = FutureProvider<List<VideoSource>>((ref) async {
  final service = VideoSourceService();
  return await service.fetchVideoSources();
});

final selectedVideoSourceProvider = StateProvider<VideoSource?>((ref) => null);
