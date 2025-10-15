/// Represents an anime episode.
///
/// This model encapsulates episode information including episode number,
/// identification, titles, and whether it's a filler episode.
class AnimeEpisode {
  /// The episode number (1-based).
  final int episodeNo;

  /// The unique identifier for this episode.
  final String id;

  /// The English title of the episode.
  final String title;

  /// The Japanese title of the episode.
  final String japaneseTitle;

  /// Whether this episode is filler content.
  final bool isFiller;

  /// Creates a new AnimeEpisode instance.
  const AnimeEpisode({
    required this.episodeNo,
    required this.id,
    required this.title,
    required this.japaneseTitle,
    this.isFiller = false,
  });

  /// Creates an AnimeEpisode instance from a JSON map.
  ///
  /// [json] A map containing episode data from the Anime API.
  factory AnimeEpisode.fromJson(Map<String, dynamic> json) {
    return AnimeEpisode(
      episodeNo: json['episode_no'] as int,
      id: json['id'] as String,
      title: json['title'] as String,
      japaneseTitle: json['japanese_title'] as String,
      isFiller: json['filler'] as bool? ?? false,
    );
  }

  /// Converts the AnimeEpisode instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'episode_no': episodeNo,
      'id': id,
      'title': title,
      'japanese_title': japaneseTitle,
      'filler': isFiller,
    };
  }

  /// Returns a formatted episode number string (e.g., "Episode 1", "Episode 25").
  String get formattedEpisodeNumber => 'Episode $episodeNo';

  /// Returns a short episode identifier (e.g., "EP01", "EP25").
  String get shortEpisodeId => 'EP${episodeNo.toString().padLeft(2, '0')}';

  /// Returns the display title, preferring English title if available.
  String get displayTitle => title.isNotEmpty ? title : japaneseTitle;

  /// Returns true if this episode has both English and Japanese titles.
  bool get hasBothTitles => title.isNotEmpty && japaneseTitle.isNotEmpty;

  @override
  String toString() {
    return 'AnimeEpisode(episodeNo: $episodeNo, title: $title, isFiller: $isFiller)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimeEpisode && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
