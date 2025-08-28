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
      key: json['key'] as String,
      name: json['name'] as String,
      movieUrlPattern: json['movieUrlPattern'] as String,
      tvUrlPattern: json['tvUrlPattern'] as String,
    );
  }
}
