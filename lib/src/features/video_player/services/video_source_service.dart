import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_source.dart';

class VideoSourceService {
  static const String _endpoint =
      'https://raw.githubusercontent.com/chintan992/letsstream2/refs/heads/main/src/utils/video-sources.json';

  Future<List<VideoSource>> fetchVideoSources() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final sources = (data['videoSources'] as List)
          .map((e) => VideoSource.fromJson(e))
          .toList();
      return sources;
    } else {
      throw Exception('Failed to load video sources');
    }
  }
}
