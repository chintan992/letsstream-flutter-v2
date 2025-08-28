
class VideoSource {
  final String key;
  final String name;
  final String movieUrlPattern;
  final String tvUrlPattern;

  VideoSource({
    required this.key,
    required this.name,
    required this.movieUrlPattern,
    required this.tvUrlPattern,
  });

  factory VideoSource.fromJson(Map<String, dynamic> json) {
    return VideoSource(
      key: json['key'],
      name: json['name'],
      movieUrlPattern: json['movieUrlPattern'],
      tvUrlPattern: json['tvUrlPattern'],
    );
  }
}
